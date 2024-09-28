#!/bin/bash

set -e

source ./scripts/print.sh

print_header "Installing: Ranger"
[[ -f "/usr/local/bin/ranger" ]] && sudo rm "/usr/local/bin/ranger"
git clone https://github.com/hut/ranger.git
cd ranger
sudo make install
cd ..
sudo rm -rf ranger
