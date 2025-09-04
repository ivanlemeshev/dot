#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Installing: Rio Terminal"
brew install --cask rio

git clone https://github.com/catppuccin/rio.git "${PWD}/catppuccin-rio"
mv "${PWD}/catppuccin-rio/themes" "${HOME}/.config/rio/themes"
rm -rf "${PWD}/catppuccin-rio"

ln -sf "${PWD}/rio/config.toml" "${HOME}/.config/rio/config.toml"
