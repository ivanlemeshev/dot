# Fedora KDE Plasma VM runner

`run-fedora-kde.sh` provisions a Fedora KDE Plasma virtual machine. It uses the local libvirt/QEMU host. It uses 2 vCPUs and 4 GiB RAM. It uses a 30 GiB disk and the default libvirt network. It creates the non-root `dotfiles-test` user. It enables SSH and SDDM KDE Plasma auto-login.

The runner detects the host Fedora release by default. It selects the current official Fedora Everything installer ISO for that release. The kickstart installs KDE Plasma. The runner verifies the signed checksum with the matching local Fedora release key. It then checks the ISO SHA-256 value.

```bash
make vm-base-build
make vm-test-run
```

`make vm-base-build` installs Fedora to a base disk and retains that disk.

`make vm-test-run` creates an overlay disk from the base disk. It runs the SSH check and removes the VM and overlay disk. Use `make vm-base-rebuild` to build a new base disk. The current base disk remains until the new disk passes.

The runner stores ISO metadata, checksum-signature output, `virt-install` output, and a machine-readable SSH check under `$XDG_STATE_HOME/dotfiles-v2/vm-evidence`. It removes each VM and overlay disk on success or failure. The base disk remains after a successful base build. The ISO remains in `$XDG_CACHE_HOME/dotfiles-v2/iso` for a later base build.

Use `--dry-run` to inspect the resource and cleanup plan without changes.

Use `--release 44` only when the host has the matching local Fedora release key from `fedora-gpg-keys`.

Run the focused command behavior tests with:

```bash
make vm-test
```
