#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Bat: installing"
sudo apt-get install -y bat

print_header "Bat: installing themes"
[[ -d "${HOME}/.config/bat/themes" ]] || mkdir -p "${HOME}/.config/bat/themes"
[[ -f "${HOME}/.config/bat/themes/CatppuccinMocha.tmTheme" ]] || wget -O "${HOME}/.config/bat/themes/CatppuccinMocha.tmTheme" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
batcat cache --build
