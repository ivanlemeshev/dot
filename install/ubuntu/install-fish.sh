#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"



source "$PROJECT_ROOT/scripts/functions/print_header.sh"

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

print_header "Fish: installing plugin manager Fisher"
fish -C "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher && exit"

# https://github.com/PatrickF1/fzf.fish
print_header "Fish: fzf.fish"
fish -C "fisher install PatrickF1/fzf.fish && exit"
