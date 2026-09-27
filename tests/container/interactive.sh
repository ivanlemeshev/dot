#!/usr/bin/env bash

set -euo pipefail

/opt/dotfiles/tests/container/verify-installation.sh "$1"

exec fish --login
