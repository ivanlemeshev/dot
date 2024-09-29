#!/bin/bash

source "$(dirname "$0")/functions/print_header.sh"

print_header "Removing configuration files for Neovim"

rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
