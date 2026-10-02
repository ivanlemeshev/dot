# Dotfiles

[![Lint](https://github.com/ivanlemeshev/dot/actions/workflows/lint.yml/badge.svg)](https://github.com/ivanlemeshev/dot/actions/workflows/lint.yml)
[![Test](https://github.com/ivanlemeshev/dot/actions/workflows/test.yml/badge.svg)](https://github.com/ivanlemeshev/dot/actions/workflows/test.yml)
[![CodeQL](https://github.com/ivanlemeshev/dot/workflows/CodeQL/badge.svg)](https://github.com/ivanlemeshev/dot/security/code-scanning)

```bash
          _       _    __ _ _
       __| | ___ | |_ / _(_) | ___  ___
      / _` |/ _ \| __| |_| | |/ _ \/ __|
     | (_| | (_) | |_|  _| | |  __/\__ \\
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

## Tools

Managed via [mise](https://mise.jdx.dev):

- Go
- golangci-lint
- Node
- Python
- Lua
- Zig

See `.config/mise/config.toml` for versions.
