#!/usr/bin/env bash

set -euo pipefail

/opt/v2/test/run.sh

export PATH="$HOME/.local/bin:$PATH"
exec bash
