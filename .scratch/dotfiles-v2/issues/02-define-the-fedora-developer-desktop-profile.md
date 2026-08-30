# Define the Fedora developer desktop profile

Type: grilling
Status: resolved
Blocked by: 01

## Question

Which tools and configuration belong in the first Fedora KDE Plasma developer desktop profile, based on the current setup and the Omarchy research? Which tools are optional experiments or explicitly excluded?

## Answer

The Fedora KDE Plasma developer desktop profile includes Ghostty, Neovim, Fish, Git, GitHub CLI, `bat`, `fd`, `fzf`, `jq`, `ripgrep`, `mise`, Tmux, LazyGit, rootless Docker with Docker Compose, and Lazydocker. It uses a plain Fish prompt and the shared font stack. On Windows, Fish runs in MSYS2 while PowerShell remains available for Windows-only work.

The profile excludes `btop`, `htop`, `eza`, `fastfetch`, Starship, Oh My Posh, `tldr`, `zoxide`, `dua`, LocalSend, and Podman. Fedora's standard `top` remains available. Docker group membership is prohibited because it gives broad host control.
