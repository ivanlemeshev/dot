# fzf (Fuzzy Finder)

## macOS Note

On macOS, `Alt` = `Option` key. You may need to configure your terminal:

- **iTerm2**: Preferences -> Profiles -> Keys -> "Option key acts as: Esc+"
- **Terminal.app**: Preferences -> Profiles -> Keyboard -> "Use Option as Meta key"

Otherwise Option inserts special characters instead of working as Alt.

## fzf.fish Shortcuts

These shortcuts are provided by the fzf.fish plugin.

### Search

- `Ctrl+r` - Search command history
- `Ctrl+Alt+f` - Search files in current directory
- `Ctrl+Alt+l` - Search commits in git log
- `Ctrl+Alt+s` - Search files in git status
- `Ctrl+Alt+p` - Search processes
- `Ctrl+Alt+v` - Search environment variables

### Navigation (inside fzf)

- `Ctrl+p` - Move to previous entry
- `Ctrl+n` - Move to next entry
- `Tab` - Select/deselect entry (multi-select mode)
- `Enter` - Confirm selection
- `Esc` - Cancel and close fzf
