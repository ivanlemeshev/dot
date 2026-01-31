#!/usr/bin/env bash
# Go programming language installation module

set -e

# Tool metadata
TOOL_NAME="go"
TOOL_DESCRIPTION="Go programming language"
TOOL_CATEGORY="optional"

# Go version to install
GO_VERSION="1.24.2"

# Install Go
function install_package() {
  if command -v go > /dev/null 2>&1; then
    local current_version
    current_version="$(go version | awk '{print $3}' | sed 's/go//')"
    print_info "Go already installed: v${current_version}"
    return
  fi

  print_info "Installing Go ${GO_VERSION}..."

  local go_url="https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz"
  local temp_file="/tmp/go${GO_VERSION}.linux-amd64.tar.gz"

  wget -q "$go_url" -O "$temp_file"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "$temp_file"
  rm "$temp_file"

  print_success "Go ${GO_VERSION} installed"
}

# Post-install hook
function post_install() {
  print_info "Go is installed to /usr/local/go"
  print_info "GOROOT and GOPATH are configured in fish config"
  print_info "Add to your PATH: /usr/local/go/bin:\$GOPATH/bin"
}

# Main entry point
function main() {
  install_package
  post_install
}
