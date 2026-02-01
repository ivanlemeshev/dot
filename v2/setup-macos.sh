#!/usr/bin/env bash
# Main setup orchestrator for macOS
# This script is sourced by ./setup, which sets DOTFILES_ROOT

ui.print_header "Setting up Dotfiles for macOS $OS_VERSION"

# Check and install Homebrew if needed
function ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    ui.print_success "Homebrew already installed: $(brew --version | head -1)"
    return 0
  fi

  ui.print_info "Homebrew not found. Installing..."

  # Install Homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for Apple Silicon
  if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  if command -v brew >/dev/null 2>&1; then
    ui.print_success "Homebrew installed successfully"
  else
    ui.print_error "Failed to install Homebrew"
    exit 1
  fi
}

# Install core tools
function install_core_tools() {
  local tools_dir="${DOTFILES_ROOT}/tools/core"

  if [[ ! -d "$tools_dir" ]]; then
    ui.print_warning "Core tools directory not found: $tools_dir"
    return
  fi

  ui.print_header "Installing Core Tools"

  for tool_dir in "$tools_dir"/*; do
    if [[ ! -d "$tool_dir" ]]; then
      continue
    fi

    local tool_name
    tool_name="$(basename "$tool_dir")"

    if [[ -f "$tool_dir/tool.sh" ]]; then
      ui.print_subheader "Installing: $tool_name"

      # Source and execute tool script in subshell to avoid variable pollution
      (
        cd "$tool_dir"
        # shellcheck source=/dev/null
        source "./tool.sh"
        if declare -f main >/dev/null; then
          main
        else
          ui.print_error "Tool $tool_name does not define a main() function"
          exit 1
        fi
      )

      ui.print_success "$tool_name installed successfully"
    else
      ui.print_warning "No tool.sh found for $tool_name, skipping"
    fi
  done
}

# Install optional tools (interactive)
function install_optional_tools() {
  local tools_dir="${DOTFILES_ROOT}/tools/optional"

  # Skip in non-interactive mode (e.g., Docker builds)
  if [[ ! -t 0 ]]; then
    ui.print_info "Non-interactive mode - skipping optional tools"
    return
  fi

  if [[ ! -d "$tools_dir" ]]; then
    ui.print_info "No optional tools directory found, skipping"
    return
  fi

  # Count optional tools
  local tool_count=0
  for tool_dir in "$tools_dir"/*; do
    if [[ -d "$tool_dir" ]] && [[ -f "$tool_dir/tool.sh" ]]; then
      tool_count=$((tool_count + 1))
    fi
  done

  if [[ $tool_count -eq 0 ]]; then
    ui.print_info "No optional tools available"
    return
  fi

  ui.print_header "Optional Tools"
  echo "The following optional tools are available:"

  # Install each optional tool with user prompt
  for tool_dir in "$tools_dir"/*; do
    if [[ ! -d "$tool_dir" ]]; then
      continue
    fi

    local tool_name
    tool_name="$(basename "$tool_dir")"

    if [[ -f "$tool_dir/tool.sh" ]]; then
      # Source the tool script to get description
      (
        # shellcheck source=/dev/null
        source "$tool_dir/tool.sh"

        # Prompt user
        read -rp "Install $tool_name? [y/N] " response
        case "$response" in
          [yY][eE][sS] | [yY])
            ui.print_subheader "Installing: $tool_name"
            cd "$tool_dir"
            if declare -f main >/dev/null; then
              main
              ui.print_success "$tool_name installed successfully"
            else
              ui.print_error "Tool $tool_name does not define a main() function"
            fi
            ;;
          *)
            ui.print_info "Skipping $tool_name"
            ;;
        esac
      )
    fi
  done
}

# Main execution
ensure_homebrew
pkg_update
install_core_tools
install_optional_tools

ui.print_header "Setup Complete!"
ui.print_success "Dotfiles v2 setup completed successfully!"
