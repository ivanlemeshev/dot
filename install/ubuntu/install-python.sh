#!/bin/bash

set -e

source ./scripts/print.sh

PYTHON_VERSION="3.12.4"

print_header "Installing: Python"
fish -C "mise use -g python@${PYTHON_VERSION} && exit"
