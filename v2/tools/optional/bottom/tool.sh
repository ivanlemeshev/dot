#!/usr/bin/env bash
# Bottom (system monitor) installation module

set -e

# Tool metadata
TOOL_NAME="bottom"
TOOL_DESCRIPTION="Cross-platform system monitor"
TOOL_CATEGORY="optional"

# Bottom version to install
BOTTOM_VERSION="0.10.2"

# Install Bottom
function install_package() {
  if command -v btm > /dev/null 2>&1; then
    local current_version
    current_version="$(btm --version | awk '{print $2}')"
    ui.print_info "Bottom already installed: v${current_version}"
    return
  fi

  ui.print_info "Installing Bottom ${BOTTOM_VERSION}..."

  local bottom_url="https://github.com/ClementTsang/bottom/releases/download/${BOTTOM_VERSION}/bottom_${BOTTOM_VERSION}-1_amd64.deb"
  local temp_file="/tmp/bottom_${BOTTOM_VERSION}-1_amd64.deb"

  wget -q "$bottom_url" -O "$temp_file"
  sudo dpkg -i "$temp_file"
  rm "$temp_file"

  ui.print_success "Bottom ${BOTTOM_VERSION} installed"
}

# Post-install hook
function post_install() {
  ui.print_info "Bottom is available as 'btm' command"
  ui.print_info "Run 'btm' to launch the system monitor"
}

# Main entry point
function main() {
  install_package
  post_install
}
