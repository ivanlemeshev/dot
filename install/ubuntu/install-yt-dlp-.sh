#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

# https://github.com/yt-dlp/yt-dlp
ytdl_installation_path="/usr/local/bin"

print_header "YouTube-DL: installing"
sudo curl -o "${ytdl_installation_path}/yt-dlp" -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
sudo chmod +x "${ytdl_installation_path}/yt-dlp"
