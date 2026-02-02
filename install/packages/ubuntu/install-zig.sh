#!/bin/bash

# Enable strict error handling
# -e: Exit immediately if a command exits with a non-zero status.
# -u: Treat unset variables as an error when substituting.
# -o pipefail: Ensures pipes return the exit code of the last command to fail.
set -euo pipefail

# Get script and project paths
SCRIPT_PATH="$(realpath "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname "${SCRIPT_PATH}")"
PROJECT_ROOT="$(dirname "$(dirname "$(dirname "$(dirname "${SCRIPT_PATH}")")")")"

source "${PROJECT_ROOT}/lib/print_header.sh"

print_header "Zig: installing"

current_arch=$(uname -i)
print_header "Zig: installing Zig for ${current_arch} architecture"

zig_version=0.13.0
zig_archive="zig-linux-${current_arch}-${zig_version}.tar.xz"
zig_installation_path=/usr/local

print_header "Zig: downloading Zig ${zig_version}"
curl -O "https://ziglang.org/download/${zig_version}/${zig_archive}"

print_header "Zig: installing Zig ${zig_version}"
[[ -d "${zig_installation_path}/zig" ]] && sudo rm -rf "${zig_installation_path}/zig"
sudo tar -C "${zig_installation_path}" -xf "${zig_archive}"
sudo mv "${zig_installation_path}/zig-linux-${current_arch}-${zig_version}" "${zig_installation_path}/zig"

print_header "Zig: cleaning up"
rm "${zig_archive}"
