# Dotfiles v2

## Virtual machines

`v2/bin/vm` creates disposable test guests.
Libvirt creates the Arch, Fedora, and Ubuntu base images.
Libvirt creates the Windows base image.

Run `v2/bin/vm --help` to show the command reference.
Run `v2/bin/vm check fedora` before you build Fedora.
Run `v2/bin/vm check ubuntu` before you build Ubuntu.
Run `v2/bin/vm check arch` before you build Arch.
Run `v2/bin/vm check windows` before you build Windows.
Run `v2/bin/vm check` to check all supported targets.
Run `v2/bin/vm fetch <target>` to download a verified Linux ISO.
Run `v2/bin/vm build fedora` to create a stopped Fedora base image.
Run `v2/bin/vm build ubuntu` to create a stopped Ubuntu base image.
Run `v2/bin/vm build arch` to create a stopped Arch base image.
Run `v2/bin/vm build windows` to create a stopped Windows base image.
Run `v2/bin/vm run <target>` to create, boot, and open a disposable test overlay.
Run `v2/bin/vm stop <target>` to stop and remove a disposable test overlay.
`run` returns after it starts Virtual Machine Manager.

The command stores ISOs in `v2/.cache/vms/`.
Libvirt stores base and test disks in its `default` storage pool.
On Fedora, this pool usually stores disks in `/var/lib/libvirt/images/`.
`dot-v2-<target>-base.qcow2` is the reusable base disk.
`dot-v2-<target>-test.qcow2` is the disposable test overlay.
The command reuses a verified ISO.
`build` asks before it replaces a ready base image.
`build` replaces an incomplete base image without a prompt.
`build` needs a terminal before it can replace a ready base image.
`build` removes a partial disk when the installer fails.
`build` sends installer output to the terminal.
`run` refuses when a test overlay already exists.
`stop` preserves the base image and removes the test overlay.

Fedora uses the Everything netinstall ISO and Kickstart.
Fedora installs KDE Plasma from Kickstart and uses UEFI.
Ubuntu uses the Live Server ISO, NoCloud Autoinstall, and UEFI.
Ubuntu installs the official `ubuntu-desktop` package.
Ubuntu needs `cloud-localds` and `setfacl` on the host.
Install `cloud-utils-cloud-localds` and `acl` on Fedora.
Install `cloud-image-utils` and `acl` on Ubuntu.
Arch uses the official ISO, a NoCloud seed, and an installer script.
Arch installs a minimal Hyprland desktop with greetd and tuigreet.
Arch needs `cloud-localds` and `setfacl` on the host.
Windows needs `swtpm` on the host.
Windows needs a manually downloaded Windows 11 ISO because Microsoft does not provide a direct checksum URL.
Windows setup is manual. Shut down Windows after the first-run setup to save its base image.
