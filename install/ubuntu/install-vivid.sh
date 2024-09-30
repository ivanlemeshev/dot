#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

vivid_version=0.10.1

print_header "Vivid: installing version ${vivid_version}"
wget "https://github.com/sharkdp/vivid/releases/download/v${VIVID_VERSION}/vivid_${VIVID_VERSION}_amd64.deb"
sudo dpkg -i "vivid_${VIVID_VERSION}_amd64.deb"
rm "vivid_${VIVID_VERSION}_amd64.deb"
