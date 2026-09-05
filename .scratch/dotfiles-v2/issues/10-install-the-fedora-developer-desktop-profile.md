# 10: Install the Fedora developer desktop profile

Status: wontfix

**What to build:** The Bootstrap installs the selected command-line and desktop tools, including Chezmoi, through the Fedora KDE Plasma Platform adapter.

**Blocked by:** 09: Establish the safe Fedora Bootstrap.

- [ ] Declare the Shared core and Fedora KDE Plasma package selections with TOML manifests.
- [ ] Install the selected developer desktop profile through the Platform adapter.
- [ ] Verify every required tool is available after the adapter stage.
- [ ] Add behavior tests for supported package selection and installation failure reporting.

## Comments

Superseded by [Install the Fedora developer desktop profile in a fresh VM](21-install-the-fedora-developer-desktop-profile-in-a-fresh-vm.md). The earlier order did not provide an automated real VM first.
