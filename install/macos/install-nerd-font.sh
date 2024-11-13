#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: SauceCodePro Nerd Font"
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/SauceCodePro.tar.xz
sudo tar -xf ./SauceCodePro.tar.xz -C /Library/Fonts
