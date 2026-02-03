#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"



source "$PROJECT_ROOT/scripts/functions/print_header.sh"

print_header "Node.js: installing latest version"
/usr/local/bin/asdf plugin add nodejs
/usr/local/bin/asdf install nodejs latest
/usr/local/bin/asdf set -u nodejs latest
