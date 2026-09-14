# Test Windows

Use this guide on a normal Linux host session.
The sandbox cannot create virtual machines.

This test uses the Windows 11 multi-edition ISO.
The test creates a 64 GiB base disk in the libvirt `default` storage pool.
The installer uses 4 GiB of RAM and 2 vCPUs.

## 1. Prepare the host

Install the host tools.

```bash
sudo dnf install curl jq coreutils libvirt-client libvirt-daemon-kvm virt-install virt-manager xorriso
sudo systemctl enable --now libvirtd
```

Run this command from the repository root.

```bash
v2/bin/vm check windows
```

The command must print `Host checks pass.`.

## 2. Download the Windows ISO

Microsoft does not provide a direct download URL with a SHA-256 checksum.
Download the Windows 11 multi-edition ISO from the Microsoft download page.
Save the file with this exact name.

```text
Win11_25H2_English_x64_v2.iso
```

Put the file in `v2/.cache/vms/iso/`.
Then run this command.

```bash
v2/bin/vm fetch windows
```

The command must print `ISO is ready without checksum:`.
The unattended setup installs Windows 11 Pro without a product key.
Windows remains unactivated for this disposable test.

## 3. Build the clean base image

```bash
v2/bin/vm build windows
```

The build creates an unattended CD from `data/windows/Autounattend.xml`.
The installer creates the local `tester` account with the `tester` password.
The installer powers off after its first logon.

The command must finish with both messages below.

```text
Base image is ready: windows
Build completed: windows in <duration>
```

## 4. Check the clean base image

```bash
v2/bin/vm run windows
```

Virtual Machine Manager opens the guest console.
Sign in with `tester` and `tester`.
Confirm that the Windows desktop starts.
Shut down the guest and remove its disposable overlay.

```bash
v2/bin/vm stop windows
```
