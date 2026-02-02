#!/bin/bash

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

# Get script and project paths
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PATH}")"
PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$(dirname "${SCRIPT_PATH}")")")")"

source "${PROJECT_ROOT}/lib/print_header.sh"

# https://github.com/yt-dlp/yt-dlp
ytdl_installation_path="/usr/local/bin"

print_header "YouTube-DL: installing"
sudo curl -o "${ytdl_installation_path}/yt-dlp" -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
sudo chmod +x "${ytdl_installation_path}/yt-dlp"
