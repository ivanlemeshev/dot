#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing grpcurl"

MISE_BIN="$HOME/.local/bin/mise"
mkdir -p "$HOME/.local/bin"
"$MISE_BIN" exec -- env GOBIN="$HOME/.local/bin" \
  go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
log_info "Installed grpcurl to ~/.local/bin"
