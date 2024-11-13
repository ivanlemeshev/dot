#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Fonts: installing RobotoMono Nerd Font"
[[ -d "/usr/local/share/fonts" ]] || sudo mkdir -p "/usr/local/share/fonts"
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/RobotoMono.tar.xz
sudo tar -xf ./RobotoMono.tar.xz -C /usr/local/share/fonts
sudo fc-cache -fv
rm RobotoMono.tar.xz
