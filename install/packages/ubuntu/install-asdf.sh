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

asdf_version=0.18.0
asdf_installation_path=/usr/local/bin

# https://github.com/asdf-vm/asdf
print_header "asdf: installing latest version"
curl -L -O https://github.com/asdf-vm/asdf/releases/download/v${asdf_version}/asdf-v${asdf_version}-linux-amd64.tar.gz
sudo tar -C "${asdf_installation_path}" -xzf asdf-v${asdf_version}-linux-amd64.tar.gz
rm asdf-v${asdf_version}-linux-amd64.tar.gz
