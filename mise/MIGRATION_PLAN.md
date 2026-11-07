# Migration and root replacement plan

Status: proposed.
The implementation starts after the user selects the open decisions.
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
Record the selected result in this table before its dependent step starts.

| ID | Decision | Recommendation | Status |
| --- | --- | --- | --- |
| D01 | Which repository metadata remains at root during cleanup? | Keep Git control data, `AGENTS.md`, the license, ignore rules, attributes, and the CI metadata that the final setup needs. | Pending |
| D02 | What replaces `bin/reset-nvim` and `bin/set-git-repo-user`? | Keep their useful functions as explicit mise tasks with portable implementations. | Pending |
| D03 | Where do the Codex and Claude packages live before and after promotion? | Preserve both packages and their required discovery paths. Keep Codex personal skills in `lem-*` folders and Claude personal skills in the `lem` package. | Pending |
| D04 | Do Copilot CLI and Specify CLI remain supported? | Keep them as optional capabilities with explicit install and verify tasks. | Pending |
| D05 | Does VM tooling remain supported? | Keep it as an optional platform extension. Do not install it during the core bootstrap. | Pending |
| D06 | Does OpenSpec apply to every platform? | Add it to Linux so the supported platforms have the same capability. | Pending |
| D07 | How does Ubuntu map Caps Lock to Ctrl? | Support the normal Ubuntu desktop session and define the supported behavior for WSL and containers. | Pending |
| D08 | How do existing machine values enter the new setup? | Use a one-time migration or a guided local configuration step. Preserve existing Git identity when no replacement value exists. | Pending |
| D09 | Does the configurable KDE terminal font remain supported? | Preserve the capability through an approved local override without rendering a managed profile from machine values. | Pending |
| D10 | Who runs the native machine checks? | Record a Windows, macOS, Ubuntu desktop, and Fedora KDE run before deleting the fallback implementation. | Pending |
| D11 | Is the documented two-stage root replacement the final layout? | Remove the legacy setup first, then promote `mise/` contents to root as one final layout change. | Pending |

## Step 1: Record the exact inventory

- [ ] Record the current commit and clean or dirty worktree state.
- [ ] Inventory `bin/`, `install/`, `lib/`, `.config/`, `windows/`, and `macos/`.
- [ ] Inventory root documentation, build files, workflows, ignore rules, and machine setting examples.
- [ ] Inventory both skill packages and their deployment paths.
- [ ] Map each legacy item to a replacement, an approved removal, or a retained repository file.
- [ ] Separate active bootstrap behavior from optional standalone installers.
- [ ] Record the intentional removal of Racket, Emacs, and ASDF integration.
- [ ] Record the decisions for optional tools without treating them as core requirements.

Completion condition: every legacy item has a recorded disposition.

## Step 2: Close the capability gaps inside mise

- [ ] Implement the approved replacements for the two utility scripts.
- [ ] Keep Neovim reset separate from automatic bootstrap actions.
- [ ] Define exactly which Neovim paths a reset removes.
- [ ] Preserve repository-specific Git settings when the Git utility changes one value.
- [ ] Implement Codex and Claude deployment on the approved platforms.
- [ ] Preserve installed system skills and unrelated user skills.
- [ ] Verify both personal skill packages when their contents change.
- [ ] Add the approved Linux OpenSpec installation and verification.
- [ ] Add optional tool tasks for the capabilities selected in D04 and D05.
- [ ] Add Ubuntu Caps Lock support from D07.
- [ ] Keep Fedora, macOS, and Windows keyboard adapters consistent with their native platforms.
- [ ] Resolve the KDE font setting from D09.
- [ ] Add verification for every new installation adapter.

Completion condition: each retained capability has an installation path, configuration path, and verification command.

## Step 3: Preserve machine settings and existing configuration

- [ ] Map `config.env` values to the ignored local configuration format.
- [ ] Cover Git name, email, default branch, time zone, computer name, and the approved desktop settings.
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
- [ ] Run the full bootstrap again in each installed container.
- [ ] Check verification from a directory outside the repository.
- [ ] Check link removal and reapplication.
- [ ] Check restoration of seeded personal files and settings.
- [ ] Check Fish, Vim, Neovim, tmux, fzf, and the terminal palette files.
- [ ] Check PowerShell 5.1 bootstrap compatibility and PowerShell 7 runtime behavior.
- [ ] Check Windows elevation, paths with spaces, and redirected Documents paths.
- [ ] Run the approved full Windows installation on the target machine.
- [ ] Run the full macOS installation on a real Mac.
- [ ] Check Konsole rendering and keyboard behavior in Fedora KDE.
- [ ] Check Ubuntu desktop keyboard behavior.
- [ ] Check the physical Caps Lock behavior on macOS and Windows.
- [ ] Record the source commit, platform version, commands, outcomes, and remaining limitations.

Completion condition: each supported platform has the required container or native evidence.
A fixture result does not replace a native machine result.

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
- [ ] Run the native macOS and Windows smoke checks with the promoted paths.
- [ ] Run the Ubuntu and Fedora desktop smoke checks.
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
