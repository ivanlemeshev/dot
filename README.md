# Dotfiles

[![Lint](https://github.com/ivanlemeshev/dot/actions/workflows/lint.yml/badge.svg)](https://github.com/ivanlemeshev/dot/actions/workflows/lint.yml)
[![Test](https://github.com/ivanlemeshev/dot/actions/workflows/test.yml/badge.svg)](https://github.com/ivanlemeshev/dot/actions/workflows/test.yml)
[![CodeQL](https://github.com/ivanlemeshev/dot/workflows/CodeQL/badge.svg)](https://github.com/ivanlemeshev/dot/security/code-scanning)

```bash
   ____   ___ _____ _____ ___ _     _____ ____
  |  _ \ / _ \_   _|  ___|_ _| |   | ____/ ___|
  | | | | | | || | | |_   | || |   |  _| \___ \
 _| |_| | |_| || | |  _|  | || |___| |___ ___) |
(_)____/ \___/ |_| |_|   |___|_____|_____|____/
```

This repository contains my personal dotfiles and setup scripts. It includes configurations for Neovim, Zsh, and various tools.

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

### Windows

Run the PowerShell bootstrap from an elevated PowerShell session. It requests Administrator approval itself when needed:

```powershell
git clone https://github.com/ivanlemeshev/dot $HOME\dotfiles
Set-Location $HOME\dotfiles
.\bin\setup.ps1
```

If the execution policy blocks the script, invoke it explicitly:

```powershell
pwsh -NoProfile -ExecutionPolicy Bypass -File .\bin\setup.ps1
```

The bootstrap uses winget and an internet connection to manage Git, GitHub CLI, PowerShell 7, mise, ripgrep, fd, psmux, and the MSYS2 dependency used for the Windows Lua/LuaRocks toolchain. It also installs Nerd Fonts, configures the PowerShell profile, maps Caps Lock to Left Ctrl, and links this repository's mise, Windows Terminal, and VS Code settings. Existing linked configuration is kept; existing non-linked configuration is backed up with a timestamp.

Restart Windows if the bootstrap reports that the Caps Lock mapping changed.

## Post-install

```bash
# GitHub CLI auth
gh auth login

# Neovim: Enable Copilot
nvim
:Copilot auth
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
