#!/bin/bash

set -e

source ./scripts/print.sh

# https://github.com/yt-dlp/yt-dlp
ytdl_installation_path="/usr/local/bin"

print_header "YouTube-DL: installing"
curl -o "${ytdl_installation_path}/yt-dlp" -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
chmod +x "${ytdl_installation_path}/yt-dlp"
