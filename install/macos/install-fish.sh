#!/bin/bash

set -e

source scripts/print.sh
source scripts/prompt.sh

print_header "Congiguring: shell"
if prompt_yes_no "Do you want to use the fish shell (https://fishshell.com)?"; then
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
fi
