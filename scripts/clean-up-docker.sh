#!/bin/bash

# This option tells the shell to exit immediately if any command exits with a 
# non-zero status.
set -e

remove_all_docker_containers() {
    echo "--- Removing all Docker containers"
    local containers=$(docker ps -a -q)
    if [[ -z "$containers" ]]; then
        echo "No containers to remove."
    else
        docker rm $containers
        echo "All containers have been removed."
    fi
}

remove_all_docker_images() {
    local images=$(docker images -q)
    if [[ -z "$images" ]]; then
        echo "No images to remove."
    else
        echo "--- Removing all Docker images"
        docker rmi $images
        echo "All images have been removed."
    fi
}

remove_all_docker_containers
remove_all_docker_images
