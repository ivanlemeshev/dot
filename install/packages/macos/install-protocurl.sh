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

protocurl_version=1.20.0
protocurl_archive=protocurl_${protocurl_version}_darwin_arm64.zip
protocurl_installation_path=/opt/protocurl

print_header "protocurl: installing"
curl -LO https://github.com/qaware/protocurl/releases/download/v${protocurl_version}/${protocurl_archive}
sudo rm -rf ${protocurl_installation_path}
sudo unzip ${protocurl_archive} -d ${protocurl_installation_path}
rm ${protocurl_archive}
