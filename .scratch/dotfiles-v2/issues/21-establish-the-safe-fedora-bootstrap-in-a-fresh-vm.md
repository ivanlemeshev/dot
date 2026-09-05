# Establish the safe Fedora Bootstrap in a fresh VM

Type: task
Status: ready-for-agent

**What to build:** A normal user can run the Bootstrap on a fresh Fedora KDE Plasma VM, see planned privileged actions, and get a clear stop on an unsupported Target platform.

**Blocked by:** 20: Automate the Fedora KDE Plasma VM runner.

- [ ] Detect and validate Fedora KDE Plasma before any change stage.
- [ ] Preview privileged actions and require a normal user with controlled `sudo`.
- [ ] Stop with a clear result on an unknown or unsupported Target platform.
- [ ] Add command behavior tests and pass the fresh-VM check with retained evidence.
