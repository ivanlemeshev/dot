#!/bin/bash

source scripts/print.sh
source scripts/prompt.sh

print_header "Removing configuration files: Neovim"

rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -rf ~/.local/state/nvim
