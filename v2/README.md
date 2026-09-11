# Dotfiles v2

## Virtual machines

`v2/bin/vm` creates cacheable test guests.

Run `v2/bin/vm check` before you download or build a guest.
Run `v2/bin/vm fetch <target>` to download a verified Linux ISO.
Run `v2/bin/vm build <target>` to create a base image.
Run `v2/bin/vm rebuild <target>` to replace an incomplete base image.
Run `v2/bin/vm stop <target>` to force off a guest.
Run `v2/bin/vm run <target>` to create and boot a disposable test overlay.
Run `v2/bin/vm remove <target>` to remove a disposable test overlay.
Run `v2/bin/vm open <target>` to show the guest in Virtual Machine Manager.
Run `tail -f v2/.cache/vms/logs/fedora-install.log` to view Fedora installer progress.

The cache is in `v2/.cache/vms/`.
The command reuses a ready ISO and base image.
Stop the base guest before you run a test overlay.

Windows needs a manual Evaluation Center download.
Rename the file to `Windows_11_Enterprise_25H2_x64.iso`.
Put the file in `v2/.cache/vms/iso/`.
Put its Microsoft-published SHA-256 value in a `.sha256` file beside the ISO.
The build config enables UEFI, Secure Boot, and TPM 2.0.
