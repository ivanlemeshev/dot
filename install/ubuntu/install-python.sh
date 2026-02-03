#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"



source "$PROJECT_ROOT/scripts/functions/print_header.sh"

print_header "UV: installing"
curl -LsSf https://astral.sh/uv/install.sh | sh

print_header "Python: installing"
fish -C "uv python install && exit"
