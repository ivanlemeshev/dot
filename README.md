# Dotfiles

[![Lint](https://github.com/ivanlemeshev/dot/actions/workflows/lint.yml/badge.svg)](https://github.com/ivanlemeshev/dot/actions/workflows/lint.yml)
[![CodeQL](https://github.com/ivanlemeshev/dot/workflows/CodeQL/badge.svg)](https://github.com/ivanlemeshev/dot/security/code-scanning)

```text
          _       _    __ _ _
       __| | ___ | |_ / _(_) | ___  ___
      / _` |/ _ \| __| |_| | |/ _ \/ __|
     | (_| | (_) | |_|  _| | |  __/\__ \
    . \__,_|\___/ \__|_| |_|_|\___||___/

    > own your shell. shape your system.
```

Personal dotfiles for Ubuntu 26.04, Fedora KDE, macOS, and Windows x64. Mise manages packages, tools, and configuration links.

<!-- prettier-ignore -->
> [!WARNING]
> Review code before running. Use at your own risk.

## Setup

```sh
git clone https://github.com/ivanlemeshev/dot.git
cd dot
```

Optional: copy [config.local.toml.example](config.local.toml.example) to `config.local.toml` and edit your machine settings before setup. Git ignores this file.

**Ubuntu, Fedora KDE, and macOS:**

```sh
./bootstrap.sh
```

**Windows, from 64-bit PowerShell:**

```powershell
.\bootstrap.ps1
```

Bootstrap upgrades packages, applies configuration, and verifies the setup. Windows requests administrator access. Restart Windows to apply Caps Lock → Ctrl.
