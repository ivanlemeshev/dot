#!/usr/bin/env bash

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
. "$SCRIPT_DIR/../unix/state.sh"
RECORDS="$HOME/.local/state/dotfiles-linux/links.json"
case "${1:-}" in
  prepare) prepare_configuration "$RECORDS" ;;
  restore) restore_configuration "$RECORDS" ;;
  *)
    printf 'Use prepare or restore.\n' >&2
    exit 1
    ;;
esac
