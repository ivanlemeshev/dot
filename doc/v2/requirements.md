# Dotfiles v2 requirements

Status: Draft. Confirmed requirements come from the user. Proposed rules and open decisions need review before dependent implementation starts.

## Purpose

Build a new dotfiles system to replace the current setup. Use the current scripts as an inventory of existing behavior. Do not assume that every existing feature belongs in v2.

## Confirmed requirements

- Support Fedora with KDE Plasma, Ubuntu, macOS, and Windows.
- Provide a single setup script that can run on each supported system.
- Support common configuration and system-specific configuration.

## Required repository rules

Follow the root [agent instructions](../../AGENTS.md). In particular, preserve existing user files, keep credentials and machine-specific values out of tracked files, and test installers and file links in temporary or disposable environments. Verify repeated runs. Use branches for changes and get explicit permission before merge or destructive actions.

## Proposed acceptance rules

- A repeated setup run makes no unnecessary configuration changes and creates no duplicate profile entries or backups.
- Setup checks prerequisites and reports unsupported systems before it changes the machine.
- Setup reports failed required steps and returns a failure status. It does not report success after a required step fails.
- Setup supports a preview of intended changes. Document any operation that cannot be previewed.
- Setup preserves existing configuration through a defined backup or conflict process. Document how to restore affected files.
- Request administrator access only for steps that need it.
- Keep package upgrades separate from routine configuration setup unless the user selects upgrades.
- Keep KDE Plasma settings separate from Fedora package setup.
- Report steps that need authentication, logout, or restart. Do not store credentials or restart automatically.

## Open decisions

### D1: Meaning of a single setup script

Evaluate one portable entry point against two small shell and PowerShell entry scripts. Two scripts require agreement to change the requirement.

Needed before: Prototype selection.

### D2: Configuration management

Evaluate `chezmoi` against a small custom implementation.

Needed before: Prototype selection.

### D3: Supported versions and CPU architectures

Record an explicit support matrix. Clarify conventional Fedora KDE versus an atomic edition.

Needed before: Platform implementation.

### D4: Windows scope

Determine native Windows, WSL, or both. Treat WSL as a separate target if included.

Needed before: Windows implementation.

### D5: Ubuntu desktop scope

Determine whether desktop settings are required and which desktop to support.

Needed before: Ubuntu desktop implementation.

### D6: Packages and optional profiles

Classify current features as required, optional, or removed. Decide whether profiles are needed.

Needed before: Package implementation.

### D7: Local settings and existing-file conflicts

Define local overrides, backup locations, and conflict handling.

Needed before: Configuration implementation.

### D8: v1 migration

Define adoption of existing links and configuration, recovery, and retirement of old scripts.

Needed before: Migration implementation.

## Change control

Update this file when a requirement changes. Record the source of agreement when an open decision is resolved. Create a separate architecture decision record only for a costly design choice with meaningful alternatives. Recommendations are not accepted decisions.

Track implementation in the [work plan](work-plan.md).
