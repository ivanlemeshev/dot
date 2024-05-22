#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: neovim"
curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz
[[ -d /opt/nvim ]] && sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux64.tar.gz
rm nvim-linux64.tar.gz
