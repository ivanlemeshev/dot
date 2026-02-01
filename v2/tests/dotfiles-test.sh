#!/usr/bin/env bash
# Docker test helper for dotfiles v2

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

# Get the absolute path to the script directory based on its location.
# ${BASH_SOURCE[0]} refers to the path of the currently executing script.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_NAME="dotfiles-test"
CONTAINER_NAME="dotfiles-test"

# shellcheck source=lib/ui.sh
source "${SCRIPT_DIR}/../lib/ui.sh"

ui.print_header "Building Docker Image for Dotfiles Test"

# Check if Docker is installed
if ! command -v docker >/dev/null 2>&1; then
  ui.print_error "Docker is not installed. Please install Docker first."
  exit 1
fi

# Clean up any existing container
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  ui.print_info "Existing container '${CONTAINER_NAME}' found."
  ui.print_info "Removing existing container..."
  docker rm -f "${CONTAINER_NAME}" >/dev/null 2>&1 || true
fi

# Build the Docker image
ui.print_info "Building Docker image '${IMAGE_NAME}'..."
docker build -t "${IMAGE_NAME}" -f "${SCRIPT_DIR}/Dockerfile" "${SCRIPT_DIR}/.."

ui.print_success "Docker image '${IMAGE_NAME}' built successfully."
