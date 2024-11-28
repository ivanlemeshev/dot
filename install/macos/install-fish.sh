#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Congiguring: shell"

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
