#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/scripts/functions/print_header.sh"

GCLOUD_VERSION=476.0.0
GCLOUD_INSTALLATION_DIR="/usr/local/google-cloud-sdk"

print_header "Installing: gcloud"
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLOUD_VERSION}-darwin-x86_64.tar.gz

[[ -d "${GCLOUD_INSTALLATION_DIR}" ]] && sudo rm -rf "${GCLOUD_INSTALLATION_DIR}"

sudo tar -xf google-cloud-cli-${GCLOUD_VERSION}-darwin-x86_64.tar.gz -C /usr/local

sudo /usr/local/google-cloud-sdk/install.sh

rm google-cloud-cli-${GCLOUD_VERSION}-darwin-x86_64.tar.gz
