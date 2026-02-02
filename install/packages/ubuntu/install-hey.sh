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

print_header "Hey: installing"

hey_binary_url="https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64"
hey_installation_path=/usr/local/bin

print_header "Hey: downloading"
curl -O "${hey_binary_url}"

print_header "Hey: installing"
[[ -f "${hey_installation_path}/hey" ]] && sudo rm -rf "${hey_installation_path}/zig"
sudo mv "./hey_linux_amd64" "${hey_installation_path}/hey"
sudo chmod +x "${hey_installation_path}/hey"
