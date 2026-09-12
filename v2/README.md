# Dotfiles v2

## Virtual machines

`v2/bin/vm` creates disposable test guests.
Libvirt creates the Fedora and Ubuntu base images.

Run `v2/bin/vm --help` to show the command reference.
Run `v2/bin/vm check fedora` before you build Fedora.
Run `v2/bin/vm check ubuntu` before you build Ubuntu.
Run `v2/bin/vm check` to check both supported targets.
Run `v2/bin/vm fetch <target>` to download a verified Linux ISO.
Run `v2/bin/vm build fedora` to create a stopped Fedora base image.
Run `v2/bin/vm build ubuntu` to create a stopped Ubuntu base image.
Run `v2/bin/vm run <target>` to create, boot, and open a disposable test overlay.
Run `v2/bin/vm stop <target>` to stop and remove a disposable test overlay.
`run` returns after it starts Virtual Machine Manager.

The command stores ISOs and failed build logs in `v2/.cache/vms/`.
Libvirt stores base and test disks in its `default` storage pool.
On Fedora, this pool usually stores disks in `/var/lib/libvirt/images/`.
`dot-v2-<target>-base.qcow2` is the reusable base disk.
`dot-v2-<target>-test.qcow2` is the disposable test overlay.
The command reuses a verified ISO.
`build` asks before it replaces a ready base image.
`build` replaces an incomplete base image without a prompt.
`build` needs a terminal before it can replace a ready base image.
`build` removes a partial disk when the installer fails.
`build` keeps its installer log when the installer fails.
`run` refuses when a test overlay already exists.
`stop` preserves the base image and removes the test overlay.

Fedora uses the Everything netinstall ISO and Kickstart.
Fedora installs KDE Plasma from Kickstart and uses UEFI.
Ubuntu uses a NoCloud seed ISO and UEFI.
