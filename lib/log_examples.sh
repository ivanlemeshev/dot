#!/bin/bash

# Examples of using lib/log.sh functions
# Run this file to see all logging functions in action

set -e

# Source the log library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/log.sh"

echo "========================================="
echo "lib/log.sh - Logging Examples"
echo "========================================="
echo ""

# Example 1: Basic logging levels
echo "========================================"
echo "Example 1: Basic Log Levels"
echo "========================================"
echo ""

log_info "Showing all log levels:"
log_debug "This is a debug message (hidden by default)"
log_info "This is an informational message"
log_success "This is a success message"
log_warn "This is a warning message"
log_error "This is an error message"

echo ""

# Example 2: Debug logging (enable debug level)
echo "========================================"
echo "Example 2: Debug Logging"
echo "========================================"
echo ""

log_info "Debug messages are hidden by default"
log_debug "This debug message is NOT visible (log level = info)"

log_info "Enabling debug level..."
log_set_level debug

log_debug "Now debug messages are visible!"
log_debug "Current user: $(whoami)"
log_debug "Current directory: $(pwd)"
log_debug "Shell: $SHELL"

log_info "Resetting to info level..."
log_set_level info
log_debug "This debug message is hidden again"

echo ""

# Example 3: Log levels filtering
echo "========================================"
echo "Example 3: Log Level Filtering"
echo "========================================"
echo ""

log_info "Current level: INFO (shows info, success, warn, error)"
log_debug "Debug message (hidden)"
log_info "Info message (visible)"
log_success "Success message (visible)"
log_warn "Warning message (visible)"
log_error "Error message (visible)"

echo ""
log_info "Setting level to WARN (only warn and error)"
log_set_level warn
log_debug "Debug message (hidden)"
log_info "Info message (hidden)"
log_success "Success message (hidden)"
log_warn "Warning message (visible)"
log_error "Error message (visible)"

log_info "Resetting to info level..."
log_set_level info

echo ""

# Example 4: Timestamps
echo "========================================"
echo "Example 4: Timestamps"
echo "========================================"
echo ""

log_info "Messages without timestamps (default)"
log_success "Operation completed"

echo ""
log_info "Enabling timestamps..."
log_enable_timestamps

log_info "This message has a timestamp"
log_success "Timestamps show when events occurred"
log_warn "Useful for debugging timing issues"

log_info "Disabling timestamps..."
log_disable_timestamps
log_info "Timestamps disabled"

echo ""

# Example 5: File logging
echo "========================================"
echo "Example 5: File Logging"
echo "========================================"
echo ""

log_set_file "/tmp/dotfiles-test.log"
log_info "This message goes to both console and file"
log_success "File logging is active"
log_warn "Check /tmp/dotfiles-test.log for the log file"

echo ""
log_info "Log file contents:"
cat /tmp/dotfiles-test.log

log_set_file "" # Disable file logging
log_info "File logging disabled"

echo ""

# Example 6: Command logging
echo "========================================"
echo "Example 6: Command Logging"
echo "========================================"
echo ""

log_command "List log library" ls -la lib/log.sh

echo ""

log_command "Test successful command" true
log_command "Test failing command" false || log_warn "Command failed but we continue"

echo ""

# Example 7: Colors on/off
echo "========================================"
echo "Example 7: Colors Toggle"
echo "========================================"
echo ""

log_info "With colors enabled (default):"
log_info "Blue info message"
log_success "Green success message"
log_warn "Yellow warning message"
log_error "Red error message"

echo ""
log_info "Disabling colors..."
log_disable_colors

log_info "Plain info message"
log_success "Plain success message"
log_warn "Plain warning message"
log_error "Plain error message"

echo ""
log_info "Re-enabling colors..."
log_enable_colors

log_info "Colorful info message"
log_success "Colorful success message"

echo ""

# Example 8: Real-world logging scenario
echo "========================================"
echo "Example 8: Real-World Scenario"
echo "========================================"
echo ""

log_set_level debug # Enable debug for this example

log_info "Starting application setup..."
log_debug "Script started at: $(date)"
log_debug "Working directory: $(pwd)"

log_info "Checking system requirements..."
log_debug "Detecting OS: $(uname -s)"
log_debug "Detecting architecture: $(uname -m)"
log_success "System requirements met"

log_info "Loading configuration..."
log_debug "Config file: $HOME/.config/app.conf"
log_warn "Custom config not found, using defaults"

log_info "Initializing components..."
log_debug "Component 1: OK"
log_debug "Component 2: OK"
log_debug "Component 3: OK"
log_success "All components initialized"

log_info "Running startup tasks..."
log_command "Create directory" mkdir -p /tmp/test-app
log_command "Write test file" touch /tmp/test-app/test.txt
log_success "Startup tasks completed"

log_info "Application ready"
log_debug "Total startup time: ~1 second"
log_success "Setup completed successfully!"

# Cleanup
rm -rf /tmp/test-app /tmp/dotfiles-test.log 2>/dev/null || true

log_set_level info # Reset to info level

echo ""
echo "========================================"
echo "All examples completed!"
echo "========================================"
echo ""
echo "Summary of log symbols:"
echo "  [-] Debug   (magenta)"
echo "  [*] Info    (blue)"
echo "  [+] Success (green)"
echo "  [!] Warning (yellow)"
echo "  [x] Error   (red)"
