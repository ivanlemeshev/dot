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

golang_version=1.24.2
golang_archive=go${golang_version}.linux-amd64.tar.gz
golang_installation_path=/usr/local

print_header "Golang: installing"
curl -sO https://dl.google.com/go/${golang_archive}
[[ -d "${golang_installation_path}/go" ]] && sudo rm -rf "${golang_installation_path}/go"
sudo tar -C "${golang_installation_path}" -xzf go${golang_version}.linux-amd64.tar.gz
rm ${golang_archive}

go install github.com/golangci/golangci-lint/v2/cmd/golangci-lint@latest
