#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

vivid_version=0.10.1

print_header "Vivid: installing version ${vivid_version}"
wget "https://github.com/sharkdp/vivid/releases/download/v${vivid_version}/vivid_${vivid_version}_amd64.deb"
sudo dpkg -i "vivid_${vivid_version}_amd64.deb"
rm "vivid_${vivid_version}_amd64.deb"
