# Setup with mise

This folder contains the Ubuntu 26.04, Fedora KDE, macOS, and Windows x64 setup.
Clone the repository before setup.

`config.toml` declares shared tools, colors, and links.
`linux/tasks`, `macos/tasks`, and `windows/tasks` contain the platform tasks.
`miserc.toml` selects `config.linux.toml`, `config.macos.toml`, or `config.windows.toml` for the current platform.
The Linux configuration selects Ubuntu or Fedora packages from `/etc/os-release`.
It excludes the old repository configuration from discovery.
The setup links `~/.config/mise` to this folder.
Ubuntu and Fedora stop if that path contains another configuration.
Move that configuration before Linux setup.
macOS and Windows move an existing configuration to a backup before they create the link.

## Machine settings

Copy `config.local.toml.example` to `config.local.toml` in this folder for a new machine.
For an existing machine, use the explicit import command after Python is available:

```sh
python mise/utilities.py import-settings --source config.env --dry-run
python mise/utilities.py import-settings --source config.env
```

The importer reads supported assignments without executing `config.env`.
It preserves values that already exist in the local TOML file.
It prints setting names without their private values.
After bootstrap, `mise run import-settings --source /path/to/config.env` provides the same command.
Edit the values before setup.
Git ignores the local file.
Docker excludes it from the build context.

`TIMEZONE` sets the Ubuntu, Fedora, or macOS time zone.
`WINDOWS_TIMEZONE` sets the Windows time zone with a Windows time zone ID.
`MACHINE_NAME` sets the computer name.
Windows applies the new name after a restart.
Omit these values to keep the current machine settings.

`GIT_USER_NAME`, `GIT_USER_EMAIL`, and `GIT_DEFAULT_BRANCH` set local Git values.
The setup stores them in `~/.config/git/config.local`.
The managed Git configuration includes that file.
Before link replacement, bootstrap copies existing global Git name, email, and default branch values when their local values are absent.

`KDE_TERMINAL_FONT` sets an optional local Konsole font override.
The KDE adapter uses a local profile that inherits the shared profile.
The shared repository profile stays unchanged.

Every normal bootstrap run upgrades installed native packages before configuration.
Ubuntu uses APT, Fedora uses DNF, macOS uses Homebrew, and Windows uses WinGet and MSYS2.
These commands do not upgrade the operating system to a new release.
The dry run reports this step without running upgrades.

## Explicit utilities

Run these commands after mise and its Python tool are available:

```sh
mise run reset-nvim --dry-run
mise run reset-nvim --yes
mise run set-git-repo-user --repo /path/to/repository --name "Your Name" --email "you@example.com"
```

The reset removes the Neovim configuration, data, state, and cache directories on Unix.
On Windows, it removes `%LOCALAPPDATA%/nvim` and `%LOCALAPPDATA%/nvim-data`.
It unlinks a configuration symlink without deleting its source.
It respects the Unix XDG directory variables.
Run bootstrap to restore the Neovim configuration link after reset.
The Git task changes only the repository user name and email.

Skill installation stays outside bootstrap.
The separate `ivanlemeshev/skills` repository supplies tagged personal skill releases and explicit installation commands.
The upstream `ub-mode` skill keeps its name and uses a pinned commit for on-demand installation.
Skill export and release verification remain pending.
Existing skill sources stay in place until migration completes.

## Ubuntu

Run this command from the repository root:

```sh
./mise/bootstrap.sh
```

The script installs Git, curl, mise, Ubuntu packages, and mise tools.
It links the application configuration.
It configures Fish, Vim, Neovim, tmux, fonts, colors, and command line tools.
It installs Mason tools and Tree-sitter parsers.
It verifies the setup and starts Fish.
Use `--no-shell` to stop after verification.

The setup installs Fish, fzf, Vim, and Ghostty from Ubuntu packages.
In an Ubuntu GNOME desktop session, Caps Lock maps to Ctrl.
The adapter preserves unrelated XKB options and records the previous value for restoration.
WSL and containers use the host keyboard mapping.
Without an active desktop session, run `mise run configure:desktop` from the desktop session later.
GitHub CLI uses its official apt repository.
Neovim uses the latest stable GitHub release.
PowerShell runs through mise for the PowerShell language server.

This preview requires mise:

```sh
./mise/bootstrap.sh --dry-run
```

Run the Ubuntu setup in a container:

```sh
docker build --file mise/Dockerfile --tag dot-mise-current .
docker run --rm dot-mise-current ./bootstrap.sh --no-shell
```

Pass machine values with Docker environment variables.
Set the container hostname with `--hostname`.

## Fedora KDE

Run the shared Bash bootstrap on mutable Fedora KDE with Plasma 6:

```sh
./mise/bootstrap.sh
```

The setup supports Fedora 43 and later.
It installs Git, curl, sudo, and the DNF plugins before mise.
DNF installs the Fedora packages.
The package configuration enables `scottames/ghostty` through COPR.
Fedora uses native `bat`, `fd`, and fzf commands.
`clang-tools-extra` supplies the Clang utilities.
Fedora supplies `ffmpeg-free` and Wayland clipboard support.
The setup keeps the Fedora codec selection.
It does not add RPM Fusion.

The shared Linux tasks configure Fish, Vim, Neovim, tmux, fonts, Git, and the command line tools.
The setup uses Fedora Neovim when it provides version 0.12 or later.
It upgrades an older package before it tries the stable upstream release.
It uses the native Tree-sitter CLI when it meets the Neovim version requirement.
Ubuntu keeps its newer Tree-sitter CLI installation.

Konsole uses the static `dot.profile` and the shared custom ANSI palette.
The KDE adapter links both files into `~/.local/share/konsole`.
It selects the profile through the native KDE settings tool.
It maps Caps Lock to Ctrl and disables the diacritics popup.
It preserves unrelated XKB options and KDE settings.
It reloads the keyboard configuration when the desktop session bus is available.
Otherwise, log out and back in to apply the keyboard settings.
KDE settings and Konsole backups use `~/.local/state/dotfiles-fedora`.

Preview packages and shared links with `./mise/bootstrap.sh --dry-run`.
The preview does not run the KDE adapter.
Use `--no-shell` to stop after verification.
Use `mise run unapply` to restore the KDE settings and Konsole files, then remove the shared Linux links.
The task stops if later changes conflict with restoration.

Build the Fedora container from the repository root:

```sh
docker build --file mise/Dockerfile.fedora --tag dot-mise-fedora .
docker run --rm dot-mise-fedora ./bootstrap.sh --no-shell
```

The container checks packages, tools, links, and KDE configuration files.
It does not check keyboard input or Konsole rendering in a live Plasma session.
Run that smoke check on the Fedora desktop.

## macOS

Run the shared Bash bootstrap from the repository root:

```sh
./mise/bootstrap.sh
```

The script finds Homebrew in the Apple Silicon or Intel prefix.
It installs Homebrew when absent.
It installs Git and mise before the main setup.
It upgrades mise when the installed version is too old.
Homebrew can request administrator access during its initial installation.
Complete the Xcode Command Line Tools installation if the script requests it.
Then run setup again.
Use a macOS version that Homebrew supports.

Homebrew supplies native applications, compilers, Lua, LuaRocks, and command line tools.
Mise supplies the shared language tools and PowerShell.
The setup upgrades Neovim, Tree-sitter CLI, and GitHub CLI when their capabilities are insufficient.
It installs Fish plugins, tmux plugins, and Runic.
It installs Codex CLI and Claude Code as native Homebrew casks.
It keeps Racket outside this setup.

The setup links the shared application configurations and the iTerm2 dynamic profile.
It selects the custom iTerm2 profile and preserves the previous iTerm2 preference values.
It installs JetBrains Mono, Hack, and Hurmit Nerd Fonts.
Zsh and Bash load Homebrew and mise through managed activation blocks.
Fish loads Homebrew before mise.
The setup registers Fish in `/etc/shells` and selects it as the login shell.

Caps Lock maps to Ctrl through `hidutil`.
A managed LaunchAgent applies the map at login and checks it every minute after keyboard reconnection.
The adapter preserves other key mappings.
Machine state and application configuration backups use `~/.local/state/dotfiles-macos`.
The global mise configuration backup sits beside `~/.config/mise`.
Restore that backup manually after configuration removal if you want the old setup.
The setup stops before replacement when an existing iTerm2 directory link contains other profiles.

Preview packages and links with `./mise/bootstrap.sh --dry-run`.
This mode requires mise.
Use `--no-shell` to stop after verification.

## Windows

Run this command from the repository root in 64-bit PowerShell:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\mise\bootstrap.ps1
```

The script requests administrator access for symlinks, system packages, and the Caps Lock map.
It opens the elevated window in this folder.
The original window returns after launch.
The elevated window shows errors and waits for Enter before it closes.
`-NoShell` disables this wait.
It installs WinGet when absent.
It installs Git, PowerShell 7, and mise before the main setup.
Use `-NoShell` to stop after verification.
The default opens PowerShell 7 with mise active.

WinGet installs native applications and command line packages.
Mise installs the shared language tools.
MSYS2 supplies native Lua, LuaRocks, GCC, and GDB.
Visual Studio Build Tools supplies the Microsoft C++ compiler.
The setup checks the required Neovim and Tree-sitter versions.
It upgrades these packages when the installed versions are too old.

The setup deploys PowerShell profiles, Neovim, Vim, PSMux, VS Code, bat, ripgrep, Git colors, and the Oh My Posh theme.
It installs the VS Code theme, icon theme, spelling tools, and PowerShell extension.
It installs Runic, grpcurl, Codex CLI, and Claude Code.
It installs the JetBrains Mono Nerd Font and maps Caps Lock to Ctrl.
Restart Windows to apply the keyboard map.

The Terminal adapter adds the custom palette and theme to Windows Terminal settings.
It preserves personal profiles and stores a restore record outside the repository.
Existing conflicting dotfiles receive backups before link replacement.
Backup paths appear in the output.
The global mise configuration backup sits beside `~/.config/mise`.
Restore that backup manually after configuration removal if you want the old setup.
State files use `~/.local/state/dotfiles-windows`.

This preview requires mise:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\mise\bootstrap.ps1 -DryRun
```

The preview lists packages and links.
It does not install packages, replace files, change the registry, or update Terminal settings.

## Verification and removal

Run `mise run verify` from any directory after setup.
Run `mise dot status --missing` to check managed links.
Neovim verification checks every required tool and parser.

On Ubuntu, run `mise run unapply` to restore the desktop keyboard setting and remove managed links and activation blocks.
On macOS, run `mise run unapply` to unload the keyboard agent, restore the keyboard mapping and iTerm2 preferences, remove managed links, and restore configuration backups.
The task stops if later changes conflict with restoration.
Installed packages, fonts, the selected login shell, and optional computer settings remain.
On Windows, run `mise run unapply` from an elevated PowerShell.
The Windows task removes managed links and restores their backups.
It also restores the keyboard map and Terminal settings when they still match the applied state.
The task stops if a later change conflicts with restoration.
Installed packages and fonts remain on the machine.

Remove the global configuration link after link removal if you want to stop this setup.
Keep the repository and state files until restoration completes.

The terminal supplies the ANSI palette.
Terminal applications use color indexes 0–15.
Windows Terminal, VS Code, Ghostty, Konsole, and iTerm2 use the shared custom palette.
Mise keeps `NO_COLOR` unset and enables accessible GitHub CLI colors.
Ubuntu, Fedora, and macOS use tmux.
Windows uses PSMux.

## Temporary migration CI

`.github/workflows/mise-migration.yml` verifies the migration on standard GitHub runners.
A push to `feat/mise-ubuntu-dotfiles` starts the jobs when mise files or the workflow change.
The jobs cover Ubuntu 26.04, Fedora 44 in Docker, Windows Server 2025, and macOS 26 on Apple Silicon.
Each job runs bootstrap, verification, a repeat bootstrap, restoration, and reapplication.
The Ubuntu native job also checks GNOME keyboard settings in a temporary D-Bus session.
The workflow uses read-only repository permissions.
Logs use short artifact retention.
The migration plan removes this temporary workflow after final root verification.
CI does not prove terminal rendering or physical keyboard behavior.
