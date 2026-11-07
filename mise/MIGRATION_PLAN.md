# Migration and root replacement plan

Status: implementation and verification in progress.
The user selects D01 through D13.
The implementation follows these decisions.
This file records the plan.
It does not authorize deletion or machine changes.

## Target layout

The migration has two layout stages.
First, `mise/` contains the complete setup and replaces the legacy implementation.
Then, the contents of `mise/` move to the repository root.
The final repository has no `mise/` wrapper directory.
The final bootstrap commands use `./bootstrap.sh` and `.\bootstrap.ps1`.

The temporary root has one setup implementation under `mise/`.
Git control data stays in place throughout the migration.
The decisions below define the other repository metadata and skill files that remain.
The cleanup uses an explicit file list.
It does not use a blanket root deletion command.

The final setup supports Ubuntu 26.04, mutable Fedora KDE, macOS, and Windows.
Application configuration uses repository symlinks.
Machine values and recovery records stay outside managed configuration.

## Working rules

- Keep all work on `feat/mise-ubuntu-dotfiles`.
- Do not create or switch branches.
- Keep implementation changes inside `mise/` until the approved cleanup stage.
- The user approves `.github/workflows/mise-migration.yml` as the temporary CI exception.
- Do not add, restore, or change repository tests.
- Keep temporary verification scripts outside the repository.
- Read the applicable `AGENTS.md` files before each implementation step.
- Inspect the worktree before changes.
- Preserve unrelated work.
- Commit and push only when the user requests them.
- Get explicit approval for the deletion manifest before legacy removal.
- Do not update live Windows Terminal settings during agent checks.
- A user-run bootstrap applies only the machine changes that its approved scope includes.

## Current audit baseline

The application configurations have mise copies.
The comparison finds 43 identical files and nine adapted files in the compared application directories.
The adaptations cover setup fixes, shell activation, and the requested Racket removal.
Konsole has a static profile and a copied palette.
iTerm2 has a copied dynamic profile.
Racket and Emacs remain excluded by request.

The Fedora Docker bootstrap, verification, repeat run, and native KDE restoration checks pass.
The Ubuntu container checks cover package selection and reversible shared links after the Fedora changes.
Earlier Ubuntu installation checks cover the full bootstrap.
The latest shared Linux changes still need the final full Ubuntu regression run before deletion.
Windows checks cover script syntax, mocked elevation, temporary adapters, task execution, and link previews.
The full Windows installation lacks a recorded successful run.
macOS checks use syntax checks and temporary fixtures.
The full macOS installation lacks a real-machine smoke check.
Container checks do not prove live Konsole rendering or physical keyboard behavior.

The machine inspection still finds legacy links.
Windows mise, Neovim, PSMux, and Git colors point into the old `dot/.config/` tree.
WSL Neovim also points into that tree.
Recheck these links before migration.
They can change after this audit.

## Open decisions

Each decision starts as pending.
A recommendation does not count as approval.
The user selects the remaining decisions one at a time.
Record the selected result in this table before its dependent step starts.

| ID | Decision | Recommendation or selected result | Status |
| --- | --- | --- | --- |
| D01 | Which repository metadata remains at root during cleanup? | Keep the approved repository metadata at root during cleanup. | Selected by user |
| D02 | What replaces `bin/reset-nvim` and `bin/set-git-repo-user`? | Keep both utilities as explicit mise tasks. | Selected by user |
| D03 | Where do the Codex and Claude packages live before and after promotion? | Use `ivanlemeshev/skills` with tagged releases and on-demand installation. Dotfiles keeps installation commands. | Selected by user |
| D04 | Do Copilot CLI and Specify CLI remain supported? | Remove Copilot CLI and Specify CLI support. | Selected by user |
| D05 | Does VM tooling remain supported? | Remove VM tooling support. | Selected by user |
| D06 | Does OpenSpec apply to every platform? | Remove OpenSpec installation and support from all platforms. | Selected by user |
| D07 | How does Ubuntu map Caps Lock to Ctrl? | Map Caps Lock to Ctrl in Ubuntu desktop sessions. WSL and containers use the host keyboard mapping. | Selected by user |
| D08 | How do existing machine values enter the new setup? | Provide an explicit one-time import command from `config.env` to ignored `mise/config.local.toml`. Preserve existing Git identity when no replacement value exists. | Selected by user |
| D09 | Does the configurable KDE terminal font remain supported? | Keep an optional machine-specific Konsole font override. Use JetBrainsMonoNL Nerd Font Mono, size 11, as the default. Keep the shared profile unchanged. | Selected by user |
| D10 | Who runs the platform checks? | Use temporary GitHub Actions jobs for Ubuntu, Fedora, Windows, and macOS. CI supplies the automated migration evidence. Keep the macOS work machine unchanged. Record desktop appearance and physical keyboard behavior as separate limitations. | Selected by user |
| D11 | Is the documented two-stage root replacement the final layout? | Remove the legacy setup, then promote mise contents to root in the final layout change. | Confirmed by user |
| D12 | What replaces the legacy full-system upgrade step? | Upgrade all system packages during bootstrap through each platform package manager. | Selected by user |
| D13 | What happens to the Claude `ub-mode` skill during export? | Keep the upstream name. Install on demand from `unclebob/ub-mode` at a pinned commit. The separate skills repository keeps its installation command. | Selected by user |

## Step 1: Record the exact inventory

See [the tracked-file inventory](MIGRATION_INVENTORY.md).

- [x] Record the current commit and clean or dirty worktree state.
- [x] Inventory `bin/`, `install/`, `lib/`, `.config/`, `windows/`, and `macos/`.
- [x] Inventory root documentation, build files, workflows, ignore rules, and machine setting examples.
- [x] Inventory both skill packages and their deployment paths.
- [ ] Map each legacy item to a replacement, an approved removal, or a retained repository file.
- [x] Separate active bootstrap behavior from optional standalone installers.
- [x] Record the intentional removal of Racket, Emacs, and ASDF integration.
- [x] Record the decisions for optional tools without treating them as core requirements.

Completion condition: every legacy item has a recorded disposition.

## Step 2: Close the capability gaps inside mise

- [x] Implement the approved replacements for the two utility scripts.
- [x] Keep Neovim reset separate from automatic bootstrap actions.
- [x] Define exactly which Neovim paths a reset removes.
- [x] Preserve repository-specific Git settings when the Git utility changes one value.
- [ ] Prepare the selected skills export without deleting the current sources.
- [ ] Create the separate repository only after its name and visibility have approval.
- [ ] Publish and verify the selected release before removing the dotfiles skill sources.
- [ ] Implement explicit on-demand Codex and Claude installation commands.
- [x] Keep skill installation outside the default bootstrap.
- [ ] Add an on-demand `ub-mode` installation command to the separate skills repository under D13.
- [ ] Pin the upstream source to a specific commit.
- [ ] Keep the upstream skill name and source separate from personal `lem` skills.
- [ ] Preserve the current `ub-mode` copy until replacement installation and live link migration pass.
- [ ] Preserve installed system skills and unrelated user skills.
- [ ] Verify both personal skill packages when their contents change.
- [x] Remove OpenSpec installation, verification, and documentation from all mise platform paths under D06.
- [x] Keep Copilot CLI, Specify CLI, and VM tooling outside the retained capabilities under D04 and D05.
- [x] Upgrade all system packages during bootstrap under D12.
- [x] Use the native package manager on each platform.
- [x] Keep operating system version upgrades outside this package upgrade step.
- [x] Map Caps Lock to Ctrl in Ubuntu desktop sessions under D07.
- [x] Leave keyboard mapping to the host in WSL and containers.
- [ ] Keep Fedora, macOS, and Windows keyboard adapters consistent with their native platforms.
- [x] Add the optional local Konsole font override under D09.
- [x] Preserve `KDE_TERMINAL_FONT` through the explicit import command.
- [x] Keep the shared Konsole profile unchanged when a local override applies.
- [ ] Add verification for every new installation adapter.

Completion condition: each retained capability has an installation path, configuration path, and verification command.

## Step 3: Preserve machine settings and existing configuration

- [x] Add an explicit one-time import command from `config.env` to ignored `mise/config.local.toml`.
- [x] Import supported values without executing the source file.
- [x] Preserve existing local values unless the user explicitly selects replacement.
- [x] Cover Git name, email, default branch, time zone, computer name, and the approved desktop settings.
- [ ] Preserve existing values when a replacement is absent.
- [ ] Keep private values out of commits, Docker build contexts, and shared reports.
- [ ] Preserve user profiles, Git includes, terminal profiles, and unrelated keyboard settings.
- [ ] Back up each conflicting file or link before replacement.
- [ ] Record restore information outside managed repository configuration.
- [ ] Check recovery after a partial failure.
- [ ] Make repeated bootstrap and removal commands safe for the supported states.

Completion condition: migration does not silently discard a machine value or user-owned configuration.

## Step 4: Complete verification before live migration

- [ ] Build fresh Ubuntu and Fedora images from the current source.
- [ ] Run the full bootstrap and `mise run verify` in both images.
- [x] Run the full bootstrap again in each installed container.
- [x] Check verification from a directory outside the repository.
- [x] Check link removal and reapplication.
- [x] Check restoration of seeded personal files and settings.
- [ ] Check Fish, Vim, Neovim, tmux, fzf, and the terminal palette files.
- [ ] Check PowerShell 5.1 bootstrap compatibility and PowerShell 7 runtime behavior.
- [ ] Check Windows elevation, paths with spaces, and redirected Documents paths.
- [x] Prepare temporary GitHub Actions jobs for all four supported platforms during the approved automation stage.
- [x] Use the standard runner labels in the CI matrix below.
- [x] Use PowerShell for the Windows job.
- [ ] Run bootstrap, verification, a second bootstrap, and link restoration checks in every job.
- [ ] Check package upgrades during bootstrap in each platform job.
- [ ] Seed temporary user configuration and verify restoration.
- [ ] Run verification from outside the checkout.
- [ ] Record missing desktop services as failures or explicit coverage limits.
- [ ] Keep the production checks active in CI.
- [ ] Save small job logs with the source commit, runner label, architecture, and OS version.
- [ ] Use a branch-restricted push trigger and manual dispatch with read-only repository permissions.
- [ ] Keep the push trigger restricted to `feat/mise-ubuntu-dotfiles`.
- [ ] Set job timeouts within the GitHub-hosted six-hour limit.
- [ ] Keep private machine settings and credentials out of logs and artifacts.
- [ ] Remove the temporary workflow after the final successful run with the promoted root paths.
- [ ] Keep bootstrap, package installation, link changes, and preference changes off the macOS work machine.
- [ ] Record terminal rendering and physical keyboard behavior as unverified by CI on every platform.
- [ ] Record optional desktop checks separately when the user runs them.
- [ ] Record the source commit, platform version, commands, outcomes, and remaining limitations.

Completion condition: each supported platform has the evidence selected in D10.
The temporary CI jobs replace the required installation runs on personal machines under D10.
CI does not verify terminal appearance or physical keyboard behavior.
The user accepts these coverage limits for the automated migration gate.
Live installations still require the link audit in Step 5 before deletion.

### Temporary CI matrix

| Target | Standard runner | Execution |
| --- | --- | --- |
| Ubuntu 26.04 x64 | `ubuntu-26.04` | Native bootstrap and the Ubuntu Docker workflow |
| Fedora 44 x64 | `ubuntu-26.04` | Existing Fedora Dockerfile with a non-root test user |
| Windows x64 | `windows-2025` | PowerShell bootstrap on Windows Server |
| macOS ARM64 | `macos-26` | Bash bootstrap |
| macOS Intel | `macos-26-intel` | Bash bootstrap |

Ubuntu 24.04 stays outside the target matrix because bootstrap requires Ubuntu 26.04.
Windows Server CI does not prove Windows desktop application behavior on a personal machine.
The Fedora container uses the host kernel and does not provide a full KDE session.
The workflow checks runner session services before the desktop adapter runs.
The workflow does not convert an unsupported desktop check into a passing installation check.

Standard GitHub-hosted runners are free for public repositories.
This plan excludes larger runners.
Artifact storage has separate limits.
Recheck runner labels and repository visibility before enabling the workflow.
Manual dispatch requires the workflow on the default branch.
The temporary feature-branch push trigger permits verification before merge.
See [the runner reference](https://docs.github.com/en/actions/reference/runners/github-hosted-runners), [Actions limits](https://docs.github.com/en/actions/reference/limits), and [runner images](https://github.com/actions/runner-images).

## Step 5: Migrate the machines that use legacy links

- [ ] List the machines and checkouts that still use this repository.
- [ ] Inspect managed links and terminal preference paths on each machine.
- [ ] Back up the current mise configuration and application configuration.
- [ ] Apply the approved machine setting migration.
- [ ] Run the new bootstrap on each target machine.
- [ ] Run verification and the platform smoke checks.
- [ ] Confirm that managed application links point into the current `mise/` directory.
- [ ] Confirm that no active link depends on a legacy directory in the proposed deletion manifest.
- [ ] Identify backup symlinks that point into the legacy tree.
- [ ] Preserve their source content or record the source restoration step before any rollback command.
- [ ] Check the existing Windows and WSL links from the audit again.
- [ ] Record the backup locations and the restoration command for each platform.

Completion condition: deletion of the legacy setup does not break any recorded active installation.
A machine that is unavailable blocks deletion of its required source files.

## Step 6: Prepare documentation, CI, and root metadata

- [ ] Prepare the replacement root README under `mise/`.
- [ ] Document the temporary and final bootstrap paths.
- [ ] Replace the old `config.env.example` instructions with the approved local settings flow.
- [ ] Update the CI commands that currently scan `lib/`, `install/`, and `bin/`.
- [ ] Update or remove the old Makefile targets according to their approved disposition.
- [ ] Replace the root sandbox instructions with the Ubuntu and Fedora Docker workflows.
- [ ] Carry the required license, attributes, and ignore rules into the target layout.
- [ ] Exclude local configuration, recovery data, credentials, and caches from every Docker context.
- [ ] Resolve skill and agent discovery paths from D03.
- [ ] Keep this plan available through the final cutover.

Completion condition: documentation and automation have approved replacements before their old inputs disappear.
This stage requires approval to change the necessary files outside `mise/`.

## Step 7: Approve and remove the legacy root setup

- [ ] Produce an exact deletion and retention manifest from Step 1.
- [ ] Confirm the decisions and verification evidence.
- [ ] Review every remaining reference to a candidate deletion path.
- [ ] Confirm that the current worktree has no unrelated changes at risk.
- [ ] Obtain user approval for the manifest and the cleanup outside `mise/`.
- [ ] Remove the approved legacy bootstrap, installer, helper, and configuration files.
- [ ] Remove the obsolete root documentation and sandbox files only when their replacements are ready.
- [ ] Preserve Git control data and the approved metadata and skill packages.
- [ ] Check that `mise/` contains the only setup implementation.
- [ ] Run reference, syntax, package selection, and link checks again.

Completion condition: only the mise implementation and explicitly retained repository files remain.
The cleanup does not delete machine backups or local values.

## Step 8: Promote mise contents to the repository root

Treat this as one final layout change.
Do not publish a state with only half of the paths updated.

- [ ] Confirm the root has no unresolved file name collisions.
- [ ] Define and fixture-check the configuration link and recovery record migration before moving files.
- [ ] Inventory ignored local files inside `mise/` so promotion does not strand or delete private values.
- [ ] Move the current `mise/` contents into the repository root.
- [ ] Replace the root README with the prepared setup documentation.
- [ ] Change Docker `COPY mise/` instructions to the approved root context.
- [ ] Change Docker ignore patterns that start with `mise/`.
- [ ] Move ignored local configuration to its final ignored path without staging its contents.
- [ ] Update CI, Makefile commands, documentation, and any launcher paths that start with `mise/`.
- [ ] Review every source path that assumes a parent above the setup directory.
- [ ] Fix Windows skill lookup, which currently uses the parent of `$MiseRoot`.
- [ ] Review the legacy exclusion in `miserc.toml` before removing or changing it.
- [ ] Confirm that exclusions do not hide the promoted configuration or unrelated checkouts.
- [ ] Recheck task discovery on every platform.
- [ ] Confirm that file-relative paths still resolve from the promoted files.
- [ ] Add a one-time bootstrap migration for this checkout's old configuration link before normal conflict checks.
- [ ] Keep unrelated configuration links under the existing conflict policy.
- [ ] Update `~/.config/mise` from the old wrapper path to the repository root.
- [ ] Repoint only links that match a recorded pre-promotion source.
- [ ] Update the expected source fields in those recovery records.
- [ ] Preserve backup destinations and previous user preference values.
- [ ] Reject an unrelated user edit instead of treating it as an old managed link.
- [ ] Verify Windows skill restore records before changing their expected source paths.
- [ ] Verify Fedora Konsole restore records before changing their expected source paths.
- [ ] Reapply application links after the recovery records and configuration link use the new root.
- [ ] Verify the macOS LaunchAgent command after the configuration link changes.
- [ ] Preserve the approved skill discovery locations during promotion.
- [ ] Remove the empty `mise/` wrapper.

Completion condition: the repository root is the setup directory and every managed link resolves.
The final commands use `./bootstrap.sh` or `.\bootstrap.ps1`.

## Step 9: Verify the final layout

- [ ] Build and run fresh Ubuntu and Fedora containers from the promoted root.
- [ ] Repeat bootstrap, verification, and reversible link checks.
- [ ] Run all temporary platform CI jobs with the promoted paths.
- [ ] Record desktop smoke checks separately when available.
- [ ] Check that no active link still points to `<checkout>/mise/` or the deleted legacy configuration tree.
- [ ] Check that no runtime code depends on `bin/`, `install/`, `lib/`, or the old root `.config/` tree.
- [ ] Check optional tools, utility tasks, skill deployment, and machine setting preservation.
- [ ] Check palette consistency in Windows Terminal, Ghostty, Konsole, iTerm2, and VS Code.
- [ ] Confirm that README and CI commands work from the repository root.
- [ ] Review the final diff and the deletion manifest.
- [ ] Confirm that no repository tests have changes.
- [ ] Commit and push when the user requests them.

Completion condition: all retained capabilities use the final root layout and the recorded checks pass.

## Recovery requirements

Keep the legacy setup until Step 7 has approval.
Keep machine backups until the final layout passes verification.
Record the pre-cleanup source commit so Git can recover the legacy files.
Record the pre-promotion source commit so Git can recover the wrapper layout.
Do not use a hard reset or discard unrelated work as a recovery method.

If promotion fails, restore the wrapper layout and its configuration link before application links.
Then reapply links from that layout.
Restore native preference values through their recorded adapters.
Keep installed packages unless their removal has separate approval.
Keep private configuration outside the versioned cleanup.

## Implementation checkpoint

The first implementation batch adds explicit utility tasks and the local settings importer.
Bootstrap upgrades native packages on all four platforms.
Bootstrap preserves existing Git identity before managed link replacement.
Linux leaves the current time zone unchanged when `TIMEZONE` is absent.
Ubuntu has a GNOME Caps Lock adapter with restoration.
Fedora has a local Konsole font override with restoration.
Linux configuration conflicts receive backups before link replacement.
OpenSpec installation and verification are removed from mise.
Windows bootstrap no longer installs repository skills automatically.

The temporary workflow uses `.github/workflows/mise-migration.yml` with user approval.
It runs only on the current feature branch or through manual dispatch.
The workflow has no recorded remote run until the user commits and pushes it.
The skills export, machine link migration, deletion manifest, and root promotion remain pending.

Local verification passes for the current implementation batch.
Ubuntu and Fedora each pass a full container bootstrap and a repeat run.
Both platforms pass verification from outside the checkout.
Both platforms restore seeded personal Vim and Neovim configuration after removal.
The Ubuntu adapter passes native GNOME apply, repeat, verify, and restoration checks in a temporary D-Bus session.
The Fedora font override passes native KDE apply, repeat, verify, and restoration checks.
The importer preserves existing values and rejects shell expansion.
Imported local settings load through mise.
The reset preserves a symlink source.
The Git utility preserves unrelated repository settings.
PowerShell 5.1 syntax checks and mocked WinGet upgrade return-code checks pass.
ShellCheck, Python syntax, TOML syntax, and workflow validation pass.
Workflow validation explicitly recognizes the documented `ubuntu-26.04` runner label because the current Actionlint label list lacks it.
Windows and macOS full bootstrap verification waits for the temporary remote jobs.
The next checkpoint requires a user commit and push to start these jobs.
