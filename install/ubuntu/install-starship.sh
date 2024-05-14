#!/bin/bash

set -e

source ./scripts/print.sh
source ./scripts/prompt.sh

print_header "Congiguring: shell prompt"
if prompt_yes_no "Do you want to use starship (https://starship.rs)?"; then
    print_header "Installing: starship"
    curl -sS https://starship.rs/install.sh | sh

    print_header "Checking version: starship"
    starship -V

    print_header "Linking configs: starship"
    [[ -d "${HOME}/.config" ]] || mkdir -p "${HOME}/.config"
    ln -sf "${PWD}/starship.toml" "${HOME}/.config/starship.toml"
fi
