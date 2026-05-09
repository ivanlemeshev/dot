#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing grpcurl"

MISE_BIN="$HOME/.local/bin/mise"
GRPCURL_BIN_DIR="$HOME/.local/bin"

log_info "Installing grpcurl with mise-managed Go"
mkdir -p "$GRPCURL_BIN_DIR"
"$MISE_BIN" exec -- env GOBIN="$GRPCURL_BIN_DIR" go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest
