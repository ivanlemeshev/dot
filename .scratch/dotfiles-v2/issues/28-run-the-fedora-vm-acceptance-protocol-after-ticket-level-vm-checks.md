# Run the Fedora VM acceptance protocol after ticket-level VM checks

Type: task
Status: ready-for-agent

**What to build:** Two independent fresh Fedora KDE Plasma VMs provide the required automated checks, manual checklist, state comparisons, rerun evidence, and retained reports after every implementation ticket has already passed its VM check.

**Blocked by:** 27: Provide staged updates and managed-state rollback in a fresh VM.

- [ ] Run the Bootstrap and required checks on two fresh Fedora KDE Plasma VMs.
- [ ] Verify ISO, VM, state comparison, command-result, manual-checklist, and rerun evidence is retained.
- [ ] Fail acceptance for required-tool, desktop, security, permission, allow-list, or current-dotfiles-preservation failures.
- [ ] Record the final acceptance result and evidence locations.
