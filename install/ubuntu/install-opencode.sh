#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "OpenCode: installing"
curl -fsSL https://opencode.ai/install | bash
ln -sf "${PWD}/opencode.json" "${HOME}/.config/opencode/opencode.json"
