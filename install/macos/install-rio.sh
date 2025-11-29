#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Installing: Rio Terminal"
brew install --cask rio
git clone https://github.com/catppuccin/rio.git ./rio-themes
mkdir -p "${HOME}/.config/rio/themes"
cp ./rio-themes/themes/* "${HOME}/.config/rio/themes/"
rm -rf ./rio-themes
ln -sf "${PWD}/rio.toml" "${HOME}/.config/rio/config.toml"
