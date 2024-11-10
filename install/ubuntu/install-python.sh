#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "UV: installing"
curl -LsSf https://astral.sh/uv/install.sh | sh

print_header "Python: installing"
fish -C "uv python install && exit"
