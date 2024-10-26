# Hello World agent service

Example of an autonomous service using the [Open Autonomy](https://docs.autonolas.network/open-autonomy/) framework. It comprises a set of 4 autonomous agents designed to achieve consensus. The objective is to decide which agent should print a "Hello World" message on its console in each iteration. Please refer to the [Open Autonomy documentation - Demos - Hello World](https://docs.autonolas.network/demos/hello-world/) for more detailed information.

## System requirements

- Python `>=3.10`
- [Tendermint](https://docs.tendermint.com/v0.34/introduction/install.html) `==0.34.19`
- [Pipenv](https://pipenv.pypa.io/en/latest/installation.html) `>=2021.x.xx`
- [Docker Engine](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- The [Open Autonomy](https://docs.autonolas.network/open-autonomy/guides/set_up/#set-up-the-framework) framework

## Prepare the environment

- Clone the repository:

      git clone git@github.com:valory-xyz/hello-world.git

- Create development environment:

      make new_env && pipenv shell

- Configure the Open Autonomy CLI:

      autonomy init --reset --author valory --remote --ipfs --ipfs-node "/dns/registry.autonolas.tech/tcp/443/https"

- Pull packages:

      autonomy packages sync --update-packages

## Deploy the service

- Fetch the service from the local registry:

      autonomy fetch valory/hello_world:0.1.0 --local --service --alias hello_world_service; cd hello_world_service

- Build the agent's service image:

      autonomy build-image

- Generate testing keys for 4 agents:

      autonomy generate-key ethereum -n 4

  This will generate a `keys.json` file.

- Export the environment variable `ALL_PARTICIPANTS`. You must use the 4 agent addresses found in `keys.json` above:

      export ALL_PARTICIPANTS='["0xAddress1", "0xAddress2", "0xAddress3", "0xAddress4"]'

- Build the deployment (Docker Compose):

      autonomy deploy build ./keys.json -ltm

- Run the deployment:

      autonomy deploy run --build-dir ./abci_build/

## Run Service Script - run_service.sh

For convenience, you can use the provided `run_service.sh` script to automate the setup, build, and deployment process. This script handles environment setup, key management, and service deployment in one go.

To use the script:

1. Ensure you have all the system requirements installed (Python, Tendermint, Pipenv, Docker, etc.).
2. Open a terminal in the project root directory.
3. Run the script:

```bash
bash run_service.sh
```

The script will:

- Clean up any previous service builds
- Update package hashes
- Push all packages to the local registry
- Fetch the Hello World service
- Initialize the service environment
- Build the service image
- Handle key management (generate new keys or use existing ones)
- Set up necessary environment variables
- Build and run the deployment

During execution, the script may prompt you for input to:
- Generate new keys if none exist
- Confirm overwriting of existing `.env` file
- Provide values for required environment variables

After running the script, the Hello World service should be up and running with four agents participating in the consensus process.

Note: Make sure to review and adjust any default values in the script as needed for your specific setup.
