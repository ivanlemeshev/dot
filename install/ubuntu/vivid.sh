#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

if [[ -f "$PROJECT_ROOT/config.env" ]]; then
  source "$PROJECT_ROOT/config.env"
fi

print_section "Installing vivid"

VIVID_VERSION=0.10.1
VIVID_DEB="vivid_${VIVID_VERSION}_amd64.deb"
VIVID_URL="https://github.com/sharkdp/vivid/releases/download"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

log_info "Downloading vivid package"
curl -fsSL "$VIVID_URL/v${VIVID_VERSION}/$VIVID_DEB" -o "$TMP_DIR/$VIVID_DEB"

log_info "Installing vivid package"
sudo dpkg -i "$TMP_DIR/$VIVID_DEB"
