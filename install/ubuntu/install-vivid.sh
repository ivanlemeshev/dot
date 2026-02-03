#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/scripts/functions/print_header.sh"

vivid_version=0.10.1

print_header "Vivid: installing version ${vivid_version}"
wget "https://github.com/sharkdp/vivid/releases/download/v${vivid_version}/vivid_${vivid_version}_amd64.deb"
sudo dpkg -i "vivid_${vivid_version}_amd64.deb"
rm "vivid_${vivid_version}_amd64.deb"
