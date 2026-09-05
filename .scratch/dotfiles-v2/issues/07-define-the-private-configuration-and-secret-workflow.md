# Define the local configuration and secret boundary

Type: grilling
Status: resolved

## Question

How does Dotfiles v2 obtain, store, apply, and exclude local configuration, accounts, tokens, SSH keys, and other secrets without placing secrets in the Chezmoi source tree, manifests, bootstrap logs, or retained Fedora VM acceptance evidence?

## Answer

Dotfiles v2 uses one untracked `v2/config.local.toml` file. A tracked `v2/config.local.toml.example` documents its schema. Local configuration contains only non-secret, machine-specific values: Git user name, Git user email, Git default branch, timezone, and hostname.

The bootstrap validates and uses local configuration but does not print its values. It does not create, obtain, read, apply, or log account logins, tokens, SSH keys, or other secrets. The user manages those items manually. Dotfiles v2 does not manage private SSH keys. Fedora VM acceptance evidence contains none of these items.
