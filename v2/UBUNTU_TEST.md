# Test Ubuntu

Use this guide on a normal Linux host session.
The sandbox cannot create virtual machines.

This test downloads the Ubuntu Live Server ISO.
The test creates a 50 GiB base disk in the libvirt `default` storage pool.
The Server installer uses 4 GiB of RAM and 2 vCPUs.

## 1. Prepare the host

On Fedora, install the host tools.

```bash
sudo dnf install curl jq coreutils libvirt-client libvirt-daemon-kvm virt-install virt-manager cloud-utils-cloud-localds acl
sudo systemctl enable --now libvirtd
```

On Ubuntu, install the host tools.

```bash
sudo apt install curl jq coreutils qemu-kvm libvirt-daemon-system libvirt-clients virtinst virt-manager cloud-image-utils acl
sudo systemctl enable --now libvirtd
```

Run this command from the repository root.

```bash
v2/bin/vm check ubuntu
```

The command must print `Host checks pass.`.
If it cannot connect to `qemu:///system`, give your user account libvirt access.
Then start a new login session.
Run the check again.

## 2. Download and verify the ISO

```bash
v2/bin/vm fetch ubuntu
```

`curl` shows its transfer meter in the terminal.
The command verifies the SHA-256 checksum before it saves the ISO.
The ISO file is stored in `v2/.cache/vms/iso/`.
The command prints `ISO is ready:` when the checksum passes.

Run the command again to check that it reuses the verified cache.
It must return without a new download.

## 3. Build the clean base image

```bash
v2/bin/vm build ubuntu
```

Keep this terminal open.
The Ubuntu installer sends serial progress to this terminal.
The build creates a NoCloud seed ISO from `data/ubuntu/user-data` and `data/ubuntu/meta-data`.
Autoinstall creates the `tester` user with the `tester` password.
Autoinstall installs the official `ubuntu-desktop` package.
Autoinstall does not run the dotfiles bootstrap.
Autoinstall powers off when installation completes.

The command must finish with both messages below.

```text
Base image is ready: ubuntu
Build completed: ubuntu in <duration>
```

The transient build domain shuts down and is removed after this result.
The base disk remains in the `default` pool as `dot-v2-ubuntu-base.qcow2`.

If a base disk already exists, the command asks before it replaces it.
Enter `N` to keep the existing base disk.
Enter `y` only when you want a new clean installation.

## 4. Check that the installed base is clean

Get a checksum before you boot a test guest.

```bash
base_path="$(virsh -c qemu:///system vol-path --pool default dot-v2-ubuntu-base.qcow2)"
sha256sum "$base_path" | tee /tmp/dot-v2-ubuntu-base.sha256
```

Create a disposable guest.

```bash
v2/bin/vm run ubuntu
```

Virtual Machine Manager opens the guest console.
Sign in with `tester` and `tester`.
Confirm that the Ubuntu desktop starts.
You can create a file or install a package in this guest.
These changes must not reach the base disk.

Shut down the guest from Ubuntu.
Then remove its disposable overlay.

```bash
v2/bin/vm stop ubuntu
```

Confirm that the base checksum does not change.

```bash
sha256sum --check /tmp/dot-v2-ubuntu-base.sha256
```

The command must print `OK`.
The `stop` command must print `Test guest stopped: ubuntu`.
It removes `dot-v2-ubuntu-test.qcow2` and preserves the base disk.

## 5. Diagnose a failed installation

Read the installer output in the build terminal first.

If the build fails, the command removes the partial base disk and seed ISO.
Run `v2/bin/vm build ubuntu` again after you fix the host or network problem.

Do not remove the base disk unless you want to discard the clean installation.
