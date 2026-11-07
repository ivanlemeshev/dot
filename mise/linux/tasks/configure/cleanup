#!/usr/bin/env bash
#MISE description="Remove unused packages and cached packages"

set -euo pipefail
. /etc/os-release
if [[ "$ID" == fedora ]]; then
  sudo dnf autoremove -y
  sudo dnf clean all
else
  sudo apt-get autoremove -y
  sudo apt-get autoclean -y
fi
