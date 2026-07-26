#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing specify-cli"

SPECIFY_VERSION=0.14.2
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v$SPECIFY_VERSION
