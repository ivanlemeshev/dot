# Dotfiles v2

## Agent workflow

Use these skills only when needed, in this order:

1. `/grilling`: clarify the next task with one question at a time.
2. `/tdd`: test script behavior before implementation. For simple config edits, check the result directly.
3. `/lem-review`: review the diff before a commit.

Use `/diagnosing-bugs` when something breaks.
Use `/prototype` to try an uncertain approach.

## Virtual machines

`v2/bin/vm` creates cacheable test guests.

Run `v2/bin/vm check` before you download or build a guest.
Run `v2/bin/vm fetch <target>` to download a verified Linux ISO.
Run `v2/bin/vm build <target>` to create a base image.
Run `v2/bin/vm open <target>` to show the guest in Virtual Machine Manager.

The cache is in `v2/.cache/vms/`.
The command reuses a ready ISO and base image.

Windows needs a manual Evaluation Center download.
Rename the file to `Windows_11_Enterprise_25H2_x64.iso`.
Put the file in `v2/.cache/vms/iso/`.
Put its Microsoft-published SHA-256 value in a `.sha256` file beside the ISO.
The build config enables UEFI, Secure Boot, and TPM 2.0.
