#!/bin/bash

# This option tells the shell to exit immediately if any command exits with a 
# non-zero status.
set -e

remove_all_docker_containers() {
  echo "--- Removing all Docker containers..."
  local CONTAINERS=$(docker ps -a -q)
  if [ -z "$CONTAINERS" ]; then
    echo "No containers to remove."
  else
    docker rm $CONTAINERS
    echo "All containers have been removed."
  fi
}

remove_all_docker_images() {
  local IMAGES=$(docker images -q)
  if [ -z "$IMAGES" ]; then
    echo "No images to remove."
  else
    echo "--- Removing all Docker images..."
    docker rmi $IMAGES
    echo "All images have been removed."
  fi
}

remove_all_docker_containers
remove_all_docker_images
