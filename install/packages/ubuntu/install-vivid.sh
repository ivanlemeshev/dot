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

vivid_version=0.10.1

print_header "Vivid: installing version ${vivid_version}"
wget "https://github.com/sharkdp/vivid/releases/download/v${vivid_version}/vivid_${vivid_version}_amd64.deb"
sudo dpkg -i "vivid_${vivid_version}_amd64.deb"
rm "vivid_${vivid_version}_amd64.deb"
