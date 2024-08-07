#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: bat"
brew install bat

print_header "Installing: bat color theme"
[[ -d "${HOME}/.config/bat/themes" ]] || mkdir -p "${HOME}/.config/bat/themes"
[[ -f "${HOME}/.config/bat/themes/CatppuccinMacchiato.tmTheme" ]] || wget -O "${HOME}/.config/bat/themes/CatppuccinMacchiato.tmTheme" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
bat cache --build
