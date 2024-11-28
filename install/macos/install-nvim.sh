#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Installing: neovim"
brew install nvim

ln -sf "${PWD}/nvim" "${HOME}/.config/nvim"
