#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: bat"
sudo apt install -y bat

print_header "Installing: bat color theme"
[[ -d "${HOME}/.config/bat/themes" ]] || mkdir -p "${HOME}/.config/bat/themes"
[[ -f "${HOME}/.config/bat/themes/CatppuccinMocha.tmTheme" ]] || wget -O "${HOME}/.config/bat/themes/CatppuccinMocha.tmTheme" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
batcat cache --build
