#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: JetBrainsMono Nerd Font"
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
sudo tar -xf ./JetBrainsMono.tar.xz -C /usr/local/share/fonts
sudo fc-cache -fv
