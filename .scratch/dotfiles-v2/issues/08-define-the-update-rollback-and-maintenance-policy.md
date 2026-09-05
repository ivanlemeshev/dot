# Define the update, rollback, and maintenance policy

Type: grilling
Status: resolved

## Question

How does the user preview, apply, verify, and roll back Dotfiles v2 updates after the first successful Fedora KDE Plasma migration, while keeping package updates, platform-adapter changes, and Chezmoi changes explicit and safe to rerun?

## Answer

Dotfiles v2 provides one update command. It runs explicit stages in this order: review the selected revision and planned changes; update Fedora packages; apply changed platform-adapter actions; show the Chezmoi diff; apply Chezmoi changes only after user confirmation; then run verification. The command pauses before each stage that changes the target platform. The user can stop before a change stage.

The update command records the prior state for managed configuration and platform-adapter changes. If an update fails, its rollback restores that recorded managed state. It does not automatically downgrade packages. The report identifies package changes that require manual action.

Each update produces a timestamped local report. It records the prior and resulting Dotfiles v2 revisions, selected target platform, changed manifests, package transaction result, Chezmoi diff result, verification-command results, and rollback instructions. The report has no local-configuration values or secrets. A rerun is safe and makes no unexpected managed-file or allow-list system change.
