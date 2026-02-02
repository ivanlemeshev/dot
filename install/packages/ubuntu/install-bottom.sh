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

bottom_version=0.10.2
bottim_file_suffix=-1_amd64.deb

print_header "Bottom: installing"
curl -LO "https://github.com/ClementTsang/bottom/releases/download/${bottom_version}/bottom_${bottom_version}${bottim_file_suffix}"
sudo dpkg -i "bottom_${bottom_version}${bottim_file_suffix}"
rm "bottom_${bottom_version}${bottim_file_suffix}"
