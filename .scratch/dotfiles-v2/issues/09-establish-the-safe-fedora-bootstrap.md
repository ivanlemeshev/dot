# 09: Establish the safe Fedora Bootstrap

Status: wontfix

**What to build:** A normal user can start the Bootstrap on Fedora KDE Plasma, see planned privileged actions, and get a clear stop on an unsupported target platform.

**Blocked by:** None (can start immediately).

- [x] Detect and validate Fedora KDE Plasma before any change stage.
- [x] Preview privileged actions and require a normal user with controlled `sudo`.
- [x] Stop with a clear result on an unknown or unsupported target platform.
- [x] Add behavior tests for validation, preview, and refusal paths.

## Answer

Implemented on branch `ticket-09-safe-fedora-bootstrap`. The native `v2/bootstrap.sh` command validates Fedora KDE Plasma, rejects root and missing `sudo`, and previews the next privileged actions without changes. Behavior tests cover supported, unsupported, non-KDE, root, and missing-`sudo` paths.

## Comments

Superseded by [Establish the safe Fedora Bootstrap in a fresh VM](20-establish-the-safe-fedora-bootstrap-in-a-fresh-vm.md). This ticket did not have the required real VM test.
