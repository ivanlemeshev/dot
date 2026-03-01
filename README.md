# Dotfiles

[![Lint](https://github.com/ivanlemeshev/dot/actions/workflows/lint.yml/badge.svg)](https://github.com/ivanlemeshev/dot/actions/workflows/lint.yml)
[![Test](https://github.com/ivanlemeshev/dot/actions/workflows/test.yml/badge.svg)](https://github.com/ivanlemeshev/dot/actions/workflows/test.yml)
[![Test Setup](https://github.com/ivanlemeshev/dot/actions/workflows/test-setup.yml/badge.svg)](https://github.com/ivanlemeshev/dot/actions/workflows/test-setup.yml)
[![CodeQL](https://github.com/ivanlemeshev/dot/workflows/CodeQL/badge.svg)](https://github.com/ivanlemeshev/dot/security/code-scanning)

```bash
   ____   ___ _____ _____ ___ _     _____ ____
  |  _ \ / _ \_   _|  ___|_ _| |   | ____/ ___|
  | | | | | | || | | |_   | || |   |  _| \___ \
 _| |_| | |_| || | |  _|  | || |___| |___ ___) |
(_)____/ \___/ |_| |_|   |___|_____|_____|____/
```

This repository contains my personal dotfiles and setup scripts. It includes
configurations for Neovim, Zsh, and various tools.

<!-- prettier-ignore -->
> [!WARNING]
> Review code before running. Use at your own risk.

## Setup

```bash
# Clone repo
git clone https://github.com/ivanlemeshev/dot ~/dotfiles
cd ~/dotfiles

# Optional: Configure personal settings
cp config.env.example config.env
vim config.env

# Run setup
./bin/setup
```

## Post-install

```bash
# GitHub CLI auth
gh auth login

# Neovim: Enable Copilot
nvim
:Copilot auth
```

## Theme Pipeline

Theme colors are defined in `color/schemes/color-scheme.*.yaml` and generated into
tool-specific configs with `bin/apply-color-scheme`.

Current schema:

```yaml
name: "Example"
colors:
  foreground: "#d0d0d0"
  background: "#151515"
  black: "#151515"
  red: "#ac4142"
  green: "#90a959"
  yellow: "#f4bf75"
  blue: "#6a9fb5"
  magenta: "#aa759f"
  cyan: "#75b5aa"
  white: "#d0d0d0"
  brightBlack: "#505050"
  brightRed: "#ac4142"
  brightGreen: "#90a959"
  brightYellow: "#f4bf75"
  brightBlue: "#6a9fb5"
  brightMagenta: "#aa759f"
  brightCyan: "#75b5aa"
  brightWhite: "#f5f5f5"
```

Useful commands:

```bash
# Regenerate checked-in theme outputs
bash bin/apply-color-scheme color/schemes/color-scheme.kanagawa-dragon-contrast.yaml

# Verify theme schema and generated outputs
make theme-test
```

## Tools

Managed via [mise](https://mise.jdx.dev):

- Go
- golangci-lint
- Node
- Python
- Lua
- Zig

See `.config/mise/config.toml` for versions.
