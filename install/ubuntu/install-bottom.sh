#!/bin/bash

set -e

source ./scripts/print.sh

BOTTOM_VERSION=0.10.2
BOTTIM_FILE_SUFFIX=-1_amd64.deb

print_header "Installing: bottom"
curl -LO "https://github.com/ClementTsang/bottom/releases/download/${BOTTOM_VERSION}/bottom_${BOTTOM_VERSION}${BOTTIM_FILE_SUFFIX}"
sudo dpkg -i "bottom_${BOTTOM_VERSION}${BOTTIM_FILE_SUFFIX}"
rm "bottom_${BOTTOM_VERSION}${BOTTIM_FILE_SUFFIX}"
