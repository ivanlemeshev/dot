#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: Meslo Nerd Font"
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.tar.xz
sudo tar -xf ./Meslo.tar.xz -C /usr/local/share/fonts
sudo fc-cache -fv
