#!/bin/bash

# Examples of using lib/prompt.sh functions
# Run this file to see interactive examples of all prompt functions

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

source "${SCRIPT_DIR}/lib/prompt.sh"

echo "========================================="
echo "lib/prompt.sh - Interactive Examples"
echo "========================================="
echo ""

# Example 1: prompt_yes_no
echo "Example 1: Yes/No prompts"
echo "--------------------------"

if prompt_yes_no "Do you like bash scripting?"; then
  echo "✓ Great! You answered yes."
else
  echo "✗ You answered no."
fi

if prompt_yes_no "Install optional packages?" --default y; then
  echo "✓ Will install optional packages (default was yes)"
fi

echo ""

# Example 2: prompt_input
echo "Example 2: Text input"
echo "---------------------"

name=$(prompt_input "What's your name?")
echo "Hello, ${name}!"

username=$(prompt_input "Enter username" --default "$(whoami)")
echo "Username: ${username}"

email=$(prompt_input "Enter email" --required --validate "grep -q '@'")
echo "Email: ${email}"

echo ""

# Example 3: prompt_choice
echo "Example 3: Single choice selection"
echo "-----------------------------------"

os=$(prompt_choice "Choose your OS" "macOS" "Ubuntu" "Windows" "Other")
echo "You selected: ${os}"

editor=$(prompt_choice "Choose editor" --default 2 "vim" "nvim" "emacs" "nano")
echo "You selected: ${editor}"

echo ""

# Example 4: prompt_multiselect
echo "Example 4: Multiple choice selection"
echo "-------------------------------------"

features=$(prompt_multiselect "Select features to install" "Docker" "Kubernetes" "Terraform" "Ansible")
echo "You selected: ${features}"

echo ""

# Example 5: prompt_password
echo "Example 5: Password input"
echo "-------------------------"

password=$(prompt_password "Enter a test password" --confirm --required)
# Use the password variable to avoid shellcheck warning
echo "Password set (hidden for security)" "${password:+}"

echo ""

# Example 6: prompt_path
echo "Example 6: Path input"
echo "---------------------"

config_dir=$(prompt_path "Enter config directory" --type dir --default "$HOME/.config")
echo "Config directory: ${config_dir}"

echo ""

# Example 7: prompt_confirm
echo "Example 7: Confirmation pause"
echo "------------------------------"
echo "This is some important output..."
echo "Please read it carefully."
prompt_confirm "Press Enter when ready to continue..."

echo ""
echo "========================================="
echo "All examples completed!"
echo "========================================="
