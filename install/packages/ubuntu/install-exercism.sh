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

exercism_version=3.5.2

print_header "Exercism: installing version ${exercism_version}"

wget "https://github.com/exercism/cli/releases/download/v${exercism_version}/exercism-${exercism_version}-linux-x86_64.tar.gz"
mkdir ./exercism
tar -xf "exercism-${exercism_version}-linux-x86_64.tar.gz" -C ./exercism
sudo mv ./exercism/exercism /usr/local/bin
mv ./exercism/shell/exercism.fish $HOME/.config/fish/completions
rm "exercism-${exercism_version}-linux-x86_64.tar.gz"
rm -rf ./exercism
