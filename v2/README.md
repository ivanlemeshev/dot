# Unified Dotfiles v2 (Ubuntu 24.04)

Simple, extensible dotfiles system for **Ubuntu 24.04**.

macOS and Windows support coming in future phases.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/ivanlemeshev/dot.git ~/dot
cd ~/dot/v2

# Run setup (Ubuntu 24.04 only)
./setup
```

## Testing with Docker

```bash
cd ~/dot/v2
./docker-test.sh
```

## Features

- ✅ Single command setup for Ubuntu 24.04
- ✅ Modular design - easy to add/remove tools
- ✅ Cross-platform configs ready (Fish, Neovim, Tmux, Starship)
- ✅ Docker-based testing
- ✅ GitHub Actions CI/CD
- ✅ Automatic dependency management

## Core Tools (Always Installed)

- **Fish** - Friendly interactive shell
- **Neovim** - Modern Vim-based editor
- **Tmux** - Terminal multiplexer
- **Starship** - Cross-shell prompt
- **Git** - Version control
- **Bat** - Cat with syntax highlighting
- **Vim** - Classic text editor

## Optional Tools (Interactive Selection)

- **Go** - Go programming language
- **Rust** - Rust programming language
- **Python** - Python with UV package manager
- **Node.js** - JavaScript runtime
- **Zig** - Zig programming language
- **Lazygit** - Git TUI
- **Bottom** - System monitor

## Adding New Tools

Create a new tool module in 3 easy steps:

```bash
# 1. Create tool directory
mkdir -p tools/optional/newtool

# 2. Create tool.sh
cat > tools/optional/newtool/tool.sh << 'EOF'
#!/usr/bin/env bash

TOOL_NAME="newtool"
TOOL_DESCRIPTION="Description of the tool"
TOOL_CATEGORY="optional"

declare -A PACKAGES=(
  [ubuntu]="newtool"
)

function install_package() {
  pkg_install "${PACKAGES[$OS_TYPE]}"
}

function main() {
  install_package
}
EOF

# 3. Make it executable
chmod +x tools/optional/newtool/tool.sh
```

That's it! The tool will be automatically discovered and offered during setup.

## Manual Setup Steps (Post-Installation)

### Tmux Plugins

Inside tmux, press:

```
Ctrl+Space I
```

### Neovim Plugins

Open nvim and wait for Lazy.nvim to install plugins automatically.

### GitHub Copilot

```vim
:Copilot auth
```

### GitHub CLI

```bash
gh auth login
```

## Project Structure

```
v2/
├── setup                    # Main entry point
├── Dockerfile               # Docker test image (Ubuntu 24.04)
├── docker-test.sh           # Docker test helper
├── lib/                     # Core library code
│   ├── os.sh                # OS detection
│   ├── package.sh           # Package manager abstraction
│   ├── symlink.sh           # Symlink helpers
│   ├── ui.sh                # UI functions
│   └── setup-ubuntu.sh      # Ubuntu orchestrator
├── tools/                   # Tool modules
│   ├── core/                # Core tools (always installed)
│   ├── optional/            # Optional tools (user selects)
│   └── platform/            # Platform-specific tools
└── .github/workflows/       # CI/CD workflows
```

## Documentation

- [README.md](README.md) - This file
- [ARCHITECTURE.md](ARCHITECTURE.md) - System architecture and design
- [IMPLEMENTATION.md](IMPLEMENTATION.md) - Implementation progress
- [MIGRATION.md](MIGRATION.md) - Migration guide from v1

## Requirements

- **Ubuntu 24.04 LTS**
- Internet connection
- sudo access

## Support

Currently supports **Ubuntu 24.04** only. macOS and Windows support planned for
future releases.

## License

Same as parent repository.
