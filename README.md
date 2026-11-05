# Dotfiles

[![Lint](https://github.com/ivanlemeshev/dot/actions/workflows/lint.yml/badge.svg)](https://github.com/ivanlemeshev/dot/actions/workflows/lint.yml)
[![Test](https://github.com/ivanlemeshev/dot/actions/workflows/test.yml/badge.svg)](https://github.com/ivanlemeshev/dot/actions/workflows/test.yml)
[![CodeQL](https://github.com/ivanlemeshev/dot/workflows/CodeQL/badge.svg)](https://github.com/ivanlemeshev/dot/security/code-scanning)

```text
          _       _    __ _ _
       __| | ___ | |_ / _(_) | ___  ___
      / _` |/ _ \| __| |_| | |/ _ \/ __|
     | (_| | (_) | |_|  _| | |  __/\__ \
    . \__,_|\___/ \__|_| |_|_|\___||___/

    > own your shell. shape your system.
```

This repository contains my personal dotfiles and bootstrap scripts. It includes configurations for Neovim, Zsh, and various tools.

<!-- prettier-ignore -->
> [!WARNING]
> Review code before running. Use at your own risk.

## Bootstrap

```bash
# Clone repo
git clone https://github.com/ivanlemeshev/dot ~/dotfiles
cd ~/dotfiles

# Optional: Configure personal settings
cp config.env.example config.env
vim config.env

# Run bootstrap
./bin/bootstrap
```

### Windows

1. Open PowerShell in the repository folder.
2. Optional: configure Git settings in `config.env`.

```powershell
Copy-Item config.env.example config.env
notepad config.env
```

3. Run the bootstrap. If PowerShell blocks it, use the second command.

```powershell
.\bin\bootstrap.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\bin\bootstrap.ps1
```

## Test installation

Run `make test` for the library and terminal palette checks.
Run `make editor-test` for the Vim and Neovim checks.
The editor checks require Git, Vim, Neovim 0.12 or later, and network access.
The runner downloads two pinned plugins into a temporary directory.
CI runs both test suites on Ubuntu and macOS.

```bash
make container-install-test
```

The test uses Docker when it is available. The test uses Podman otherwise. The test checks Ubuntu 26.04 and Fedora with KDE Plasma.
The test caches mise downloads and installed tools in per-platform volumes. Set `CONTAINER_INSTALL_CACHE=0` for a clean run.

Use an interactive shell after the checks finish:

```bash
make container-install-shell PLATFORM=ubuntu
make container-install-shell PLATFORM=fedora-kde
```

## Post-install

```bash
# GitHub CLI auth
gh auth login

# Neovim: Enable Copilot
nvim
:Copilot auth
```

## Terminal colors

Windows Terminal, Ghostty, Konsole, iTerm2, and the VS Code terminal use the same Tomorrow Night ANSI 16 palette.
Each terminal uses its native configuration format.
Terminal applications use ANSI color indices instead of fixed RGB colors.
Selection backgrounds use ANSI blue (4) with ANSI black (0) text.
Vim and Neovim show the current line number in bold yellow with no line background.
Native terminal selection settings use the same blue (`#81a2be`) where supported.
Use dark terminal themes with the current application mappings.
Run `make test` to check palette consistency.

## Tools

Managed via [mise](https://mise.jdx.dev):

- Go
- golangci-lint
- Node
- Python
- Lua
- Zig

See `.config/mise/config.toml` for versions.
