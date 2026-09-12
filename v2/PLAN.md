# V2 virtual machine cache plan

## Goal

Create clean local virtual machines for dotfiles checks.
Use direct libvirt installs for immutable base images.
Run one virtual machine at a time in Virtual Machine Manager.
Keep installed base images so later checks do not reinstall the OS.

## Selected targets

| Name    | Source                                          | Guest type               | Disk         |
| ------- | ----------------------------------------------- | ------------------------ | ------------ |
| Fedora  | Fedora Everything 44 netinstall ISO + Kickstart | KDE Plasma desktop       | 50 GiB QCOW2 |
| Ubuntu  | Ubuntu 26.04 Desktop AMD64 ISO + NoCloud seed   | Clean desktop            | 50 GiB QCOW2 |
| Arch    | Current Arch Linux x86_64 monthly ISO           | Clean desktop            | 50 GiB QCOW2 |
| Windows | Windows 11 Enterprise 25H2 Evaluation x64 ISO   | Clean evaluation desktop | 64 GiB QCOW2 |

Fedora and Ubuntu are the current direct-libvirt targets.
Arch and Windows remain planned targets.

Use 2 vCPUs and 4 GiB RAM for each virtual machine.
Use the `qemu:///system` libvirt connection.
Use the libvirt default NAT network.
Use the `tester` account with the `tester` password in Linux guests.
Give the Linux account passwordless `sudo` access.
Do not apply post-install package updates.
Arch installs packages from its current mirror during installation.
Windows needs a Microsoft account during its first GUI run.
Windows needs no product key for its 90-day evaluation.

## Cache policy

Store local files under `v2/.cache/vms/`.
Ignore the cache in Git.
Track scripts, source URLs, ISO versions, and SHA-256 checksums.
Reuse a verified ISO on normal runs.
Ask before `build` replaces a completed base image.
Replace an incomplete base image during `build`.
Remove the failed base domain and partial image during `build`.
Keep test changes only in disposable overlays.

## Planned command seam

Keep `v2/bin/vm` as the internal VM command interface.

Add a `dot` command on the user `PATH` when the v2 CLI expands.
The command should expose the VM interface as `dot vm <command> [target]`.
Keep the dispatcher small.
Review Go only if the CLI needs concurrent jobs, durable structured state,
libvirt events, or reuse outside this repository.

```text
v2/bin/vm check
v2/bin/vm fetch <fedora|ubuntu>
v2/bin/vm build <fedora|ubuntu>
v2/bin/vm run <fedora|ubuntu>
v2/bin/vm stop <fedora|ubuntu>
```

`check` verifies host dependencies and system-libvirt access.
`fetch` downloads and verifies one ISO.
`build` creates one stopped installed base image.
`build` asks before it replaces a completed base image.
`run` creates, boots, and opens one disposable test overlay.
`stop` force-stops, undefines, and removes one disposable test overlay.
`stop` does not change the installed base image.

Tests use this command seam with stubbed host tools.
Tests do not download ISOs or create virtual machines.

## Planned implementation

1. Add the cache ignore rule and the machine configuration.
2. Add `v2/bin/vm` with dependency checks and safe cache paths.
3. Add ISO download and SHA-256 verification.
4. Add unattended Fedora, Ubuntu, Arch, and Windows install data.
5. Add direct libvirt builds that create immutable qcow2 base images.
6. Add libvirt guest definitions and base-image reuse checks.
7. Add command-seam tests before each implementation slice.
8. Build and run every guest from a normal host session.
9. Record each completed step in `v2/PROGRESS.md`.

## Host constraints

The host has 4 logical CPUs, 15 GiB RAM, and 442 GiB free disk space.
The planned cache fits in the available disk space.
Run guests one at a time.
The sandbox does not expose `/dev/kvm` or system-libvirt access.
Run the final build and GUI checks from a normal host session.
The normal host session must provide KVM access and allow `qemu:///system` access.

## Done condition

Run every virtual machine one at a time in Virtual Machine Manager.
Check that each Linux desktop accepts the `tester` login.
Complete the Windows first-run sign-in and check its desktop.
Leave the installed base images cached for later dotfiles checks.
