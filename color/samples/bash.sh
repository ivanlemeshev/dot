#!/usr/bin/env bash

# Shell sample for export, variables, functions, and loops.

set -euo pipefail

export APP_NAME="theme-sample"
export APP_MODE="${APP_MODE:-dev}"

greet() {
  local name="${1:-world}"
  printf 'hello %s\n' "$name"
}

for item in one two three; do
  if [[ "$item" == "two" ]]; then
    greet "$item"
  else
    printf '%s\n' "$item"
  fi
done

case "$APP_MODE" in
  dev) echo "development" ;;
  prod) echo "production" ;;
  *) echo "other" ;;
esac
