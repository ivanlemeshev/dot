# Automate the Fedora KDE Plasma VM runner

Type: task
Status: ready-for-agent

**What to build:** A local libvirt/QEMU command can provision, test, retain evidence from, and remove one fresh Fedora KDE Plasma VM without manual desktop setup.

**Blocked by:** None.

- [ ] Download the selected Fedora KDE Plasma ISO and verify its signed checksum before use.
- [ ] Provision a UEFI VM with 4 GiB RAM, a 30 GiB disk, the default libvirt network, a non-root test user, SSH, and SDDM KDE Plasma auto-login.
- [ ] Run a harmless SSH check in the KDE Plasma session and retain its machine-readable report and logs.
- [ ] Remove the VM and disk after a successful or failed run while retaining ISO metadata and evidence.
