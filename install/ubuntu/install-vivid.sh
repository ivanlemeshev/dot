#!/bin/bash

set -e

source ./scripts/print.sh

VIVID_VERSION=0.10.1

print_header "Installing: vivid"
wget "https://github.com/sharkdp/vivid/releases/download/v${VIVID_VERSION}/vivid_${VIVID_VERSION}_amd64.deb"
sudo dpkg -i "vivid_${VIVID_VERSION}_amd64.deb"
rm "vivid_${VIVID_VERSION}_amd64.deb"
