# Test Windows

Use this guide on a normal Linux host session.
The sandbox cannot create virtual machines.

This test uses the Windows 11 multi-edition ISO.
The test creates a 64 GiB base disk in the libvirt `default` storage pool.
The installer uses 4 GiB of RAM and 2 vCPUs.

## 1. Prepare the host

Install the host tools.

```bash
sudo dnf install curl jq coreutils libvirt-client libvirt-daemon-kvm virt-install virt-manager swtpm
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

## 3. Build the clean base image

```bash
v2/bin/vm build windows
```

The build opens the Windows installer in Virtual Machine Manager.
Complete every Setup and first-run page manually.
Click `I don't have a product key` when Setup asks for a key.
Select the edition that you want to test.
Create a local account and finish the first-run setup.
Shut down Windows from its desktop when the setup is complete.
The build waits for that shutdown before it saves the base image.

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
Sign in with the account that you created during the base build.
Confirm that the Windows desktop starts.
Shut down the guest and remove its disposable overlay.

```bash
v2/bin/vm stop windows
```
