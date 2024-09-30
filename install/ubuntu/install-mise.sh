#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

mise_installation_path=/usr/local/bin

# https://github.com/jdx/mise
print_header "Mise: installing latest version"
wget "https://mise.jdx.dev/mise-latest-linux-x64" -O "./mise"
sudo mv "./mise" "${mise_installation_path}/mise"
sudo chmod +x "${mise_installation_path}/mise"
