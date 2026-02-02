#!/bin/bash

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

# Get script and project paths
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PATH}")"
PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$(dirname "${SCRIPT_PATH}")")")")"

source "${PROJECT_ROOT}/lib/print_header.sh"

GCLOUD_VERSION=476.0.0
GCLOUD_INSTALLATION_DIR="/usr/local/google-cloud-sdk"

print_header "Installing: gcloud"
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_VERSION}-darwin-x86_64.tar.gz

[[ -d "${GCLOUD_INSTALLATION_DIR}" ]] && sudo rm -rf "${GCLOUD_INSTALLATION_DIR}"

sudo tar -xf google-cloud-cli-${GCLOUD_VERSION}-darwin-x86_64.tar.gz -C /usr/local

sudo /usr/local/google-cloud-sdk/install.sh

rm google-cloud-cli-${GCLOUD_VERSION}-darwin-x86_64.tar.gz
