# Architecture

## Overview

The v2 dotfiles system is designed with modularity, simplicity, and
extensibility in mind. Currently targets **Ubuntu 24.04** exclusively.

## Design Principles

1. **Single Entry Point**: One `./setup` command does everything
2. **Tool-Based Modules**: Each tool is self-contained in its own directory
3. **Light Abstraction**: Minimal abstraction layer for package management
4. **Fresh Start**: Built from scratch in v2/, doesn't modify existing repo
5. **Docker First**: All testing done in Docker for reproducibility

## Directory Structure

```
v2/
├── setup                    # Entry point - detects OS and delegates
├── Dockerfile               # Ubuntu 24.04 test image
├── docker-test.sh           # Quick test in Docker
│
├── lib/                     # Core library functions
│   ├── os.sh                # OS detection (Ubuntu 24.04 check)
│   ├── package.sh           # apt-get wrapper
│   ├── symlink.sh           # Symlink creation with backup
│   ├── ui.sh                # UI functions (print_header, etc.)
│   └── setup-ubuntu.sh      # Main orchestrator
│
└── tools/                   # Tool modules
    ├── core/                # Always installed
    │   ├── fish/
    │   │   ├── tool.sh      # Installation logic
    │   │   └── config.fish  # Configuration file
    │   ├── neovim/
    │   │   ├── tool.sh
    │   │   └── nvim/        # Entire nvim config
    │   └── ...
    │
    ├── optional/            # User selects interactively
    │   ├── go/
    │   ├── rust/
    │   └── ...
    │
    └── platform/            # Future: macOS, Windows
        └── ubuntu/          # Ubuntu-specific if needed
```

## Component Responsibilities

### Entry Point (`setup`)

- Detects OS (must be Ubuntu 24.04)
- Sources library functions
- Delegates to `lib/setup-ubuntu.sh`

### Library Functions (`lib/`)

**os.sh**:

- `detect_os()` - Sets `$OS_TYPE` environment variable
- Currently only checks for Ubuntu 24.04

**package.sh**:

- `pkg_install <package>` - Install via apt-get
- `pkg_update()` - Run apt-get update
- `pkg_installed <package>` - Check if installed

**symlink.sh**:

- `symlink_file <source> <target>` - Create symlink with backup
- Backs up existing files with timestamp
- Removes old symlinks before creating new

**ui.sh**:

- `print_header <text>` - Fancy box header
- `print_info <text>` - Info message
- `error <text>` - Error message

**setup-ubuntu.sh**:

- Main orchestrator
- Discovers and runs tool modules
- Handles core -> optional tool flow

### Tool Modules (`tools/`)

Each tool module follows a standard structure:

```bash
#!/usr/bin/env bash

# Metadata
TOOL_NAME="toolname"
TOOL_DESCRIPTION="Tool description"
TOOL_CATEGORY="core|optional"

# Package mapping
declare -A PACKAGES=(
  [ubuntu]="package-name"
)

# Hooks (all optional)
function pre_install() {
  # Run before installation
}

function install_package() {
  pkg_install "${PACKAGES[$OS_TYPE]}"
}

function post_install() {
  # Run after installation
  # Install plugins, configure, etc.
}

function link_configs() {
  # Symlink configuration files
  local tool_dir="$(dirname "${BASH_SOURCE[0]}")"
  symlink_file "${tool_dir}/config" "${HOME}/.config/tool/config"
}

# Main entry point
function main() {
  pre_install
  install_package
  post_install
  link_configs
}
```

## Execution Flow

1. User runs `./setup`
2. `setup` sources `lib/os.sh` and detects OS
3. `setup` validates OS is Ubuntu 24.04
4. `setup` executes `lib/setup-ubuntu.sh`
5. `setup-ubuntu.sh` runs `pkg_update()`
6. `setup-ubuntu.sh` discovers core tools in `tools/core/`
7. For each core tool:
   - Source `tool.sh`
   - Execute `main()` function
8. `setup-ubuntu.sh` discovers optional tools in `tools/optional/`
9. For each optional tool:
   - Prompt user (install? y/n)
   - If yes, source and execute `main()`
10. Complete

## Tool Discovery

Tools are discovered automatically by scanning directories:

```bash
for tool_dir in tools/core/*; do
  if [[ -f "$tool_dir/tool.sh" ]]; then
    source "$tool_dir/tool.sh"
    main
  fi
done
```

No central registry needed - just drop a tool directory in and it works.

## Package Management Abstraction

Currently simple wrapper around apt-get:

```bash
function pkg_install() {
  sudo apt-get install -y "$1"
}
```

Future: Can expand to support brew, pacman, etc.

## Configuration Management

- Each tool's configs live in its own directory
- Symlinks created from tool dir -> home dir
- Backups created automatically
- Original repo configs copied to v2 during setup

## Testing Strategy

### Docker Testing

```bash
./docker-test.sh
```

- Builds Docker image (Ubuntu 24.04)
- Copies v2/ into container
- Runs `./setup`
- Verifies installations

### GitHub Actions

- **test-ubuntu.yml**: Runs `docker-test.sh` in CI
- **shellcheck.yml**: Lints all bash scripts
- **validate-configs.yml**: Validates config file syntax

## Future Expansion

### macOS Support

- Add `lib/setup-macos.sh`
- Update `lib/package.sh` to support brew
- Add `tools/platform/macos/` for platform-specific tools
- Update `setup` to route to macOS setup

### Windows Support

- Add `lib/setup-windows.ps1`
- Add PowerShell equivalents of library functions
- Add `tools/platform/windows/` for platform-specific tools
- Update `setup` to launch PowerShell script

## Key Design Decisions

### Why Ubuntu 24.04 Only (For Now)?

- Prove the concept on one platform first
- Ubuntu is the primary development environment
- Easier to test and iterate
- Faster to get to working state

### Why Fresh Start in v2/?

- No risk of breaking existing setup
- Freedom to redesign without constraints
- Easy to reference old implementation
- Users can test v2 while v1 still works

### Why Tool Modules?

- Easy to add new tools (just create directory)
- Self-contained (config + install logic together)
- Easy to remove tools (just delete directory)
- No central registry to maintain

### Why Docker First?

- Fast iteration (build in seconds)
- Reproducible (same environment every time)
- No risk to host system
- Easy to test from clean state

## Anti-Patterns to Avoid

❌ Don't put configs at root level (keep in tool dirs) ❌ Don't hardcode paths
(use variables) ❌ Don't assume tools are installed (check first) ❌ Don't skip
backups (always backup existing files) ❌ Don't ignore errors (use `set -e`)

## Contribution Guidelines

When adding a new tool:

1. Create `tools/{core|optional}/toolname/` directory
2. Create `tool.sh` with standard structure
3. Add config files to tool directory
4. Test in Docker: `./docker-test.sh`
5. Run shellcheck: `shellcheck tools/*/toolname/tool.sh`
6. Document in README if non-standard setup needed
