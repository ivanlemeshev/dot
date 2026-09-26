# Dotfiles v2 requirements

## Scope

V2 provides a small and extensible terminal setup.
It builds from scratch.
It does not migrate the current setup.

## Supported platforms

- macOS
- Ubuntu 26.04
- Fedora KDE Plasma
- Arch
- Windows

V2 does not configure OS-specific UI in the first version.

## Design rules

Chezmoi is the user-file module.
It renders managed files into the user home directory.
Managed files are not symlinks by default.
Use a symlink only when a tool requires it.

Native package adapters are the package module.
They use `apt`, `dnf`, `pacman`, Homebrew, and `winget`.
V2 prefers native packages.
An explicit per-tool adapter can install a tool when no suitable native package exists.
Each custom adapter must be idempotent.

The common package manifest is plain text.
It lists one capability per line.
Platform adapters map a capability to a native package when required.

Personal data stays outside Git in local Chezmoi data.
Bootstrap does not prompt for personal values.
Do not commit secrets.

## Repository layout

Keep V2 isolated in `v2/` until it is proven.

```text
v2/
├── home/                    # Chezmoi source state
├── packages/
│   ├── common.txt           # One capability per line
│   ├── apt.sh
│   ├── dnf.sh
│   ├── pacman.sh
│   ├── brew.sh
│   ├── winget.ps1
│   └── custom/              # Explicit tool adapters
├── bin/
│   ├── bootstrap            # macOS and Linux
│   ├── bootstrap.ps1        # Windows
│   └── test                 # Linux container tests
├── test/
│   ├── ubuntu/
│   ├── fedora/
│   └── arch/
└── docs/
    └── manual-smoke-tests.md
```

## Bootstrap interface

`bin/bootstrap` bootstraps macOS and Linux.
`bin/bootstrap.ps1` bootstraps Windows.
`bin/test` runs the Linux container suite.
`bin/test --interactive` runs the checks and opens a shell in each selected container.

Bootstrap installs Chezmoi when it is absent.
It installs required host package prerequisites.
It installs declared packages.
It applies the Chezmoi source state.

On macOS, bootstrap installs or repairs Homebrew when required.
On Windows, bootstrap reports how to install `winget` when absent.

## Verification

Docker or Podman tests Ubuntu, Fedora, and Arch.
Each test uses a fresh non-root home directory.
Each test installs the selected native packages.
Each test applies Chezmoi state.
Each test checks expected files and commands.
Each test runs a second time to check idempotence.

Docker does not test macOS or Windows package behavior.
V2 provides manual smoke tests for macOS and Windows.
Run each smoke test after its adapter changes.
Native CI runners can replace manual checks later.
