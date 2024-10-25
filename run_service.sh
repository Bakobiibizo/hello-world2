#!/usr/bin/env bash

# This script automates the process of setting up, building, and running the "hello_world" service.
# It handles environment setup, key management, and service deployment.

REPO_PATH="$PWD"
PACKAGE_PATH="$REPO_PATH/hello_world"

# Define required_vars (example, adjust as needed)
declare -A required_vars=(
    ["ETHEREUM_LEDGER_RPC_0"]="https://goerli.infura.io/v3/YOUR_INFURA_KEY"
    ["ETHEREUM_LEDGER_CHAIN_ID"]="5"
    ["SAFE_CONTRACT_ADDRESS"]="0x123..."
    ["TENDERMINT_P2P_URL"]="http://localhost:26656"
    ["TENDERMINT_URL"]="http://localhost:26657"
)

if [ -d "hello_world" ]; then
    echo "Cleaning up previous service"
    sudo rm -r hello_world
fi

# Function to convert string to lowercase
to_lowercase() {
    # This function converts the input string to lowercase
    # Args:
    #   $1: The string to convert
    # Returns:
    #   The lowercase version of the input string
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

# Remove previous service build
if test -d hello_world; then
    echo "Removing previous service build"
    sudo rm -r hello_world
fi

# Ensure hashes are updated
autonomy packages lock

# Push packages and fetch service
make clean

# Push packages
autonomy push-all

# Fetch service
autonomy fetch --local --service valory/hello_world

# Navigate to service directory
cd hello_world

# Initialize the service
autonomy init --reset --author valory --remote --ipfs --ipfs-node "/dns/registry.autonolas.tech/tcp/443/https"

# Build the image
autonomy build-image

# Copy the keys and build the deployment
if [ ! -f "$REPO_PATH/keys.json" ]; then
    read -p "No keys found at $REPO_PATH/keys.json. Would you like to generate new ones? (y/n) " generate_keys
    generate_keys=$(to_lowercase "$generate_keys")
    if [[ $generate_keys == y* ]]; then
        echo "Generating new keys..."
        autonomy generate-key ethereum -n 4
        cp "$REPO_PATH/hello_world/keys.json" "$REPO_PATH/keys.json"
    else
        echo "No keys available. Exiting"
        exit 1
    fi
else
    cp "$REPO_PATH/keys.json" "$REPO_PATH/hello_world/keys.json"
fi

set_environment_variables() {
    # This function sets up environment variables for the service
    # It prompts for missing required variables and saves them to .env file
    # It also sets up ALL_PARTICIPANTS and OWNER variables based on keys.json
    
    echo "Saving variables to $REPO_PATH/.env"
    ALL_PARTICIPANTS=$(jq -r '.[].address' ./keys.json | jq -R . | jq -sc .)
    export ALL_PARTICIPANTS
    echo "ALL_PARTICIPANTS=$ALL_PARTICIPANTS" >> "$REPO_PATH/.env"
    echo "Set environment variable ALL_PARTICIPANTS=$ALL_PARTICIPANTS"

    counter=1
    for key in $(echo "$ALL_PARTICIPANTS" | jq -r '.[]'); do
        export "OWNER$counter=${key}" 
        echo "OWNER$counter=${key}" >> "$REPO_PATH/.env"
        echo "Set environment variable OWNER$counter=${key}"
        ((counter++))
    done

    for var in "${!required_vars[@]}"; do
        if [ -z "${!var}" ]; then
            echo "$var is not set."
            read -p "Please enter a value or hit enter to use default [${required_vars[$var]}]: " user_input
            export "$var"="${user_input:-${required_vars[$var]}}"
            echo "$var=${user_input:-${required_vars[$var]}}" >> "$REPO_PATH/.env"
            echo "Set environment variable $var=${user_input:-${required_vars[$var]}}"
        fi
    done
}

if [ -f "$REPO_PATH/.env" ]; then
    # Clear existing .env file to avoid duplicates
    read -p "$REPO_PATH/.env exists, overwrite it?(Y/n) " overwrite_env
    overwrite_env=$(to_lowercase "$overwrite_env")
    if [[ $overwrite_env == y* ]]; then
        set_environment_variables
    fi
else
    set_environment_variables
fi

# Copy .env file to the correct location (assuming 'hello_world' is correct)
cp "$REPO_PATH/.env" "$REPO_PATH/hello_world/.env"

# Build the deployment
autonomy deploy build -ltm

sudo chmod -R 777 .

# Export environment variables from .env file
if [ -f "$REPO_PATH/.env" ]; then
    echo "Exporting environment variables from $REPO_PATH/.env"
    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ ! "$line" =~ ^# && -n "$line" ]]; then
            export "$line"
            echo "Exported: $line"
        fi
    done < "$REPO_PATH/.env"
else
    echo "Warning: $REPO_PATH/.env file not found. Environment variables may not be set correctly."
fi

# Run the deployment
autonomy deploy run --build-dir abci_build/
