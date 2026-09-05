# 09: Establish the safe Fedora Bootstrap

Status: ready-for-agent

**What to build:** A normal user can start the Bootstrap on Fedora KDE Plasma, see planned privileged actions, and get a clear stop on an unsupported target platform.

**Blocked by:** None (can start immediately).

- [ ] Detect and validate Fedora KDE Plasma before any change stage.
- [ ] Preview privileged actions and require a normal user with controlled `sudo`.
- [ ] Stop with a clear result on an unknown or unsupported target platform.
- [ ] Add behavior tests for validation, preview, and refusal paths.
