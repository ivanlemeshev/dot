#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: RobotoMono Nerd Font"
curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/RobotoMono.tar.xz
sudo tar -xf ./RobotoMono.tar.xz -C /Library/Fonts
