#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

# https://github.com/yt-dlp/yt-dlp
print_section "Installing yt-dlp"

YT_DLP_INSTALLATION_PATH="/usr/local/bin"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

log_info "Downloading yt-dlp"

curl -fsSL https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp \
  -o "$TMP_DIR/yt-dlp"

log_info "Installing yt-dlp to ${YT_DLP_INSTALLATION_PATH}"
sudo install -m 755 "$TMP_DIR/yt-dlp" "${YT_DLP_INSTALLATION_PATH}/yt-dlp"
