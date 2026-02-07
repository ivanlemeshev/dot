#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing PowerShell"

log_info "Updating package lists"
sudo apt-get update

log_info "Installing prerequisites"
sudo apt-get install -y curl apt-transport-https software-properties-common

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

log_info "Downloading Microsoft repository GPG keys"
MS_DEB="packages-microsoft-prod.deb"
curl -fsSL "https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/$MS_DEB" \
  -o "$TMP_DIR/$MS_DEB"

log_info "Registering Microsoft repository GPG keys"
sudo dpkg -i "$TMP_DIR/$MS_DEB"

log_info "Updating package lists after adding Microsoft repository"
sudo apt-get update

log_info "Installing PowerShell"
sudo apt-get install -y powershell
