#!/usr/bin/env bash
# Main setup orchestrator for Ubuntu 24.04

set -e

# Get the dotfiles root directory
DOTFILES_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export DOTFILES_ROOT

print_header "Setting up dotfiles for Ubuntu 24.04"

# Update package repositories
pkg_update

# Install core tools
function install_core_tools() {
  local tools_dir="${DOTFILES_ROOT}/tools/core"

  if [[ ! -d "$tools_dir" ]]; then
    print_warning "Core tools directory not found: $tools_dir"
    return
  fi

  print_header "Installing Core Tools"

  for tool_dir in "$tools_dir"/*; do
    if [[ ! -d "$tool_dir" ]]; then
      continue
    fi

    local tool_name
    tool_name="$(basename "$tool_dir")"

    if [[ -f "$tool_dir/tool.sh" ]]; then
      print_header "Installing: $tool_name"

      # Source and execute tool script in subshell to avoid variable pollution
      (
        cd "$tool_dir"
        # shellcheck source=/dev/null
        source "./tool.sh"
        if declare -f main > /dev/null; then
          main
        else
          error "Tool $tool_name does not define a main() function"
          exit 1
        fi
      )

      print_success "$tool_name installed successfully"
    else
      print_warning "No tool.sh found for $tool_name, skipping"
    fi
  done
}

# Install optional tools (interactive)
function install_optional_tools() {
  local tools_dir="${DOTFILES_ROOT}/tools/optional"

  if [[ ! -d "$tools_dir" ]]; then
    print_info "No optional tools directory found, skipping"
    return
  fi

  # Count optional tools
  local tool_count=0
  for tool_dir in "$tools_dir"/*; do
    if [[ -d "$tool_dir" ]] && [[ -f "$tool_dir/tool.sh" ]]; then
      ((tool_count++))
    fi
  done

  if [[ $tool_count -eq 0 ]]; then
    print_info "No optional tools available"
    return
  fi

  print_header "Optional Tools"
  echo ""
  echo "The following optional tools are available:"
  echo ""

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
          [yY][eE][sS]|[yY])
            print_header "Installing: $tool_name"
            cd "$tool_dir"
            if declare -f main > /dev/null; then
              main
              print_success "$tool_name installed successfully"
            else
              error "Tool $tool_name does not define a main() function"
            fi
            ;;
          *)
            print_info "Skipping $tool_name"
            ;;
        esac
      )
    fi
  done
}

# Main execution
install_core_tools
install_optional_tools

print_header "Setup Complete!"
echo ""
echo "Next steps:"
echo "  1. Restart your shell or run: exec fish -l"
echo "  2. Install tmux plugins: Press Ctrl+Space I inside tmux"
echo "  3. Configure GitHub CLI: gh auth login"
echo "  4. Configure Copilot: :Copilot auth in nvim"
echo ""
print_success "Dotfiles v2 setup completed successfully!"
