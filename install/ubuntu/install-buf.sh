#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

print_header "Buf: installing"

BUF_INSTALLATION_PATH="/usr/local/bin"
BUF_VERSION="1.50.0"

curl -sSL "https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-$(uname -s)-$(uname -m)" -o "./buf"
sudo mv "./buf" "${BUF_INSTALLATION_PATH}/buf"
sudo chmod +x "${BUF_INSTALLATION_PATH}/buf"
