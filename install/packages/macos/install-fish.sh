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

print_header "Configuring: shell"

print_header "Installing: fish"
brew install fish
sudo chsh -s "$(which fish)" "$(whoami)"

print_header "Checking version: fish"
fish -v

print_header "Linking configs: fish"
[[ -d "${HOME}/.config/fish" ]] || mkdir -p "${HOME}/.config/fish"
ln -sf "${PWD}/config.fish" "${HOME}/.config/fish/config.fish"

# https://github.com/jorgebucaran/fisher
print_header "Installing: fisher"
fish -C "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && exit"

# https://github.com/PatrickF1/fzf.fish
print_header "Installing: PatrickF1/fzf.fish"
fish -C "fisher install PatrickF1/fzf.fish && exit"
