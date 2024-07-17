#!/bin/bash

set -e

source ./scripts/print.sh

INSTALLATION_PATH="${HOME}/.local/bin"

# https://github.com/yt-dlp/yt-dlp
print_header "Installing: yt-dlp"
[[ ! -d "${INSTALLATION_PATH}" ]] && mkdir -p "${INSTALLATION_PATH}"
curl -o "${INSTALLATION_PATH}/yt-dlp" -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
chmod +x "${INSTALLATION_PATH}/yt-dlp"
