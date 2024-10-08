#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Fonts: installing JetBrainsMono Nerd Font"
[[ -d "/usr/local/share/fonts" ]] || sudo mkdir -p "/usr/local/share/fonts"
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
sudo tar -xf ./JetBrainsMono.tar.xz -C /usr/local/share/fonts
sudo fc-cache -fv
rm JetBrainsMono.tar.xz
