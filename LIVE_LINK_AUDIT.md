# Live link audit

Audit date: 2026-11-08. Source commit: `b001cdd9f60a55ae9573d600a0b76252eac92a9d`. Branch: `feat/mise-ubuntu-dotfiles`.

This audit reads link metadata on the current WSL and Windows installations. It does not change links, application settings, packages, or agent directories. It does not inspect private setting values. It does not verify plugin installation from GitHub, as the user requests.

The user later selects repository cleanup before live machine migration. The next bootstrap replaces recognized legacy links. This changes the sequence below. The findings remain a historical record of the pre-cutover installations.

## Scope and result

WSL uses `/home/lem/code/github.com/ivanlemeshev/dot` as its old checkout. Windows uses `C:/Users/vanlm/code/dot` as its old checkout. This feature worktree is a separate checkout. Cleanup here does not change those installations until the deletion reaches their checkout.

Twelve WSL application links, one WSL backup link, and eleven Windows application links depend on legacy sources. WSL also has one agent directory link. Windows has four personal skill links. These dependencies remain active. No migration or restoration check runs during this audit.

Fedora and macOS are outside this live audit. The macOS work machine stays unchanged. CI results do not prove that a live machine has no legacy links. Confirm the disposition of each unavailable machine before cleanup reaches its checkout.

## WSL links

In this table, `<old-checkout>` means the WSL old checkout.

| Live path | Current source | Required action |
| --- | --- | --- |
| `~/.config/nvim` | `<old-checkout>/.config/nvim` | Back up and repoint through the new setup |
| `~/.config/ripgrep` | `<old-checkout>/.config/ripgrep` | Back up and repoint through the new setup |
| `~/.config/bat` | `<old-checkout>/.config/bat` | Back up and repoint through the new setup |
| `~/.config/git/colors` | `<old-checkout>/.config/git/colors` | Back up and repoint through the new setup |
| `~/.config/mise/config.toml` | `<old-checkout>/.config/mise/config.toml` | Back up and repoint through the new setup |
| `~/.config/oh-my-posh/theme.omp.json` | `<old-checkout>/.config/oh-my-posh/theme.omp.json` | Back up and repoint through the new setup |
| `~/.config/bat.backup.20261103204036/themes/custom.tmTheme` | `<old-checkout>/.config/bat/themes/custom.tmTheme` | Preserve source content before cleanup |
| `~/.config/fish/config.fish` | `<old-checkout>/.config/fish/config.fish` | Back up and repoint through the new setup |
| `~/.config/fish/conf.d/ls_colors.fish` | `<old-checkout>/.config/fish/conf.d/ls_colors.fish` | Back up and repoint through the new setup |
| `~/.config/fish/conf.d/custom_theme.fish` | `<old-checkout>/.config/fish/conf.d/custom_theme.fish` | Back up and repoint through the new setup |
| `~/.config/fish/conf.d/fzf_colors.fish` | `<old-checkout>/.config/fish/conf.d/fzf_colors.fish` | Back up and repoint through the new setup |
| `~/.tmux.conf` | `<old-checkout>/.config/tmux/.tmux.conf` | Back up and repoint through the new setup |
| `~/.vimrc` | `<old-checkout>/.config/vim/.vimrc` | Back up and repoint through the new setup |
| `~/.codex/skills` | `<old-checkout>/.codex/skills` | Remove the legacy link when agent directories are recreated |

`~/.config/mise` is a regular directory. Its `config.toml` is a legacy symlink. Linux bootstrap rejects this existing directory. Back up the complete directory before replacing it with the managed mise directory link. Record its backup path before any change.

The inspected `.bashrc`, `.profile`, and `.gitconfig` files contain no literal reference to the old WSL checkout path. This check does not exclude indirect configuration dependencies. The standard `dotfiles-ubuntu`, `dotfiles-fedora`, and `dotfiles-macos` state directories are absent under `~/.local/state`.

The bat backup contains a symlink into the legacy tree. Copy its source content into an independent backup before cleanup. A backup link alone does not preserve that content.

## Windows links

In this table, `~` means `C:/Users/vanlm`. `<old-checkout>` means the Windows old checkout. Documents resolves to `C:/Users/vanlm/Documents`.

| Live path | Current source | Required action |
| --- | --- | --- |
| `~/.config/mise` | `<old-checkout>/.config/mise` | Back up the old link before bootstrap |
| `~/.config/git/colors` | `<old-checkout>/.config/git/colors` | Repoint through mise |
| `~/.config/oh-my-posh/theme.omp.json` | `<old-checkout>/.config/oh-my-posh/theme.omp.json` | Repoint through mise |
| `~/.config/ripgrep/config` | `<old-checkout>/.config/ripgrep/config` | Back up the parent directory before directory link replacement |
| `~/.psmux.conf` | `<old-checkout>/.config/psmux/psmux.conf` | Repoint through mise |
| `~/.config/powershell/yt-dlp.ps1` | `<old-checkout>/windows/powershell/yt-dlp.ps1` | Repoint through mise |
| `~/AppData/Local/nvim` | `<old-checkout>/.config/nvim` | Back up the junction before link replacement |
| `~/AppData/Roaming/Code/User/settings.json` | `<old-checkout>/windows/vscode/settings.json` | Repoint through mise |
| `~/AppData/Roaming/Code/User/keybindings.json` | `<old-checkout>/windows/vscode/keybindings.json` | Repoint through mise |
| `~/Documents/PowerShell/profile.ps1` | `<old-checkout>/windows/powershell/profile.ps1` | Repoint through mise |
| `~/Documents/WindowsPowerShell/profile.ps1` | `<old-checkout>/windows/powershell/profile.ps1` | Repoint through mise |

The Neovim path is a junction. The other listed paths are symbolic links. `~/.config/ripgrep` is a regular directory with a managed file link inside it. Do not discard that directory during directory link replacement.

The four `~/.codex/skills/lem-*` links target the old checkout: `lem-pdf-summary`, `lem-review`, `lem-simplify`, and `lem-software-design-review`. The user permits removal and recreation of agent directories. This audit does not remove them. Install retained skills from the separate skills repository after recreation.

`~/.gitconfig` is a regular file. Preserve its existing identity and include settings before managed replacement. `~/.config/bat` and `~/.local/bin/luarocks.cmd` are absent. Windows Terminal settings exist. This audit does not read or change their contents.

## Required migration sequence

1. Record a backup destination for each conflicting file, directory, or link.
2. Preserve the bat backup source as a regular file outside the old checkout.
3. Back up the existing mise configuration before replacing its directory or link.
4. Import the selected machine settings with the explicit import task.
5. Run the new platform bootstrap only when the user selects the live machine change.
6. Verify application links, tool commands, and a second bootstrap run.
7. Recreate the agent directories under the selected separate-repository policy.
8. Check all recorded old sources again before legacy deletion reaches either checkout.

Record actual backup paths and restore commands after the migration. Restore the previous mise configuration before restoring dependent application links. Do not mark this sequence complete from a read-only audit.
