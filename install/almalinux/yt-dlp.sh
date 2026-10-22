#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing yt-dlp"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

curl -fsSL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
  -o "$TMP_DIR/yt-dlp"
sudo install -m 755 "$TMP_DIR/yt-dlp" /usr/local/bin/yt-dlp
log_info "Installed yt-dlp to /usr/local/bin"
