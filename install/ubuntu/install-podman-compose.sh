#!/bin/bash

# See: https://podman-desktop.io/docs/podman/accessing-podman-from-another-wsl-instance

set -e

source ./scripts/print.sh

print_header "Installing: Podman Compose"
sudo curl -o /usr/local/bin/podman-compose https://raw.githubusercontent.com/containers/podman-compose/main/podman_compose.py
sudo chmod +x /usr/local/bin/podman-compose
