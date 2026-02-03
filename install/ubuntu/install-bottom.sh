#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"



source "$PROJECT_ROOT/scripts/functions/print_header.sh"

bottom_version=0.10.2
bottim_file_suffix=-1_amd64.deb

print_header "Bottom: installing"
curl -LO "https://github.com/ClementTsang/bottom/releases/download/${bottom_version}/bottom_${bottom_version}${bottim_file_suffix}"
sudo dpkg -i "bottom_${bottom_version}${bottim_file_suffix}"
rm "bottom_${bottom_version}${bottim_file_suffix}"
