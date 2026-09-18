# Dotfiles v2 work plan

## Phase 1: Foundation

- [ ] Create the V2 directory layout.
- [ ] Add `packages/common.txt` with `git`.
- [ ] Add `apt`, `dnf`, and `pacman` package adapters.
- [ ] Add the Homebrew package adapter and prerequisite check.
- [ ] Add the `winget` package adapter and prerequisite check.
- [ ] Add `bin/bootstrap` and `bin/bootstrap.ps1`.
- [ ] Make both bootstrap commands non-interactive for tests.
- [ ] Add Chezmoi source state for a generic Git configuration without identity data.

Completion check: each bootstrap command can install Chezmoi and Git, then apply
the generic Git configuration.

## Phase 2: Linux container verification

- [ ] Add an Ubuntu 26.04 container test.
- [ ] Add a Fedora container test.
- [ ] Add an Arch container test.
- [ ] Check package installation and Chezmoi apply.
- [ ] Check rendered files and installed commands.
- [ ] Run each test twice to check idempotence.

Completion check: the three container tests pass from `v2/bin/test`.

## Phase 3: Native smoke tests

- [ ] Document the macOS smoke test.
- [ ] Document the Windows smoke test.
- [ ] Run the macOS smoke test for the first bootstrap.
- [ ] Run the Windows smoke test for the first bootstrap.

Completion check: the documentation covers setup, expected results, and cleanup.

## Phase 4: Add tools one slice at a time

- [ ] Select the next terminal tool.
- [ ] Add its common capability when required.
- [ ] Add native package mappings.
- [ ] Add its Chezmoi source state.
- [ ] Extend the relevant automated and manual checks.

Completion check: each tool has one complete package, deployment, and verification path.

## Deferred work

- Desktop and OS-specific UI configuration.
- Migration of the current setup.
- Generic external installer framework.
- Native macOS and Windows CI runners.
