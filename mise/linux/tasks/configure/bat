#!/usr/bin/env bash
#MISE description="Build the bat theme cache"

set -euo pipefail
if command -v batcat >/dev/null 2>&1; then bat_command=batcat; else bat_command=/usr/bin/bat; fi
"$bat_command" cache --build
"$bat_command" --list-themes | rg '^custom$'
