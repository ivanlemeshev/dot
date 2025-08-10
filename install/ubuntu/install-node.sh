#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Node.js: installing latest version"
/usr/local/bin/asdf plugin add nodejs
/usr/local/bin/asdf install nodejs latest
/usr/local/bin/asdf set -u nodejs latest
