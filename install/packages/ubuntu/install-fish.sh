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

# https://fishshell.com
print_header "Fish: installing"

sudo apt-add-repository -y ppa:fish-shell/release-3
sudo apt-get update
sudo apt-get install -y fish

print_header "Fish: changing the default shell"
sudo chsh -s "$(which fish)" "$(whoami)"

print_header "Fish: creating a symbolic link for the fish configuration file"
[[ -d "${HOME}/.config/fish" ]] || mkdir -p "${HOME}/.config/fish"
ln -sf "${PWD}/config.fish" "${HOME}/.config/fish/config.fish"

# https://github.com/PatrickF1/fzf.fish
fzf_fish_version="10.3"
fzf_fish_url="https://github.com/PatrickF1/fzf.fish/archive/refs/tags/v${fzf_fish_version}.tar.gz"
fzf_fish_archive="fzf.fish.tar.gz"

print_header "Fish: installing plugin manager Fisher"
fish -C "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && exit"

# https://github.com/PatrickF1/fzf.fish
print_header "Fish: fzf.fish"
fish -C "fisher install PatrickF1/fzf.fish && exit"
