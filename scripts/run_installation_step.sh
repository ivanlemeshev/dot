#!/bin/bash

set -e

# This script is a wrapper for running installation steps.
# It sources the header printing function and then executes the installation script passed as an argument.
# This avoids duplicating the same boilerplate code in every installation script.

source "$(dirname "$0")/functions/print_header.sh"

if [ -f "$1" ]; then
  source "$1"
else
  echo "Error: Installation script not found at '$1'"
  exit 1
fi
