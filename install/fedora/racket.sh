#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Racket packages"

MISE_BIN="$HOME/.local/bin/mise"
"$MISE_BIN" exec -- raco pkg install --auto --skip-installed racket-langserver
"$MISE_BIN" exec -- raco pkg install --auto --skip-installed sicp
