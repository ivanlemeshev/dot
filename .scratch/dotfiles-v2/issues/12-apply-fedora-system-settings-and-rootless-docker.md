# 12: Apply Fedora system settings and rootless Docker

Status: ready-for-agent

**What to build:** The Bootstrap configures the two allow-listed KDE Plasma keyboard settings and provides working rootless Docker with Compose and no Docker-group membership.

**Blocked by:** 10: Install the Fedora developer desktop profile.

- [ ] Apply only Caps Lock-to-Ctrl and the disabled keyboard diacritics popup as KDE Plasma settings.
- [ ] Configure rootless Docker and Compose without Docker-group membership.
- [ ] Verify a container starts and stops as the normal user.
- [ ] Add behavior tests for the system-settings allow-list and rootless Docker verification.
