#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"



source "$PROJECT_ROOT/scripts/functions/print_header.sh"

print_header "Bat: installing"
sudo apt-get install -y bat

print_header "Bat: installing theme"
[[ -d "${HOME}/.config/bat/themes" ]] || mkdir -p "${HOME}/.config/bat/themes"
[[ -f "${HOME}/.config/bat/themes/CatppuccinMocha.tmTheme" ]] || wget -O "${HOME}/.config/bat/themes/CatppuccinMocha.tmTheme" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
batcat cache --build
