# Migration and root replacement plan

## Root cutover checkpoint

The user authorizes legacy deletion and root promotion on 2026-11-08. Machine migration runs through the next bootstrap. This replaces the earlier live-link gate. A pull can leave old links broken until bootstrap completes. The macOS work machine stays unchanged until the user updates it. Platform CI must run again after commit and push.

## Original migration sequence

Status: implementation and verification in progress.
The user selects D01 through D14.
The implementation follows these decisions.
This file records the plan.
The later root cutover decision above authorizes repository cleanup. Live machine changes wait for the user to run bootstrap.

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
- Do not create or switch branches in dotfiles.
- The user permits skills export on `main` in `/home/lem/code/github.com/ivanlemeshev/skills`.
- Keep implementation changes inside `mise/` until the approved cleanup stage.
- The user approves moving `codex/` to the separate `openai-plugins` repository.
- The user permits removal and recreation of local agent directories during live migration.
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
The current source passes the temporary CI workflow on all four platforms.
The verified commit is `58914c805ed753751e6931fc99d1b0e9aaf84903`.
See [the successful migration run](https://github.com/ivanlemeshev/dot/actions/runs/42389144902).
The jobs cover full bootstrap, repeat bootstrap, verification, restoration, and reapplication.
Windows uses PowerShell 5.1 for bootstrap and PowerShell 7 for tasks.
macOS uses the Apple Silicon runner.
The macOS work machine stays unchanged.
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
| D03 | Where does the shared skill package live? | Keep only portable `lem-review` in `ivanlemeshev/skills`. Codex and Claude install the same standard package on demand. Dotfiles keeps installation commands. | Selected by user |
| D04 | Do Copilot CLI and Specify CLI remain supported? | Remove Copilot CLI and Specify CLI support. | Selected by user |
| D05 | Does VM tooling remain supported? | Remove VM tooling support. | Selected by user |
| D06 | Does OpenSpec apply to every platform? | Remove OpenSpec installation and support from all platforms. | Selected by user |
| D07 | How does Ubuntu map Caps Lock to Ctrl? | Map Caps Lock to Ctrl in Ubuntu desktop sessions. WSL and containers use the host keyboard mapping. | Selected by user |
| D08 | How do existing machine values enter the new setup? | Provide an explicit one-time import command from `config.env` to ignored `mise/config.local.toml`. Preserve existing Git identity when no replacement value exists. | Selected by user |
| D09 | Does the configurable KDE terminal font remain supported? | Keep an optional machine-specific Konsole font override. Use JetBrainsMonoNL Nerd Font Mono, size 11, as the default. Keep the shared profile unchanged. | Selected by user |
| D10 | Who runs the platform checks? | Use temporary GitHub Actions jobs for Ubuntu, Fedora, Windows, and macOS. CI supplies the automated migration evidence. Keep the macOS work machine unchanged. Record desktop appearance and physical keyboard behavior as separate limitations. | Selected by user |
| D11 | Is the documented two-stage root replacement the final layout? | Remove the legacy setup, then promote mise contents to root in the final layout change. | Confirmed by user |
| D12 | What replaces the legacy full-system upgrade step? | Upgrade native packages during bootstrap. Limit Windows WinGet upgrades to packages declared in the mise setup. Keep full package upgrades on the other platforms. | Selected by user |
| D13 | What happens to the Claude `ub-mode` skill during export? | Keep the upstream name and pinned source. Keep third-party skill installation outside the personal skills repository. | Selected by user |
| D14 | Where do the OpenAI language plugins live? | Move all nine plugin packages and their marketplace to `ivanlemeshev/openai-plugins`. Preserve their existing identities. | Selected by user |

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
- [x] Prepare the selected skills export without deleting the current sources.
- [x] Create the separate repository only after its name and visibility have approval.
- [x] Publish and verify the selected release before removing the dotfiles skill sources.
- [x] Implement explicit on-demand Codex and Claude installation commands.
- [x] Keep skill installation outside the default bootstrap.
- [x] Keep `ub-mode` and its installation instructions outside the personal skills repository under the revised D13 scope.
- [x] Pin the upstream source to a specific commit.
- [x] Keep the upstream skill name and source separate from personal `lem-` skills.
- [x] Preserve the current `ub-mode` copy until replacement installation and live link migration pass.
- [x] Preserve installed system skills and unrelated user skills.
- [x] Verify installation of the shared skill package for Codex and Claude.
- [x] Move the nine OpenAI plugin packages and marketplace to the separate repository under D14.
- [ ] Commit and push the plugin repository, then verify remote installation before merging the source removal.
- [x] Remove OpenSpec installation, verification, and documentation from all mise platform paths under D06.
- [x] Keep Copilot CLI, Specify CLI, and VM tooling outside the retained capabilities under D04 and D05.
- [x] Upgrade native packages during bootstrap under D12.
- [x] Limit Windows WinGet upgrades to packages declared in mise under the revised D12 scope.
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

- [x] Build fresh Ubuntu and Fedora images from the current source.
- [x] Run the full bootstrap and `mise run verify` in both images.
- [x] Run the full bootstrap again in each installed container.
- [x] Check verification from a directory outside the repository.
- [x] Check link removal and reapplication.
- [x] Check restoration of seeded personal files and settings.
- [ ] Check Fish, Vim, Neovim, tmux, fzf, and the terminal palette files.
- [x] Check PowerShell 5.1 bootstrap compatibility and PowerShell 7 runtime behavior.
- [ ] Check Windows elevation, paths with spaces, and redirected Documents paths.
- [x] Prepare temporary GitHub Actions jobs for all four supported platforms during the approved automation stage.
- [x] Use the standard runner labels in the CI matrix below.
- [x] Use PowerShell for the Windows job.
- [x] Run bootstrap, verification, a second bootstrap, and link restoration checks in every job.
- [x] Check package upgrades during bootstrap in each platform job.
- [x] Seed temporary user configuration and verify restoration.
- [x] Run verification from outside the checkout.
- [ ] Record missing desktop services as failures or explicit coverage limits.
- [ ] Keep the production checks active in CI.
- [ ] Save small job logs with the source commit, runner label, architecture, and OS version.
- [ ] Use a branch-restricted push trigger and manual dispatch with read-only repository permissions.
- [x] Keep the push trigger restricted to `feat/mise-ubuntu-dotfiles`.
- [x] Set job timeouts within the GitHub-hosted six-hour limit.
- [ ] Keep private machine settings and credentials out of logs and artifacts.
- [ ] Remove the temporary workflow after the final successful run with the promoted root paths.
- [x] Keep bootstrap, package installation, link changes, and preference changes off the macOS work machine.
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

The 2026-11-08 read-only Windows and WSL audit is recorded in [the live link audit](LIVE_LINK_AUDIT.md). Active legacy dependencies remain. The user permits removal and recreation of agent directories. No live machine migration runs in that audit.

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

The exact tracked deletion proposal is recorded in [the cleanup manifest](CLEANUP_MANIFEST.md). It requires approval before deletion. It does not authorize changes to live machine configuration.

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
The workflow passes at commit `58914c805ed753751e6931fc99d1b0e9aaf84903`.
The shared `lem-review` skill has local and remote installation evidence.
The skills repository provides release `v1.0.0`.
Machine link migration, the deletion manifest, and root promotion remain pending.

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
Windows and macOS full bootstrap verification passes in the temporary remote jobs.
CI does not verify terminal rendering or physical keyboard behavior.

The user limits Windows WinGet upgrades to packages declared by mise.
Bootstrap uses the built-in mise package upgrade command.
The custom bulk WinGet upgrade and self-update recovery code are removed.
The Windows CI job verifies this revised upgrade path.

## Skills export checkpoint

The user creates the public `ivanlemeshev/skills` repository. The user permits work on its `main` branch. The checkout is `/home/lem/code/github.com/ivanlemeshev/skills`. The user keeps only the code review skill and selects one portable Agent Skills package. The repository contains no dotfiles migration text or third-party skill instructions.

The repository provides [release `v1.0.0`](https://github.com/ivanlemeshev/skills/releases/tag/v1.0.0) with publication date 2026-11-07. The tag resolves to commit `ef47d5826aaec6870b3115ed4d50360fc84e0fd2`. Its package path is `skills/lem-review/`. The package contains `SKILL.md`, `LICENSE`, `references/review-method.md`, and `references/examples.md`. It has no separate Claude copy, plugin marketplace, or agent-specific invocation metadata.

Remote installation passes for Codex and Claude Code with GitHub CLI. Each check uses a separate empty temporary directory and the `v1.0.0` tag:

```sh
gh skill install ivanlemeshev/skills lem-review --pin v1.0.0 --agent codex --dir TEMP_CODEX_DIRECTORY
gh skill install ivanlemeshev/skills lem-review --pin v1.0.0 --agent claude-code --dir TEMP_CLAUDE_DIRECTORY
```

Both installed packages match byte for byte. Verification checks the standard metadata, source repository, pinned tag, package path, license, and relative reference files. The review instructions and reference contents match the legacy review skill. These checks cover release download and package contents. They do not run a behavioral review in either agent.

The skill uses `$lem-review` in Codex and `/lem-review` in Claude Code. Invocation settings depend on the agent. The former Claude `lem` plugin namespace and Codex explicit-invocation metadata do not apply to this portable release.

The PDF summary, simplification, and software design review skills are outside the selected release. The OpenAI language plugins have a separate locally verified export under D14. Their cleanup dispositions remain subject to the live link audit and deletion manifest. The upstream `ub-mode` source stays separate from the personal skills repository. Its recorded commit is `3da62bf3fcfd2034de41f30d920d2739e566171f`.

The dotfiles source packages, installed system skills, unrelated user skills, and live skill links stay unchanged. Step 5 still requires the live link audit before legacy removal.

## OpenAI plugin export checkpoint

The user selects `/home/lem/code/github.com/ivanlemeshev/openai-plugins` as the separate plugin repository. The checkout uses `main`. It contains all nine language plugin packages under `plugins/` and the existing `.agents/plugins/marketplace.json`. The marketplace keeps its `lem-plugins` name. Plugin IDs, versions, prompts, and instruction bodies stay unchanged.

Three skill descriptions need YAML quoting. The English Writing subtitle exceeds the supported length and now uses `Проверка английских текстов`. The old text-only Git attribute rule damages the PNG icons. Valid installed cache copies reproduce each damaged source icon after CRLF normalization. The export restores those original binary PNG bytes and marks `*.png` as binary.

All nine plugin manifests pass the declared Agent Plugins 1.0.0 schema. Verification checks the skill frontmatter, package names, marketplace paths, icon paths, image dimensions, file sizes, and PNG chunk checksums. It also compares the copied instructions and retained metadata with the source. The new repository contains standalone documentation and a license in each plugin.

The user authorizes this specific source move. The feature worktree removes the 28 tracked files under `codex/` after destination verification. The original checkout and account-installed plugins stay unchanged. The new repository still needs commit, push, and remote installation verification before the dotfiles removal merges. No account update or public directory submission runs.

## Root cutover verification

The root cutover preserves the ignored Neovim package lock file. The old lint workflow now checks the retained Bash scripts. The temporary migration workflow uses root bootstrap and Docker paths. Its Linux container jobs seed broken legacy configuration and agent links before bootstrap.

Local verification builds Ubuntu 26.04 and Fedora 44 images. Migration fixtures run in both containers. They cover broken legacy and wrapper links, repeated migration, unrelated agent links, configuration backup restoration, the iTerm2 directory case, and Konsole recovery records. The native mise link lifecycle also passes in Ubuntu and Fedora containers: apply, repeat, unapply, backup restoration, and reapply. Bash, Python, and TOML syntax checks pass. ShellCheck and workflow validation pass. Windows PowerShell 5.1 parses the retained scripts. Windows temporary fixtures verify junction and file backup restoration. Administrator-only Windows symlink creation and full platform bootstraps remain CI checks after commit and push. No live host configuration changes run.
