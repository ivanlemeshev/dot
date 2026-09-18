#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 MANIFEST" >&2
  exit 2
fi

if [ ! -f "$1" ]; then
  echo "Manifest does not exist: $1" >&2
  exit 2
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required. Run v2/bin/bootstrap to install it." >&2
  exit 2
fi

packages=()
while IFS= read -r capability; do
  case "$capability" in
    git) packages+=(git) ;;
    '') ;;
    *)
      echo "Unsupported capability: $capability" >&2
      exit 2
      ;;
  esac
done <"$1"

brew install "${packages[@]}"
