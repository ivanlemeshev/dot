# Apply managed home-directory configuration in a fresh VM

Type: task
Status: ready-for-agent

**What to build:** The Bootstrap uses Chezmoi to show, confirm, and apply the selected Shared core and Fedora KDE Plasma home-directory configuration on a fresh VM. Unmanaged-file conflicts stop safely.

**Blocked by:** 22: Install the Fedora developer desktop profile in a fresh VM.

- [ ] Select home-directory configuration from validated Target platform data.
- [ ] Show the Chezmoi difference and require confirmation before applying it.
- [ ] Stop without overwrite when a target is unmanaged or conflicts.
- [ ] Add command behavior tests and pass the fresh-VM check with retained evidence.
