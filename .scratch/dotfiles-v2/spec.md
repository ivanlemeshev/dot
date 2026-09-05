# Dotfiles v2 Fedora KDE Plasma bootstrap

Status: ready-for-agent

## Problem Statement

The current dotfiles use separate platform scripts and can change an existing machine directly. The user needs Dotfiles v2: a safe, repeatable Bootstrap for a fresh Fedora KDE Plasma target platform. It must preserve the current dotfiles until a manual Migration decision.

## Solution

Build Dotfiles v2 in a separate repository directory. It uses one Chezmoi source tree for home-directory configuration, TOML manifests for the Shared core and Platform layer, and a Fedora KDE Plasma Platform adapter for package and allow-listed system changes.

The Bootstrap uses a native Linux entry point. It detects and validates Fedora KDE Plasma, previews privilege use, applies privileged and standard-user adapter stages, shows a Chezmoi difference, requires confirmation before applying it, and then verifies the result. It records evidence for a two-VM Fedora acceptance protocol. It is safe to rerun.

## User Stories

1. As a user, I want Dotfiles v2 in a separate directory, so that the current dotfiles remain unchanged before Migration.
2. As a user, I want one explicit Bootstrap command, so that I can configure a fresh Fedora KDE Plasma machine predictably.
3. As a user, I want the Bootstrap to reject an unsupported target platform, so that it does not make changes to the wrong machine.
4. As a user, I want a preview before each privileged change stage, so that I can review changes before they occur.
5. As a user, I want the Bootstrap to run as a normal user with controlled `sudo`, so that it does not run the full process as root.
6. As a user, I want a Shared core and a Fedora KDE Plasma Platform layer, so that shared configuration stays separate from platform-specific configuration.
7. As a user, I want TOML manifests, so that tool and package selections are readable and reviewable.
8. As a user, I want native package mappings in the Fedora KDE Plasma Platform adapter, so that logical tool selections have one platform-specific implementation.
9. As a user, I want Chezmoi to own only home-directory configuration, so that system configuration stays in the Platform adapter.
10. As a user, I want to inspect the Chezmoi difference before it is applied, so that unmanaged-file conflicts stop safely.
11. As a user, I want the Bootstrap to configure Ghostty, Neovim, Fish, Git, GitHub CLI, `bat`, `fd`, `fzf`, `jq`, `ripgrep`, Mise, Tmux, LazyGit, Lazydocker, `yt-dlp`, and Cliamp, so that the selected developer desktop profile is ready.
12. As a user, I want rootless Docker with Compose and no Docker-group membership, so that container work does not require broad host control.
13. As a user, I want a plain Fish prompt and the Shared font stack, so that the interactive shell and glyph fallback are consistent.
14. As a user, I want Direnv support and project `.tool-versions` compatibility through Mise, so that project environments work without a second managed version manager.
15. As a user, I want only Caps Lock-to-Ctrl and the disabled diacritics popup in the initial KDE Plasma Platform layer, so that visual desktop choices remain unchanged.
16. As a user, I want one untracked Local configuration file for non-secret machine values, so that machine identity can vary without entering the source tree.
17. As a user, I want secrets, account logins, and private SSH keys to remain user-managed, so that the Bootstrap and its evidence do not expose them.
18. As a user, I want an Update command with review, confirmation, verification, and a local report, so that later changes are explicit and traceable.
19. As a user, I want managed-state rollback after a failed update, so that the configuration can return to its recorded prior state without automatic package downgrades.
20. As a user, I want the Bootstrap tested on two independent fresh Fedora KDE Plasma VMs, so that one machine does not hide an environmental error.
21. As a user, I want a safe rerun after a successful Bootstrap or a network failure, so that recovery does not create duplicate or unexpected changes.
22. As a user, I want retained VM evidence and state comparisons, so that I can decide whether Dotfiles v2 is ready for Migration.
23. As a user, I want Migration to be manual and backed by an archive, reviewed difference list, and rollback procedure, so that current configuration is protected.

## Implementation Decisions

- Dotfiles v2 is a new configuration system in a separate repository directory. It does not change the current dotfiles until a user-controlled Migration.
- One Chezmoi source tree owns home-directory files, templates, and shell hooks. Template data selects files for the validated Target platform.
- The configuration model has a Shared core, TOML Platform manifests, and native Platform adapters. The first concrete adapter supports Fedora KDE Plasma. Other adapter placeholders do not claim support.
- The Bootstrap has native Linux and Windows entry points. The first implementation validates Fedora KDE Plasma and stops on an unknown or unsupported Target platform.
- The Fedora Bootstrap interface has this fixed sequence: validate the Target platform; preview privileged actions; apply the privileged adapter stage; apply the standard-user adapter stage; show a Chezmoi difference; confirm before Chezmoi apply; then verify.
- Platform adapters own package installation and only allow-listed system configuration. Chezmoi does not own system configuration.
- The Fedora developer desktop profile includes Ghostty, Neovim, Fish, Git, GitHub CLI, `bat`, `fd`, `fzf`, `jq`, `ripgrep`, Mise, Tmux, LazyGit, Lazydocker, `yt-dlp`, Cliamp, rootless Docker, and Compose.
- The profile excludes `btop`, `htop`, `eza`, `fastfetch`, Starship, Oh My Posh, `tldr`, `zoxide`, `dua`, LocalSend, Podman, and Konsole configuration.
- Mise is the only managed tool version manager. It supports project `.tool-versions` data. Direnv uses the Fish hook. Tracked `.envrc` files contain no secrets and can load a local `.env.private` file when present.
- The Shared font stack is JetBrains Mono Nerd Font Mono, Noto Sans Mono CJK, and Noto Color Emoji. The Fish prompt remains plain.
- The initial Fedora KDE Plasma allow-list contains only Caps Lock-to-Ctrl and the disabled keyboard diacritics popup. All other desktop behavior and visual choices stay unmanaged.
- One untracked Local configuration file contains only non-secret, machine-specific values: Git user name, Git user email, Git default branch, timezone, and hostname. A tracked example documents its schema. The Bootstrap validates it without printing its values.
- The Bootstrap does not obtain, read, apply, or log account logins, tokens, private SSH keys, or other secrets.
- One Update command stages revision review, Fedora package update, Platform adapter changes, Chezmoi difference and confirmation, then verification. It pauses before every change stage.
- An update records managed configuration and Platform adapter state for rollback. It does not automatically downgrade packages. It produces a timestamped local report without Local configuration values or secrets.
- Migration is a manual decision after successful Fedora VM acceptance. It requires a timestamped archive outside active configuration paths, reviewed differences, a written rollback procedure, and a record of intentionally replaced paths.

## Testing Decisions

- The Fedora Bootstrap interface is the main test seam. Tests cross this seam through the native Bootstrap command. They verify observable behavior, not adapter implementation details.
- The existing Bash Automated test style is prior art for command behavior. New focused checks can test non-destructive helpers where that gives clearer failure reports.
- Two independent fresh Fedora KDE Plasma VMs are the acceptance environment. Each VM records the Fedora release and ISO verification data, VM provider and settings, Bootstrap output, machine-readable report, before-and-after state captures, command results, manual checklist, and rerun comparison.
- Acceptance verifies platform validation, privileged-action preview, both adapter stages, Chezmoi difference and confirmation, final verification, package capabilities, diagnostics versions, expected files, Chezmoi ownership, Fish hooks, fonts, services, permissions, and the system-settings allow-list.
- Acceptance starts and stops a rootless Docker test container and verifies that the user has no Docker-group membership.
- Manual checks cover Ghostty, Neovim, KDE Plasma, Fish, Shared font stack, LazyGit, Lazydocker, `yt-dlp`, and Cliamp. A required-tool failure, desktop usability failure, security or permission change outside the allow-list, or current-dotfiles preservation failure fails acceptance.
- A second Bootstrap run must complete without duplicate configuration, unnecessary changes, permission changes, or an unexpected Chezmoi difference. Only documented package metadata or timestamp changes are allowed.
- Tests simulate unavailable repositories or network resources. The Bootstrap must stop clearly, avoid partial changes where possible, and remain safe to rerun after recovery.
- State comparisons cover firewall, SSH, services, user groups, permissions, and KDE Plasma settings. Any unlisted system change fails acceptance.
- VM acceptance uses no personal accounts, tokens, SSH keys, or private repositories.

## Out of Scope

- Replacing the current dotfiles before Fedora VM acceptance passes and the user chooses Migration.
- Ubuntu, Arch Linux, macOS, and Windows support beyond placeholder Platform adapters.
- KDE Plasma wallpaper, themes, icons, panels, widgets, window decorations, display, power, notifications, workspaces, shortcuts, touchpad, and window-management settings.
- Konsole configuration.
- Managing personal accounts, tokens, private SSH keys, or other secrets.
- Automatic package downgrades during update rollback.

## Further Notes

- Omarchy is an input for tool and workflow ideas. It is not a design source to copy.
- Fedora VM acceptance proves readiness for Migration testing. It does not authorize Migration.
- On future Windows support, Fish runs in MSYS2 as the interactive development shell. PowerShell remains available for Windows-only administration and Bootstrap tasks.
