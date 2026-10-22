#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
source "$PROJECT_ROOT/lib/log.sh"
source "$PROJECT_ROOT/lib/print.sh"

print_section "Installing Ghostty"

sudo dnf install -y snapd

if [[ -f /.dockerenv || -f /run/.containerenv ]]; then
  command -v snap >/dev/null
  snap version
  log_info "Snap client is ready; Ghostty needs a systemd host"
  exit 0
fi

sudo systemctl enable --now snapd.socket

if [[ ! -e /snap && ! -L /snap ]]; then
  sudo ln -s /var/lib/snapd/snap /snap
elif [[ ! -L /snap || "$(readlink /snap)" != /var/lib/snapd/snap ]]; then
  log_error "/snap exists and does not point to /var/lib/snapd/snap"
  exit 1
fi

if ! snap list ghostty >/dev/null 2>&1; then
  sudo snap install ghostty --classic
fi

test -x /snap/bin/ghostty
/snap/bin/ghostty --version
log_info "Installed Ghostty from the Snap Store"
