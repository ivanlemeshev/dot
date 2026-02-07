# Tmux

**Prefix Key:** `Ctrl+Space`

## Session Management

### Commands

- `<prefix>:` - Enter command mode
- `:new` (in command mode) - Create new session
- `<prefix>d` - Detach current session

### Command Line

```bash
tmux                         # Start new session
tmux new -s <name>           # Start new named session
tmux ls                      # List sessions
tmux attach -t <name>        # Attach to session
tmux kill-session -t <name>  # Kill session
tmux kill-server             # Kill tmux server (kills all sessions)
```

## Window Management

- `<prefix>c` - Create new window
- `<prefix>n` - Move to next window
- `<prefix>p` - Move to previous window
- `<prefix>,` - Rename current window
- `<prefix>&` - Kill current window

## Pane Management

### Splitting

- `<prefix>%` - Split window vertically
- `<prefix>"` - Split window horizontally

### Navigation

- `<prefix>` + arrow keys - Navigate between panes
- `<prefix>z` - Zoom in/out current pane

### Management

- `<prefix>x` - Kill current pane

## Copy Mode

### Entering & Exiting

- `<prefix>[` - Enter copy mode
- `Esc` or `q` - Exit copy mode

### Navigation in Copy Mode

- `h` - Move cursor left
- `j` - Move cursor down
- `k` - Move cursor up
- `l` - Move cursor right
- `w` - Move forward by word
- `b` - Move backward by word
- `0` - Move to start of line
- `$` - Move to end of line
- `g` - Move to top of buffer
- `G` - Move to bottom of buffer
- `Ctrl+u` - Scroll up half page
- `Ctrl+d` - Scroll down half page

### Copying & Pasting

- `Space` (in copy mode) - Start selection
- `Enter` (in copy mode) - Copy selected text
- `<prefix>]` - Paste copied text
- `<prefix>y` - Copy selected text to clipboard
- `<prefix>i` - Paste from clipboard
- `Ctrl+Shift+v` - Paste from clipboard (Windows)

## Plugin Management (TPM)

- `<prefix>I` - Install plugins
- `<prefix>U` - Update plugins
- `<prefix>u` - Remove/uninstall plugins

## Useful Commands

```bash
# List all key bindings
<prefix>?

# Reload tmux configuration
<prefix>:source-file ~/.tmux.conf

# List all tmux commands
tmux list-commands

# Show all tmux options
tmux show-options -g
```
