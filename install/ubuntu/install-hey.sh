#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"



source "$PROJECT_ROOT/scripts/functions/print_header.sh"

print_header "Hey: installing"

hey_binary_url="https://hey-release.s3.us-east-2.amazonaws.com/hey_linux_amd64"
hey_installation_path=/usr/local/bin

print_header "Hey: downloading"
curl -O "${hey_binary_url}"

print_header "Hey: installing"
[[ -f "${hey_installation_path}/hey" ]] && sudo rm -rf "${hey_installation_path}/zig"
sudo mv "./hey_linux_amd64" "${hey_installation_path}/hey"
sudo chmod +x "${hey_installation_path}/hey"
