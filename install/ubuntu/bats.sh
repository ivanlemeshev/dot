#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Note: Still using old functions until migration is complete
source "$PROJECT_ROOT/scripts/functions/print_header.sh"

print_header "Installing: BATS (Bash Automated Testing System)"

# Check if already installed
if command -v bats &>/dev/null; then
  echo "BATS is already installed: $(bats --version)"
  exit 0
fi

# Install BATS
echo "Installing BATS via apt..."
sudo apt-get update
sudo apt-get install -y bats

print_header "Checking version: BATS"
bats --version

print_header "BATS installation complete"
echo "You can now run tests with: bats tests/*.bats"
