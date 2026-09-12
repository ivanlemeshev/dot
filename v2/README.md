# Dotfiles v2

## Virtual machines

`v2/bin/vm` creates disposable test guests.
Libvirt creates the Fedora base image.

Run `v2/bin/vm --help` to show the command reference.
Run `v2/bin/vm check fedora` before you build Fedora.
Run `v2/bin/vm check` to check every target.
Run `v2/bin/vm fetch <target>` to download a verified Linux ISO.
Run `v2/bin/vm build fedora` to create a stopped Fedora base image.
Run `v2/bin/vm run <target>` to create, boot, and open a disposable test overlay.
Run `v2/bin/vm stop <target>` to stop and remove a disposable test overlay.
`run` returns after it starts Virtual Machine Manager.

The command stores ISOs and failed build logs in `v2/.cache/vms/`.
Libvirt stores Fedora base and test disks in its `default` storage pool.
On Fedora, this pool usually stores disks in `/var/lib/libvirt/images/`.
`dot-v2-fedora-base.qcow2` is the reusable base disk.
`dot-v2-fedora-test.qcow2` is the disposable test overlay.
The command reuses a verified ISO.
`build` asks before it replaces a ready base image.
`build` replaces an incomplete base image without a prompt.
`build` needs a terminal before it can replace a ready base image.
`build fedora` removes a partial disk when the installer fails.
`build fedora` keeps its installer log when the installer fails.
`run` refuses when a test overlay already exists.
`stop` preserves the base image and removes the test overlay.

Windows needs a manual Evaluation Center download.
Rename the file to `Windows_11_Enterprise_25H2_x64.iso`.
Put the file in `v2/.cache/vms/iso/`.
Put its Microsoft-published SHA-256 value in a `.sha256` file beside the ISO.
Fedora uses the Everything netinstall ISO and Kickstart.
Fedora installs KDE Plasma from Kickstart and uses UEFI.
Packer uses NoCloud for Ubuntu.
Packer uses archinstall for Arch and Autounattend.xml for Windows.
The Windows build config enables UEFI and TPM 2.0.
Windows uses SATA and e1000 devices during build and runtime.
