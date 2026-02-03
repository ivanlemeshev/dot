#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/scripts/functions/print_header.sh"

print_header "OpenCode: installing"
brew install anomalyco/tap/opencode
ln -sf "${PWD}/opencode.json" "${HOME}/.config/opencode/opencode.json"
