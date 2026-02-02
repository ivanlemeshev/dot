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

print_header "Neovim: installing"
# http://github.com/neovim/neovim/blob/master/INSTALL.md#linux
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
[[ -d /opt/nvim ]] && sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
ln -sf "${PWD}/nvim" "${HOME}/.config/nvim"
