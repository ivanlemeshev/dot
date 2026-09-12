# Dotfiles v2

## Virtual machines

`v2/bin/vm` creates cacheable test guests.

Run `v2/bin/vm --help` to show the command reference.
Run `v2/bin/vm check` before you download or build a guest.
Run `v2/bin/vm fetch <target>` to download a verified Linux ISO.
Run `v2/bin/vm build <target>` to create a stopped base image.
Run `v2/bin/vm run <target>` to create, boot, and open a disposable test overlay.
Run `v2/bin/vm stop <target>` to stop and remove a disposable test overlay.
Run `tail -f v2/.cache/vms/logs/fedora-install.log` to view Fedora installer progress.

The cache is in `v2/.cache/vms/`.
The command reuses a verified ISO.
`build` asks before it replaces a ready base image.
`build` replaces an incomplete base image without a prompt.
`build` needs a terminal before it can replace a ready base image.
`build` removes its domain and partial image when installation fails.
`build` writes installer output to `v2/.cache/vms/logs/<target>-install.log`.
`run` refuses when a test overlay already exists.
`stop` preserves the base image and removes the test overlay.

Windows needs a manual Evaluation Center download.
Rename the file to `Windows_11_Enterprise_25H2_x64.iso`.
Put the file in `v2/.cache/vms/iso/`.
Put its Microsoft-published SHA-256 value in a `.sha256` file beside the ISO.
The build config enables UEFI, Secure Boot, and TPM 2.0.
