#!/usr/bin/env bash

REPO_PATH="$PWD"
PACKAGE_PATH="$REPO_PATH/hello_world"

# declare -A required_vars=(
#     ["ETHEREUM_LEDGER_RPC_0"]="http://localhost:8545"
#     ["ETHEREUM_LEDGER_CHAIN_ID"]="null"
#     ["SAFE_CONTRACT_ADDRESS"]="0x0000000000000000000000000000000000000000"
#     ["TENDERMINT_P2P_URL"]="localhost:26656"
#     ["TENDERMINT_URL"]="http://localhost:26657"
# )

# declare -A required_vars=(
#   ["ALL_PARTICIPANTS"]='[]'
#   ["OWNER0"]=""
#   ["OWNER1"]=""
#   ["OWNER2"]=""
#   ["OWNER3"]=""
# )


overwrite_env_file=false
overwrite_keys_file=false

to_lowercase() {
    echo "$1" | tr '[:upper:]' '[:lower:]'
}

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

# check_existing_env() {
#     if [[ -f "$REPO_PATH/.env" ]]; then
#         echo "Checking existing .env file..."
#         missing_vars=()
#         for var in "${!required_vars[@]}"; do
#             if ! grep -q "^$var=" "$REPO_PATH/.env"; then
#                 missing_vars+=("$var")
#             fi
#         done
        
#         if [[ ${#missing_vars[@]} -gt 0 ]]; then
#             echo "The following required variables are missing from .env:"
#             for var in "${missing_vars[@]}"; do
#                 echo "$var"
#                 read -p "Please enter a value or hit enter to use default [${required_vars[$var]}]: " user_input
#                 echo "$var=${user_input:-${required_vars[$var]}}" >> "$REPO_PATH/.env"
#                 echo "Set environment variable $var=${user_input:-${required_vars[$var]}}"
#             done
#         else
#             echo "All required variables are present in .env"
#         fi
#     else
#         echo "Error: $REPO_PATH/.env file not found."
#         exit 1
#     fi
# }

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

# set_variables() {
#     for var in "${!required_vars[@]}"; do
#         if [[ -z "${!var}" ]]; then
#             echo "$var is not set."
#             read -p "Please enter a value or hit enter to use default [${required_vars[$var]}]: " user_input
#             echo "$var=${user_input:-${required_vars[$var]}}" >> "$REPO_PATH/.env"
#             echo "Set environment variable $var=${user_input:-${required_vars[$var]}}"
#         fi
#     done
# }

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

generate_keys() {
    cd "$REPO_PATH/hello_world"
    autonomy generate-key ethereum -n 4
    cp "$REPO_PATH/hello_world/keys.json" "$REPO_PATH/keys.json"
}

load_keys() {
    if [ -f "$REPO_PATH/keys.json" ]; then
        echo "Existing keys found $REPO_PATH/keys.json. Copying..."
        cp "$REPO_PATH/keys.json" "$REPO_PATH/hello_world/keys.json"
    else
        echo "$REPO_PATH/keys.json not found. please add or generate them."
        exit 1
    fi
}

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

load_env() {
    if [ -f "$REPO_PATH/.env" ]; then
        cp "$REPO_PATH/.env" "$REPO_PATH/hello_world/.env"
    else
        echo "$REPO_PATH/.env does not exist. Please add or generate one"
        exit 1
    fi
}

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

build() {
    cd "$REPO_PATH/hello_world"

    load_env

    autonomy build-image

    autonomy deploy build -ltm "$REPO_PATH/hello_world/keys.json"

    sudo chmod -R 777 "$REPO_PATH/hello_world"
}

run() {
    autonomy deploy run --build-dir "$REPO_PATH/hello_world/abci_build"
}

prompt_to_remove

initialize

generate_or_load_keys

if [[ "$overwrite_env_file" == true ]]; then
    set_all_participants
    set_owners
    # set_variables
else
    check_existing_env
fi

export_environment_variables

build

run
