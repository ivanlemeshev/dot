#!/bin/bash

# Examples of using lib/print.sh functions
# Run this file to see all printing/formatting functions in action

set -e

# Source the print library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=print.sh
source "${SCRIPT_DIR}/print.sh"

echo "========================================="
echo "lib/print.sh - Formatting Examples"
echo "========================================="
echo ""

# Example 1: Section headers
print_section "Example 1: Section Headers"

echo "Default width (40 characters):"
print_section "Installation"

echo "Custom width (60 characters):"
print_section "Configuration" 60

echo ""

# Example 2: Separators
print_section "Example 2: Separators"

echo "Default separator (40 dashes):"
print_separator

echo ""
echo "Custom width (60 characters):"
print_separator 60

echo ""
echo "Custom character (equals):"
print_separator 40 "="

echo ""
echo "Custom character (asterisk):"
print_separator 40 "*"

echo ""

# Example 3: Step indicators
print_section "Example 3: Step Indicators"

print_step 1 5 "Checking prerequisites"
sleep 0.3
print_step 2 5 "Installing dependencies"
sleep 0.3
print_step 3 5 "Configuring environment"
sleep 0.3
print_step 4 5 "Creating symlinks"
sleep 0.3
print_step 5 5 "Finalizing setup"

echo ""

# Example 4: List items
print_section "Example 4: List Items"

echo "Default bullet (•):"
print_list "First item in the list"
print_list "Second item in the list"
print_list "Third item in the list"

echo ""
echo "Custom bullet (-):"
print_list "Configuration option 1" "-"
print_list "Configuration option 2" "-"
print_list "Configuration option 3" "-"

echo ""
echo "Custom bullet (*):"
print_list "Package: git" "*"
print_list "Package: tmux" "*"
print_list "Package: fish" "*"

echo ""

# Example 5: Key-value pairs
print_section "Example 5: Key-Value Pairs"

echo "System information:"
print_key_value "OS" "$(uname -s)"
print_key_value "Kernel" "$(uname -r)"
print_key_value "User" "$(whoami)"
print_key_value "Home" "$HOME"
print_key_value "Shell" "$SHELL"

echo ""
echo "Application settings:"
print_key_value "Name" "Dotfiles Setup"
print_key_value "Version" "1.0.0"
print_key_value "Author" "Your Name"
print_key_value "Status" "Active"

echo ""
echo "With custom key width (20 characters):"
print_key_value "Configuration Dir" "$HOME/.config" 20
print_key_value "Dotfiles Dir" "$PWD" 20

echo ""

# Example 6: Progress bars
print_section "Example 6: Progress Bars"

echo "Simulating download:"
for i in {0..100..5}; do
  print_progress "$i" 100 "Downloading packages"
  sleep 0.05
done

echo ""
echo "Simulating installation:"
for i in {0..100..10}; do
  print_progress "$i" 100 "Installing"
  sleep 0.1
done

echo ""
echo "Custom width progress bar (40 characters):"
for i in {0..100..20}; do
  print_progress "$i" 100 "Processing" 40
  sleep 0.1
done

echo ""

# Example 7: Combining formatting functions
print_section "Example 7: Real-World Scenario"

print_section "System Setup" 50
print_separator 50

print_step 1 4 "System Information"
print_list "OS: $(uname -s)"
print_list "User: $(whoami)"
print_list "Shell: $SHELL"

echo ""

print_step 2 4 "Configuration"
print_key_value "Config Directory" "$HOME/.config"
print_key_value "Dotfiles Directory" "$PWD"

echo ""

print_step 3 4 "Installing Packages"
echo "Simulating package installation:"
for i in {0..100..25}; do
  print_progress "$i" 100 "git, tmux, fish, nvim"
  sleep 0.2
done

echo ""

print_step 4 4 "Summary"
print_separator 50
echo "Installation complete!"

echo ""

# Example 8: Colors on/off
print_section "Example 8: Colors Toggle"

echo "With colors enabled (default):"
print_step 1 2 "First step"
print_list "Colorful item"
print_key_value "Status" "Enabled"

echo ""
echo "Disabling colors..."
print_disable_colors

print_step 1 2 "First step"
print_list "Plain item"
print_key_value "Status" "Disabled"

echo ""
echo "Re-enabling colors..."
print_enable_colors

print_step 2 2 "Second step"
print_list "Colorful again"
print_key_value "Status" "Enabled"

echo ""
print_separator 60
echo ""

echo "========================================="
echo "All examples completed!"
echo "========================================="
