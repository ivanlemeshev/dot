# ANSI color migration

This guide covers the migration from generated application themes to the custom ANSI palette.
Run these steps on each machine after the branch merge.
Run Bash commands from the repository root unless a step names another shell.
Run only the steps for applications that you use.

## 1. Update the repository

Check that PR #566 shows `MERGED`.
Preserve any uncommitted work before you switch branches.

```bash
gh pr view 566 --json state,mergedAt,mergeCommit,headRefOid
git status --short
git fetch origin
git switch main
git pull --ff-only
```

Confirm that the merge includes the iTerm2 profile fix.
Keep the branch until the machine checks pass.

## 2. Deploy terminal profiles

### Fedora KDE

The installers create the new theme links and remove the old repository-owned links.
The installers also run package installation commands.

```bash
bash install/fedora/ghostty.sh
bash install/fedora/konsole.sh
```

### macOS

Quit iTerm2 before you change its preferences.
The installers also run Homebrew installation commands.

```bash
bash install/macos/ghostty.sh
bash install/macos/iterm2.sh
```

The iTerm2 installer links only `custom.json` inside `DynamicProfiles`.
It keeps other active profiles in place.
It replaces the old directory link when that link points to this checkout.
It stores a conflicting regular profile as `custom.json.backup.TIMESTAMP` in the parent iTerm2 directory.

If you use the old installer, check for profile directory backups:

```bash
profiles="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
find "$(dirname "$profiles")" -maxdepth 1 -type d \
    -name 'DynamicProfiles.backup.*' -print
```

Inspect each backup for personal profiles.
Restore each personal profile to the active directory with a new file name.
Replace the example backup path and profile name with the actual values.
Do not replace the managed `custom.json` link.

```bash
profile_backup="$HOME/Library/Application Support/iTerm2/DynamicProfiles.backup.TIMESTAMP"
ls -la "$profile_backup"
cp -i "$profile_backup/Personal.json" "$profiles/Personal.json"
```

Start iTerm2.
Confirm that custom is the default profile.
Confirm that all personal profiles remain available.
After the check, remove the obsolete custom preference path if the key exists:

```bash
if defaults read com.googlecode.iterm2 PrefsCustomFolder >/dev/null 2>&1; then
    defaults delete com.googlecode.iterm2 PrefsCustomFolder
fi
```

Remove unused imported color presets through iTerm2 settings.

### Ghostty on Ubuntu

The Ubuntu bootstrap has no Ghostty installer.
If you install Ghostty separately, deploy its theme link with these commands.
The commands preserve an existing file or a different link as a backup.

```bash
repo="$(git rev-parse --show-toplevel)"
theme_dir="$HOME/.config/ghostty/themes"
theme_target="$theme_dir/custom"
theme_source="$repo/.config/ghostty/themes/custom"
mkdir -p "$theme_dir"
if [[ ! -L "$theme_target" ]] || [[ "$(readlink "$theme_target")" != "$theme_source" ]]; then
    if [[ -e "$theme_target" || -L "$theme_target" ]]; then
        mv "$theme_target" "$theme_target.backup.$(date +%Y%m%d%H%M%S)"
    fi
    ln -s "$theme_source" "$theme_target"
fi
```

Confirm that the active Ghostty configuration links to `.config/ghostty/config` in this repository.

### Windows

Open PowerShell in the repository root.
Quit Windows Terminal before you change its settings from another console.
These commands apply the shared settings to the detected Windows Terminal installation.

```powershell
. .\windows\bootstrap\terminal.ps1
$terminalDir = Get-WindowsTerminalSettingsDirectory
if ($null -ne $terminalDir) {
    Set-WindowsTerminalSettings $terminalDir `
        (Join-Path $PWD 'windows\terminal\settings.json')
}
```

Repeat the update for each separate installation that you use.
For Preview or a portable installation, pass its actual settings directory as the first argument to `Set-WindowsTerminalSettings`.
Keep a copy of its `settings.json` before the update.

The settings merge keeps old color schemes and themes with different names.
In the local Windows Terminal settings, remove unused `Sienna Night` entries from `schemes` and `themes`.
If the top-level `theme` selects `Sienna Night` or `Tomorrow Night`, change it to `custom`.
Keep machine-specific profiles and settings.

Confirm that VS Code settings and PowerShell profiles still link to this repository.
The existing links use the new settings without another deployment.
Start a new PowerShell session.
Restart VS Code and Windows Terminal.

## 3. Remove obsolete links on Linux and macOS

Run this block in Bash after the terminal deployment.
It removes only links with the exact old target in this checkout.
It keeps regular files and links to other checkouts.

```bash
repo="$(git rev-parse --show-toplevel)"

remove_repo_link() {
    local path="$1"
    local expected="$2"
    if [[ -L "$path" && "$(readlink "$path")" == "$expected" ]]; then
        unlink "$path"
    fi
}

remove_repo_link "$HOME/.codex/themes" "$repo/.config/codex/themes"
if [[ -n "${CODEX_HOME:-}" ]]; then
    remove_repo_link "$CODEX_HOME/themes" "$repo/.config/codex/themes"
fi
remove_repo_link "$HOME/.config/ghostty/themes/TomorrowNight" \
    "$repo/.config/ghostty/themes/TomorrowNight"
remove_repo_link "$HOME/.local/share/konsole/TomorrowNight.colorscheme" \
    "$repo/.config/konsole/TomorrowNight.colorscheme"
remove_repo_link "$HOME/.config/opencode/opencode.json" \
    "$repo/.config/opencode/opencode.json"

bat_cmd=""
if command -v bat >/dev/null; then
    bat_cmd=bat
elif command -v batcat >/dev/null; then
    bat_cmd=batcat
fi
if [[ -n "$bat_cmd" ]]; then
    bat_config="$("$bat_cmd" --config-dir)"
    "$bat_cmd" cache --build
fi
unset -f remove_repo_link
```

Inspect copied custom themes and links to other checkout paths separately.
Keep unrelated themes.

## 4. Remove obsolete Codex links on Windows

Run this block in PowerShell from the repository root.
It removes only the old theme directory link to this checkout.

```powershell
$repo = (Get-Location).Path
$expected = [IO.Path]::GetFullPath((Join-Path $repo '.config\codex\themes'))
$codexRoots = @((Join-Path $env:USERPROFILE '.codex'))
if ($env:CODEX_HOME) {
    $codexRoots += $env:CODEX_HOME
}
foreach ($root in ($codexRoots | Select-Object -Unique)) {
    $path = Join-Path $root 'themes'
    $item = Get-Item -LiteralPath $path -Force -ErrorAction SilentlyContinue
    if ($null -ne $item -and $item.LinkType -in @('SymbolicLink', 'Junction')) {
        $target = [IO.Path]::GetFullPath(@($item.Target)[0])
        if ($target -eq $expected) {
            Remove-Item -LiteralPath $path -Force
        }
    }
}
```

On each machine, select the built-in `ansi` theme in Codex if a removed custom theme remains selected.

## 5. Reload applications

Deploy the new bat theme before you reload the shell.
Run the bat, Git, and Fish installers for the current platform.
The installers preserve conflicting configuration files as backups.
The bat installer builds the theme cache.
The Git installer adds the shared ANSI color settings.
The Fish installer links the ripgrep color settings.
On Windows, run `bin/bootstrap.ps1` to update the configuration links.

In Fish, start a new login shell:

```fish
exec fish -l
```

In a running tmux session, reload the configuration:

```bash
tmux source-file ~/.tmux.conf
```

Restart Vim, Neovim, psmux, and Emacs.
For a running Emacs session, evaluate `(blink-cursor-mode 0)` instead of a restart.
Reload the terminal configuration or open a new terminal window.

## 6. Check each machine

- [ ] Check Fish syntax colors and completion selection.
- [ ] Check file listings, fzf, Oh My Posh, and bat.
- [ ] Check Vim and Neovim search, selections, and the active line number.
- [ ] Check Neovim file search, text search, diagnostic frames, Git status colors, and the blame popup.
- [ ] Confirm blue selections with readable text.
- [ ] Confirm steady cursors in the shell and editors.
- [ ] Confirm the yellow active line number with no line background.
- [ ] Confirm custom in each terminal that you use.
- [ ] Confirm that iTerm2 keeps personal profiles active after a second installer run.
- [ ] Keep backups until the machine checks pass.

Run the repository checks where their dependencies are available:

```bash
make lint
```

Run native application checks on Ubuntu, Fedora KDE, macOS, and Windows.

## 7. Remove optional leftovers

Remove local aliases, scripts, and shortcuts that call `bin/apply-color-scheme` or use the deleted `color/` paths.
Inspect installer-created `.backup.*` files after the machine checks pass.
Restore personal data before you remove a backup.
Remove each confirmed backup by its exact path.

The branch removes OpenCode setup but keeps installed programs and application data on existing machines.
Keep OpenCode if you still use it.
Otherwise, inspect the installation in Bash:

```bash
type -a opencode
```

For the old macOS Homebrew installation, use:

```bash
brew uninstall anomalyco/tap/opencode
```

On Ubuntu, remove only the executable or installation directory that belongs to the confirmed installer.
Keep session and authentication data unless you also choose to remove that data.

## 8. Remove the merged branch

Confirm that PR #566 shows `MERGED`.
Confirm that the local and remote `ansi-colors` branches contain no work after the reviewed PR head.
Preserve any uncommitted work.
Run these commands from `main` after the machine checks pass:

```bash
git status --short
gh pr view 566 --json state,mergedAt,mergeCommit,headRefOid
git log -1 --oneline ansi-colors
git ls-remote --heads origin ansi-colors
git branch -D ansi-colors
```

The forced local deletion accounts for a squash merge.
If the remote branch still exists at the merged PR head, remove it:

```bash
git push origin --delete ansi-colors
```

Keep unrelated branches.
