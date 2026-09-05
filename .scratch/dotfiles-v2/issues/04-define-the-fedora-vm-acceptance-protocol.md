# Define the Fedora VM acceptance protocol

Type: grilling
Status: resolved
Blocked by: 03

## Question

What automated and manual checks must demonstrate that the Fedora KDE Plasma bootstrap works from a clean virtual machine, is safe to rerun, and is ready for migration testing?

## Answer

Acceptance uses two independent fresh Fedora KDE Plasma VMs. The ISO is downloaded from the current stable Fedora release, and its checksum and available signature are verified. The test records the exact release, URL, checksum, download date, VM provider, and VM settings.

The reference VM uses Fedora Virtual Machine Manager (`virt-manager`) with libvirt and QEMU/KVM. The minimum VM has two vCPUs, 4 GiB RAM, a 30 GiB disk, UEFI boot, networking, and a graphical display. The test user is a normal user with controlled `sudo` access. The bootstrap never runs as root.

The automated protocol verifies the complete bootstrap sequence: platform detection, privileged-action preview, privileged adapter stage, standard-user adapter stage, Chezmoi diff, explicit confirmation, Chezmoi apply, and final verification. It checks exit status, package capabilities, versions for diagnosis, Chezmoi ownership, expected files, platform data, Fish hooks, fonts, services, permissions, and the explicit system-settings allow-list.

The command checks cover Ghostty, Neovim, Fish, Git, GitHub CLI, `bat`, `fd`, `fzf`, `jq`, `ripgrep`, `mise`, Tmux, LazyGit, Lazydocker, `yt-dlp`, Cliamp, Docker, and Compose. Rootless Docker must work without Docker-group membership. A test container must start and stop.

The manual checklist confirms that Ghostty, Neovim, KDE Plasma, Fish, the shared fonts, LazyGit, Lazydocker, `yt-dlp`, and Cliamp work. KDE Plasma must remain usable. Any required-tool, desktop, security, or v1-preservation failure fails the run.

The bootstrap must stop clearly when repositories or other network resources are unavailable. It must avoid partial changes where possible and remain safe to rerun after connectivity is restored. A second run must complete without duplicate configuration, unnecessary changes, permission changes, or unexpected Chezmoi diff. Only documented package metadata or timestamp changes are allowed.

Before and after state captures compare firewall, SSH, services, user groups, permissions, and KDE settings. Any unlisted system change fails the run. The test uses no personal accounts, tokens, SSH keys, or private repositories. Account and secret setup is outside this ticket.

Each of the two fresh-VM runs must pass. The retained evidence includes ISO metadata, VM metadata, bootstrap logs, machine-readable reports, state captures, command results, the manual checklist, and the rerun comparison. This protocol proves readiness for migration testing only. Backup, comparison, acceptance, and rollback for migration remain in “Define the migration and replacement gate.”
