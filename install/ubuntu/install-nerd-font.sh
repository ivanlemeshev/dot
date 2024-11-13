#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Fonts: installing SauceCodePro Nerd Font"
[[ -d "/usr/local/share/fonts" ]] || sudo mkdir -p "/usr/local/share/fonts"
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/SauceCodePro.tar.xz
sudo tar -xf ./SauceCodePro.tar.xz -C /usr/local/share/fonts
sudo fc-cache -fv
rm SauceCodePro.tar.xz
