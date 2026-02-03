#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/scripts/functions/print_header.sh"

print_header "Btop: installing"
sudo apt-get update
sudo apt-get install -y btop

wget https://github.com/catppuccin/btop/releases/download/1.0.0/themes.tar.gz
sudo tar -C "${HOME}/.config/btop" -xzf themes.tar.gz
rm themes.tar.gz
