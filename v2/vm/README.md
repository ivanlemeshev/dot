# Fedora KDE Plasma VM runner

`run-fedora-kde.sh` provisions one fresh Fedora KDE Plasma virtual machine.
It uses the local libvirt/QEMU host. It uses 2 vCPUs and 4 GiB RAM. It uses a
30 GiB disk and the default libvirt network. It creates the non-root
`dotfiles-test` user. It enables SSH and SDDM KDE Plasma auto-login.

The runner detects the host Fedora release by default. It selects the current official Fedora Everything installer ISO for that release. The kickstart installs KDE Plasma. It uses the matching local Fedora release key to verify the signed checksum and then checks the ISO SHA-256 value.

```bash
v2/vm/run-fedora-kde.sh
```

The runner stores ISO metadata, checksum-signature output, `virt-install` output, and a machine-readable SSH check under `$XDG_STATE_HOME/dotfiles-v2/vm-evidence`. It removes the VM and its disk on success or failure. The ISO remains in `$XDG_CACHE_HOME/dotfiles-v2/iso` for a later run.

Use `--dry-run` to inspect the resource and cleanup plan without changes.
Use `--release 44` only when the host has the matching local Fedora release
key from `fedora-gpg-keys`.
