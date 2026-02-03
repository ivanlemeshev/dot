#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

source "$PROJECT_ROOT/scripts/functions/print_header.sh"

print_header "Terraform: installing"

hashicorp_repo="deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
target_file="/etc/apt/sources.list.d/hashicorp.list"

wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
grep -qF "$hashicorp_repo" "$target_file" 2>/dev/null || echo "$hashicorp_repo" | sudo tee "$target_file" >/dev/null
sudo apt update && sudo apt install terraform
