#!/bin/bash

set -e

source "$(dirname "$0")/../../scripts/functions/print_header.sh"

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
