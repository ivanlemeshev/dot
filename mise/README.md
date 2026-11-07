# Setup with mise

This folder contains the Ubuntu 26.04, macOS, and Windows x64 setup.
Clone the repository before setup.

`config.toml` declares shared tools, colors, and links.
`linux/tasks`, `macos/tasks`, and `windows/tasks` contain the platform tasks.
`miserc.toml` selects `config.linux.toml`, `config.macos.toml`, or `config.windows.toml` for the current platform.
It excludes the old repository configuration from discovery.
The setup links `~/.config/mise` to this folder.
Ubuntu stops if that path contains another configuration.
Move that configuration before Ubuntu setup.
macOS and Windows move an existing configuration to a backup before they create the link.

## Machine settings

Copy `config.local.toml.example` to `config.local.toml` in this folder.
Edit the values before setup.
Git ignores the local file.
Docker excludes it from the build context.

`TIMEZONE` sets the Ubuntu or macOS time zone.
`WINDOWS_TIMEZONE` sets the Windows time zone with a Windows time zone ID.
`MACHINE_NAME` sets the computer name.
Windows applies the new name after a restart.
Omit these values to keep the current macOS or Windows settings.
Ubuntu uses UTC when `TIMEZONE` is absent.

`GIT_USER_NAME`, `GIT_USER_EMAIL`, and `GIT_DEFAULT_BRANCH` set local Git values.
The setup stores them in `~/.config/git/config.local`.
The managed Git configuration includes that file.

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
It installs Fish plugins, tmux plugins, Runic, and OpenSpec.
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
It links the repository Codex skills when their source folder exists.
It installs Runic, grpcurl, Codex CLI, Claude Code, and OpenSpec.
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

On Ubuntu, run `mise dot unapply` to remove managed links and activation blocks.
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
Windows Terminal, VS Code, Ghostty, and iTerm2 use the shared custom palette.
Mise keeps `NO_COLOR` unset and enables accessible GitHub CLI colors.
Ubuntu and macOS use tmux.
Windows uses PSMux.
