# Install the Fedora developer desktop profile in a fresh VM

Type: task
Status: ready-for-agent

**What to build:** The Bootstrap installs the selected command-line and desktop tools, including Chezmoi, through the Fedora KDE Plasma Platform adapter on a fresh VM.

**Blocked by:** 21: Establish the safe Fedora Bootstrap in a fresh VM.

- [ ] Declare the Shared core and Fedora KDE Plasma package selections with TOML manifests.
- [ ] Install the selected developer desktop profile through the Platform adapter.
- [ ] Verify every required tool is available after the adapter stage.
- [ ] Add command behavior tests and pass the fresh-VM check with retained evidence.
