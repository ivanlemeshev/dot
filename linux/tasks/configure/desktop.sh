#!/usr/bin/env bash
#MISE description="Configure the Linux desktop terminal and keyboard"

set -euo pipefail
. /etc/os-release
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
if [[ "$ID" == fedora ]]; then
  bash "$SCRIPT_DIR/../../../fedora/state.sh" apply
else
  bash "$SCRIPT_DIR/../../../ubuntu/keyboard.sh" apply
fi
