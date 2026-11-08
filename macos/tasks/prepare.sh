#!/usr/bin/env bash
#MISE description="Back up conflicting macOS configuration"

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
bash "$SCRIPT_DIR/../state.sh" prepare
