#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/scripts/functions/print_header.sh"

# https://github.com/yt-dlp/yt-dlp
ytdl_installation_path="/usr/local/bin"

print_header "YouTube-DL: installing"
sudo curl -o "${ytdl_installation_path}/yt-dlp" -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
sudo chmod +x "${ytdl_installation_path}/yt-dlp"
