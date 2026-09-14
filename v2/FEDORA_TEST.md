# Test Fedora

Use this guide on a normal Linux host session.
The sandbox cannot create virtual machines.

This test downloads the Fedora Everything network installer.
The installer needs a working Internet connection.
The test creates a 50 GiB base disk in the libvirt `default` storage pool.
The base install uses 4 GiB of RAM and 2 vCPUs.

## 1. Prepare the host

Install the Fedora host tools.

```bash
sudo dnf install curl jq coreutils libvirt-client libvirt-daemon-kvm virt-install virt-manager
sudo systemctl enable --now libvirtd
```

Run this command from the repository root.

```bash
v2/bin/vm check fedora
```

The command must print `Host checks pass.`.
If it cannot connect to `qemu:///system`, give your user account libvirt access.
Then start a new login session.
Run the check again.

## 2. Download and verify the ISO

```bash
v2/bin/vm fetch fedora
```

`curl` shows its transfer meter in the terminal.
The command verifies the SHA-256 checksum before it saves the ISO.
The ISO file is stored in `v2/.cache/vms/iso/`.
The command prints `ISO is ready:` when the checksum passes.

Run the command again to check that it reuses the verified cache.
It must return without a new download.

## 3. Build the clean base image

```bash
v2/bin/vm build fedora
```

Keep this terminal open.
The Fedora installer sends serial progress to this terminal.
The build uses the downloaded ISO and injects `data/fedora/kickstart.cfg`.
Kickstart creates the `tester` user with the `tester` password.
Kickstart does not run the dotfiles bootstrap.
Kickstart shuts down when installation completes.

The command must finish with both messages below.

```text
Base image is ready: fedora
Build completed: fedora in <duration>
```

The transient build domain shuts down and is removed after this result.
The base disk remains in the `default` pool as `dot-v2-fedora-base.qcow2`.

If a base disk already exists, the command asks before it replaces it.
Enter `N` to keep the existing base disk.
Enter `y` only when you want a new clean installation.

## 4. Check that the installed base is clean

Get a checksum before you boot a test guest.

```bash
base_path="$(virsh -c qemu:///system vol-path --pool default dot-v2-fedora-base.qcow2)"
sha256sum "$base_path" | tee /tmp/dot-v2-fedora-base.sha256
```

Create a disposable guest.

```bash
v2/bin/vm run fedora
```

Virtual Machine Manager opens the guest console.
Sign in with `tester` and `tester`.
Confirm that KDE Plasma starts.
You can create a file or install a package in this guest.
These changes must not reach the base disk.

Shut down the guest from KDE.
Then remove its disposable overlay.

```bash
v2/bin/vm stop fedora
```

Confirm that the base checksum does not change.

```bash
sha256sum --check /tmp/dot-v2-fedora-base.sha256
```

The command must print `OK`.
The `stop` command must print `Test guest stopped: fedora`.
It removes `dot-v2-fedora-test.qcow2` and preserves the base disk.

## 5. Diagnose a failed installation

Read the installer output in the build terminal first.
The Kickstart error handler prints the relevant Anaconda logs there.

If the build fails, the command removes the partial base disk.
Run `v2/bin/vm build fedora` again after you fix the host or network problem.

Do not remove the base disk unless you want to discard the clean installation.
