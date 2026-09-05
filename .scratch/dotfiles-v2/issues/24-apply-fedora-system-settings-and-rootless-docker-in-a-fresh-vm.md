# Apply Fedora system settings and rootless Docker in a fresh VM

Type: task
Status: ready-for-agent

**What to build:** The Bootstrap configures the two allow-listed KDE Plasma keyboard settings and provides working rootless Docker with Compose and no Docker-group membership on a fresh VM.

**Blocked by:** 23: Apply managed home-directory configuration in a fresh VM.

- [ ] Apply only Caps Lock-to-Ctrl and the disabled keyboard diacritics popup as KDE Plasma settings.
- [ ] Configure rootless Docker and Compose without Docker-group membership.
- [ ] Verify a container starts and stops as the normal user.
- [ ] Add command behavior tests and pass the fresh-VM check with retained evidence.
