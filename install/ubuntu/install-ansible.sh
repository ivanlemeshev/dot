#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Ansible: installing"
python3 -m pip install --user ansible
