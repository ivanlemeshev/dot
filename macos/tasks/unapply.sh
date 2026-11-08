#!/usr/bin/env bash
#MISE description="Remove macOS links and restore keyboard and terminal settings"

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
bash "$SCRIPT_DIR/../state.sh" unapply
