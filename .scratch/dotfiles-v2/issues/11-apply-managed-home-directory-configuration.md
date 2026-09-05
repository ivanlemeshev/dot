# 11: Apply managed home-directory configuration

Status: wontfix

**What to build:** The Bootstrap uses Chezmoi to show, confirm, and apply the selected Shared core and Fedora KDE Plasma home-directory configuration. Unmanaged-file conflicts stop safely.

**Blocked by:** 10: Install the Fedora developer desktop profile.

- [ ] Select home-directory configuration from validated Target platform data.
- [ ] Show the Chezmoi difference and require confirmation before applying it.
- [ ] Stop without overwrite when a target is unmanaged or conflicts.
- [ ] Add behavior tests for platform selection, confirmation, and conflict handling.

## Comments

Superseded by [Apply managed home-directory configuration in a fresh VM](22-apply-managed-home-directory-configuration-in-a-fresh-vm.md).
