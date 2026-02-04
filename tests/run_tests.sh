#!/bin/bash

# Test runner script for dotfiles libraries
# Usage: ./lib/tests/run_tests.sh [test_file]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
GREEN="\033[0;32m"
RED="\033[0;31m"
RESET="\033[0m"

echo "========================================="
echo "Dotfiles Library Test Runner"
echo "========================================="
echo ""
echo "Test directory: $SCRIPT_DIR"
echo ""

# Check if BATS is installed
if ! command -v bats &>/dev/null; then
  echo -e "${RED}Error: BATS is not installed${RESET}"
  echo ""
  echo "Install BATS:"
  echo "  Ubuntu/Debian: sudo apt install bats"
  echo "  macOS:         brew install bats-core"
  echo "  From source:   git clone https://github.com/bats-core/bats-core.git && cd bats-core && sudo ./install.sh /usr/local"
  exit 1
fi

echo -e "${GREEN}✓ BATS found: $(bats --version)${RESET}"
echo ""

# Run tests
if [ -n "$1" ]; then
  # Run specific test file
  echo "Running specific test: $1"
  echo "========================================="
  bats "$SCRIPT_DIR/$1"
else
  # Run all tests
  echo "Running all tests..."
  echo "========================================="
  bats "$SCRIPT_DIR"/*.bats
fi

exit_code=$?

echo ""
echo "========================================="
if [ $exit_code -eq 0 ]; then
  echo -e "${GREEN}✓ All tests passed!${RESET}"
else
  echo -e "${RED}✗ Some tests failed${RESET}"
fi
echo "========================================="

exit $exit_code
