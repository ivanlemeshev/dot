# Dotfiles

[![Format](https://github.com/ivanlemeshev/dot/actions/workflows/format.yml/badge.svg)](https://github.com/ivanlemeshev/dot/actions/workflows/format.yml) [![Lint](https://github.com/ivanlemeshev/dot/actions/workflows/lint.yml/badge.svg)](https://github.com/ivanlemeshev/dot/actions/workflows/lint.yml)

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
> The bootstrap script changes system settings. Review the code before you run it.

## Setup

```sh
git clone https://github.com/ivanlemeshev/dot.git
cd dot
```

To set machine options, copy [config.local.toml.example](config.local.toml.example) to `config.local.toml`. Edit the file before setup. Git ignores this file.

**Ubuntu, Fedora KDE, and macOS:**

```sh
./bootstrap.sh
```

**Windows, from 64-bit PowerShell:**

```powershell
.\bootstrap.ps1
```

For theme changes after setup, see [Color themes](docs/themes.md).

## Development

[mise](https://mise.jdx.dev) pins the repository tools in `mise.toml`. The bootstrap configuration stays in `config.toml` and the platform files.

Run these commands from the repository root. On Windows, install Git to supply Bash.

```sh
mise trust
mise install
mise run format
mise run format:check
mise run lint
mise run check
```

`format` formats Bash, Lua, Markdown, YAML, JSON, and TOML files. `format:check` checks the same files without changes. `lint` runs ShellCheck, markdownlint, and Tombi. `check` runs both checks.

The tasks check tracked files and new files that Git does not ignore. They skip ignored machine files. Each Markdown paragraph stays on one source line. Lua uses the Neovim style in `nvim/.stylua.toml`.

GitHub Actions runs `format:check` and `lint` in separate workflows on each push to `main` and each pull request. The workflows use the same tasks and tool versions as local checks.
