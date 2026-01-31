#!/usr/bin/env bash
# Zig programming language installation module

set -e

# Tool metadata
TOOL_NAME="zig"
TOOL_DESCRIPTION="Zig programming language"
TOOL_CATEGORY="optional"

# Zig version to install
ZIG_VERSION="0.13.0"

# Install Zig
function install_package() {
  if command -v zig > /dev/null 2>&1; then
    local current_version
    current_version="$(zig version)"
    ui.print_info "Zig already installed: v${current_version}"
    return
  fi

  ui.print_info "Installing Zig ${ZIG_VERSION}..."

  local zig_url="https://ziglang.org/download/${ZIG_VERSION}/zig-linux-x86_64-${ZIG_VERSION}.tar.xz"
  local temp_file="/tmp/zig-linux-x86_64-${ZIG_VERSION}.tar.xz"

  wget -q "$zig_url" -O "$temp_file"
  sudo mkdir -p /usr/local/zig
  sudo tar -C /usr/local -xf "$temp_file"
  sudo ln -sf "/usr/local/zig-linux-x86_64-${ZIG_VERSION}" /usr/local/zig
  sudo ln -sf /usr/local/zig/zig /usr/local/bin/zig
  rm "$temp_file"

  ui.print_success "Zig ${ZIG_VERSION} installed"
}

# Post-install hook
function post_install() {
  ui.print_info "Zig is installed to /usr/local/zig"
  ui.print_info "Zig binary is linked to /usr/local/bin/zig"
}

# Main entry point
function main() {
  install_package
  post_install
}
