#!/bin/bash

# This option tells the shell to exit immediately if any command exits with a
# non-zero status.
set -e

image_name="ivanlemeshev/workspace"
container_name="ivanlemeshev_workspace"
hostname="workspace"

build_workspace_image() {
    # Check if the Docker image exists.
    if [[ -z "$(docker images -q ${image_name} 2> /dev/null)" ]]; then
        echo "--- Building the Docker image ${image_name}"
        docker build -t "${image_name}" -f Dockerfile .
    fi
}

run_workspace_container() {
    # Check if the Docker container exists.
    if [[ -z "$(docker ps -aq -f name=${container_name} 2> /dev/null)" ]]; then
        echo "--- Creating a new Docker container ${container_name}"
        docker run -it -v $(pwd):/dot -h "${hostname}" --name "${container_name}" "${image_name}"
    else
        echo "--- Starting the existing Docker container ${container_name}"
        docker start -i "${container_name}"
    fi
}

echo "--- Run Ubuntu in a Docker container"
echo "--- It can be used as a workspace for development or a sandbox for experiments"
build_workspace_image
run_workspace_container
