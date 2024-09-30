#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

python_version="3.12.4"

print_header "Python: installing version ${python_version}"
fish -C "mise use -g python@${python_version} && exit"
