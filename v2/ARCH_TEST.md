# Test Arch

Use this guide on a normal Linux host session.
The sandbox cannot create virtual machines.

This test downloads the Arch Linux ISO.
The test creates a 50 GiB base disk in the libvirt `default` storage pool.
The installer uses 4 GiB of RAM and 2 vCPUs.

## 1. Prepare the host

Install the host tools.

```bash
sudo dnf install curl jq coreutils libvirt-client libvirt-daemon-kvm virt-install virt-manager cloud-utils-cloud-localds acl
sudo systemctl enable --now libvirtd
```

Run this command from the repository root.

```bash
v2/bin/vm check arch
```

The command must print `Host checks pass.`.

## 2. Download and verify the ISO

```bash
v2/bin/vm fetch arch
```

The command verifies the SHA-256 checksum before it saves the ISO.
The ISO file is stored in `v2/.cache/vms/iso/`.

## 3. Build the clean base image

```bash
v2/bin/vm build arch
```

Keep this terminal open.
The installer sends serial progress to this terminal.
The build creates a NoCloud seed from `data/arch/user-data` and `data/arch/meta-data`.
The seed runs `data/arch/install.sh` after the Arch live system starts.
The script creates the `tester` user with the `tester` password.
The script installs Hyprland, Noto fonts, its desktop portal, foot, Polkit, and greetd.
The script powers off when installation completes.

The command must finish with both messages below.

```text
Base image is ready: arch
Build completed: arch in <duration>
```

## 4. Check the clean base image

```bash
v2/bin/vm run arch
```

Virtual Machine Manager opens the guest console.
Sign in with `tester` and `tester`.
Confirm that Hyprland starts.
Press `Super+Enter` to open foot.
Shut down the guest and remove its disposable overlay.

```bash
v2/bin/vm stop arch
```
