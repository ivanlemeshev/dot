# Dotfiles v2 wayfinding map

## Destination

Define an implementation-ready specification for Dotfiles v2. It starts with a safe, repeatable Fedora KDE Plasma bootstrap that is tested in virtual machines, while preserving the current dotfiles until migration.

## Notes

Use the terms in `CONTEXT.md`. Work one decision ticket per session. Dotfiles v2 will live in a separate repository directory until migration. The first target platform is Fedora KDE Plasma. The bootstrap installs public tools and applies safe, allow-listed system settings. It must support a shared core and platform layers. Omarchy is a source of tool and workflow ideas, not a design to copy. Use `research`, `grilling`, and `domain-modeling` as each ticket requires.

## Decisions so far

<!-- Closed tickets appear here as short links. -->

- [Research Omarchy tool and workflow ideas](issues/01-research-omarchy-tool-and-workflow-ideas.md): [source-linked inventory](research/omarchy-tool-and-workflow-ideas.md) separates portable tool ideas from Omarchy- and Arch-specific components.

## Not yet specified

- The shared core and platform layers for Ubuntu, Arch Linux, macOS, and Windows after the Fedora KDE Plasma path is proven.
- The private configuration, account, and secret workflow.
- The visual design and the full KDE Plasma configuration scope.
- Ongoing update, rollback, and maintenance policy.

## Out of scope

- Replacing the current dotfiles before Dotfiles v2 passes its Fedora acceptance tests.
