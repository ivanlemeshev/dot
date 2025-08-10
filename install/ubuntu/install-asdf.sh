#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

asdf_version=0.18.0
asdf_installation_path=/usr/local/bin

# https://github.com/asdf-vm/asdf
print_header "asdf: installing latest version"
curl -L -O https://github.com/asdf-vm/asdf/releases/download/v${asdf_version}/asdf-v${asdf_version}-linux-amd64.tar.gz
sudo tar -C "${asdf_installation_path}" -xzf asdf-v${asdf_version}-linux-amd64.tar.gz
rm asdf-v${asdf_version}-linux-amd64.tar.gz
