#!/usr/bin/env bash

# Global variables for file paths
REPO_PATH="$PWD"
PACKAGE_PATH="$REPO_PATH/hello_world"

# Flags for file overwriting
overwrite_env_file=false
overwrite_keys_file=false

# Convert a string to lowercase
# Args:
#   $1: The string to convert
# Returns:
#   The lowercase version of the input string
to_lowercase() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

# Prompt the user to remove existing .env and keys.json files
# Sets global variables overwrite_env_file and overwrite_keys_file
prompt_to_remove() {
    if [[ -f "$REPO_PATH/.env" ]]; then 
        read -p "./.env file is already present, would you like to overwrite it?(Y/n) " overwrite_env
        lower_overwrite_env="$(to_lowercase "$overwrite_env")"
        if [[ "$lower_overwrite_env" == y* ]] || [[ -z "$lower_overwrite_env" ]]; then
            echo "Overwriting .env file"
            rm "$REPO_PATH/.env"
            touch "$REPO_PATH/.env"
            overwrite_env_file=true
        fi
    fi
    if [[ -f "$REPO_PATH/keys.json" ]]; then
        read -p "./keys.json is already present, would you like to overwrite(Y/n) " overwrite_keys
        lower_overwrite_keys="$(to_lowercase "$overwrite_keys")"
        if [[ "$lower_overwrite_keys" == y* ]] || [[ -z "$lower_overwrite_keys" ]]; then
            echo "Overwriting keys.json file"
            rm "$REPO_PATH/keys.json"
            touch "$REPO_PATH/keys.json"
            overwrite_keys_file=true
        fi
    fi
}

# Check if the keys.json file exists and is valid
# Exits with an error if the file is missing or invalid
check_existing_keys() {
    if [ -f "$REPO_PATH/keys.json" ]; then
        echo "Checking existing keys.json file..."
        
        # Check if the file is valid JSON
        if ! jq empty "$REPO_PATH/keys.json" 2>/dev/null; then
            echo "Error: keys.json is not a valid JSON file."
            exit 1
        fi

        # Check if the file contains an array of objects with 'address' keys
        key_count=$(jq '. | length' "$REPO_PATH/keys.json")
        if [ "$key_count" -eq 0 ]; then
            echo "Error: keys.json is empty."
            exit 1
        fi

        for i in $(seq 0 $((key_count-1))); do
            if ! jq -e ".[$i].address" "$REPO_PATH/keys.json" >/dev/null; then
                echo "Error: keys.json is missing 'address' for key $i."
                exit 1
            fi
        done

        echo "keys.json file is valid and contains $key_count keys."
    else
        echo "Error: $REPO_PATH/keys.json file not found."
        exit 1
    fi
}

# Set the ALL_PARTICIPANTS environment variable based on keys.json
# Appends the variable to the .env file
set_all_participants() {
    if [ -f "$REPO_PATH/hello_world/keys.json" ]; then
        # Create a JSON array of addresses
        ALL_PARTICIPANTS=$(jq -r '[.[].address] | tojson' "$REPO_PATH/hello_world/keys.json")
        # Wrap the JSON array in single quotes
        ALL_PARTICIPANTS=\'$ALL_PARTICIPANTS\'
        echo "ALL_PARTICIPANTS=$ALL_PARTICIPANTS" >> "$REPO_PATH/.env"
        echo "Set ALL_PARTICIPANTS=$ALL_PARTICIPANTS"
    else
        echo "$REPO_PATH/hello_world/keys.json not found, please add it or generate it"
        exit 1
    fi
}

# Set individual OWNER environment variables based on keys.json
# Appends the variables to the .env file
set_owners() {
    counter=0
    if [ -f "$REPO_PATH/hello_world/keys.json" ]; then
        jq -r '.[].address' "$REPO_PATH/hello_world/keys.json" | while read -r key; do
            echo "OWNER$counter=$key" >> "$REPO_PATH/.env"
            echo "Set OWNER$counter=$key"
            ((counter++))
        done
    else
        echo "$REPO_PATH/hello_world/keys.json was not found, please add or generate it"
        exit 1
    fi
}

# Export all environment variables from the .env file
export_environment_variables() {
    if [ -f "$REPO_PATH/.env" ]; then
        echo "Exporting environment variables from $REPO_PATH/.env"
        set -a
        source "$REPO_PATH/.env"
        set +a
        echo "Environment variables exported"
    else
        echo "Error: $REPO_PATH/.env file not found. Environment variables not set."
        exit 1
    fi
}

# Generate new Ethereum keys using the autonomy CLI
generate_keys() {
    cd "$REPO_PATH/hello_world"
    autonomy generate-key ethereum -n 4
    cp "$REPO_PATH/hello_world/keys.json" "$REPO_PATH/keys.json"
}

# Load existing keys from keys.json
load_keys() {
    if [ -f "$REPO_PATH/keys.json" ]; then
        echo "Existing keys found $REPO_PATH/keys.json. Copying..."
        cp "$REPO_PATH/keys.json" "$REPO_PATH/hello_world/keys.json"
    else
        echo "$REPO_PATH/keys.json not found. please add or generate them."
        exit 1
    fi
}

# Generate new keys or load existing ones based on the overwrite_keys_file flag
generate_or_load_keys() {
    if [[ "$overwrite_keys_file" == true ]]; then
        echo "Generating new keys..."
        generate_keys
    else
        echo "Checking existing keys..."
        check_existing_keys
        echo "Loading existing keys..."
        load_keys
    fi
}

# Load the .env file into the hello_world directory
load_env() {
    if [ -f "$REPO_PATH/.env" ]; then
        cp "$REPO_PATH/.env" "$REPO_PATH/hello_world/.env"
    else
        echo "$REPO_PATH/.env does not exist. Please add or generate one"
        exit 1
    fi
}

# Initialize the service by cleaning up previous installations and fetching the latest version
initialize() {
    if [ -d "$REPO_PATH/hello_world" ]; then
        echo "Cleaning up previous service"
        sudo rm -r "$REPO_PATH/hello_world"
    fi

    autonomy packages lock

    make clean

    autonomy push-all

    autonomy fetch --local --service valory/hello_world

    autonomy init --reset --author valory --remote --ipfs --ipfs-node "/dns/registry.autonolas.tech/tcp/443/https"

}

# Build the service image and deploy it
build() {
    cd "$REPO_PATH/hello_world"

    load_env

    autonomy build-image

    autonomy deploy build -ltm "$REPO_PATH/hello_world/keys.json"

    sudo chmod -R 777 "$REPO_PATH/hello_world"
}

# Run the deployed service
run() {
    autonomy deploy run --build-dir "$REPO_PATH/hello_world/abci_build"
}

# Main script execution
prompt_to_remove

initialize

generate_or_load_keys

if [[ "$overwrite_env_file" == true ]]; then
    set_all_participants
    set_owners
else
    check_existing_env
fi

export_environment_variables

build

run
