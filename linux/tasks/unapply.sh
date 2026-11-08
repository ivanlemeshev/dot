#!/usr/bin/env bash
#MISE description="Remove Linux configuration and restore desktop settings"

set -euo pipefail
. /etc/os-release
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
if [[ "$ID" == fedora ]]; then
  bash "$SCRIPT_DIR/../../fedora/state.sh" unapply
else
  bash "$SCRIPT_DIR/../../ubuntu/keyboard.sh" unapply
fi
mise dot unapply --yes
bash "$SCRIPT_DIR/../../linux/links.sh" restore
