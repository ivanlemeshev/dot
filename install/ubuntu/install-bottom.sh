#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

bottom_version=0.10.2
bottim_file_suffix=-1_amd64.deb

print_header "Bottom: installing"
curl -LO "https://github.com/ClementTsang/bottom/releases/download/${bottom_version}/bottom_${bottom_version}${bottim_file_suffix}"
sudo dpkg -i "bottom_${bottom_version}${bottim_file_suffix}"
rm "bottom_${bottom_version}${bottim_file_suffix}"
