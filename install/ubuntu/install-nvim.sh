#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Neovim: installing"
# http://github.com/neovim/neovim/blob/master/INSTALL.md#linux
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
[[ -d /opt/nvim ]] && sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
ln -sf "${PWD}/nvim" "${HOME}/.config/nvim"
