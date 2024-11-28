#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

PYTHON_VERSION="3.12.4"

print_header "Installing: Python"
mise use -g "python@${PYTHON_VERSION}"

print_header "Checking version: Python"
python -V
