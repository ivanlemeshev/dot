# Fedora KDE Plasma VM runner

`run-fedora-kde.sh` provisions one fresh Fedora KDE Plasma virtual machine on
the local libvirt/QEMU host. It uses 2 vCPUs, 4 GiB RAM, a 30 GiB disk, and the
default libvirt network. It creates a non-root `dotfiles-test` user, enables
SSH, and starts an SDDM KDE Plasma auto-login session.

Before a run, select one Fedora release and an Anaconda installer ISO that
`virt-install --location` supports. The kickstart installs KDE Plasma. Do not
use a Fedora KDE Live ISO: it is not an Anaconda installation tree. Copy the
exact ISO, checksum, and checksum signature URLs from the Fedora release
download page. The runner verifies the checksum signature and the ISO SHA-256
value before it starts the VM.

```bash
v2/vm/run-fedora-kde.sh \
  --release 42 \
  --iso-url 'https://example.invalid/Fedora-ISO.iso' \
  --checksum-url 'https://example.invalid/Fedora-CHECKSUM' \
  --checksum-signature-url 'https://example.invalid/Fedora-CHECKSUM.asc' \
  --fedora-key-fingerprint '40_HEX_CHARACTERS_FROM_FEDORA'
```

The runner stores ISO metadata, checksum-signature output, `virt-install`
output, and a machine-readable SSH check under
`$XDG_STATE_HOME/dotfiles-v2/vm-evidence`. It removes the VM and its disk on
success or failure. The ISO remains in `$XDG_CACHE_HOME/dotfiles-v2/iso` for a
later run.

Use `--dry-run` to inspect the resource and cleanup plan without changes.
