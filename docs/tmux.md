# Tmux

## Keybindings

_(Default)_ means tmux provides the binding. _(Custom)_ means this setup or a plugin adds or changes the binding. This setup enables vi keys in copy mode for tmux and PSMux.

### Prefix and sessions

- `Ctrl+b` - Start a tmux command. _(Default)_
- `Ctrl+b Ctrl+b` - Send `Ctrl+b` to the application. _(Default)_
- `Ctrl+b :` - Open the tmux command prompt. _(Default)_
- `Ctrl+b d` - Detach the current client. _(Default)_
- `Ctrl+b s` - Choose a session. _(Default)_
- `Ctrl+b (` - Switch to the previous session. _(Default)_
- `Ctrl+b )` - Switch to the next session. _(Default)_
- `Ctrl+b L` - Return to the last session. _(Default)_

### Windows

- `Ctrl+b c` - Create a window. _(Default)_
- `Ctrl+b n` - Select the next window. _(Default)_
- `Ctrl+b p` - Select the previous window. _(Default)_
- `Ctrl+b l` - Select the previously active window. _(Default)_
- `Ctrl+b 0` through `Ctrl+b 9` - Select a window by index. _(Default)_
- `Ctrl+b ,` - Rename the current window. _(Default)_
- `Ctrl+b &` - Kill the current window. _(Default)_
- `Ctrl+b w` - Choose a window. _(Default)_
- `Ctrl+b f` - Search for text in open windows. _(Default)_

### Panes

- `Ctrl+b %` - Split the pane left and right. _(Default)_
- `Ctrl+b "` - Split the pane top and bottom. _(Default)_
- `Ctrl+b` + arrow key - Select the pane in that direction. _(Default)_
- `Ctrl+b o` - Select the next pane. _(Default)_
- `Ctrl+b ;` - Select the previously active pane. _(Default)_
- `Ctrl+b x` - Kill the current pane. _(Default)_
- `Ctrl+b z` - Toggle zoom for the current pane. _(Default)_
- `Ctrl+b !` - Move the current pane to a new window. _(Default)_
- `Ctrl+b {` or `Ctrl+b }` - Swap the current pane with the previous or next pane. _(Default)_
- `Ctrl+b Space` - Select the next pane layout. _(Default)_
- `Ctrl+b ?` - List keybindings. Press `q` to exit. _(Default)_

### Copy mode

- `Ctrl+b [` - Enter copy mode. _(Default)_
- `h`, `j`, `k`, or `l` - Move the cursor left, down, up, or right. _(Default)_
- `w`, `b`, or `e` - Move to the next word, previous word, or word end. _(Default)_
- `0`, `^`, or `$` - Move to the line start, first non-blank, or line end. _(Default)_
- `g` or `G` - Move to the top or bottom of scrollback. _(Default)_
- `Ctrl+u` or `Ctrl+d` - Scroll half a page up or down. _(Default)_
- `Ctrl+b` or `Ctrl+f` in copy mode - Scroll one page up or down. _(Default)_
- `Space` - Start a selection. _(Default)_
- `Enter` - Copy the selection and exit copy mode. _(Default)_
- `q` - Exit copy mode. _(Default)_
- `Ctrl+b ]` - Paste the most recently copied buffer. _(Default)_

### TPM plugin

- `Ctrl+b I` - Install plugins. _(Custom)_
- `Ctrl+b U` - Update plugins. _(Custom)_
- `Ctrl+b u` - Remove plugins that are not in the plugin list. _(Custom)_

## Commands

```bash
tmux                         # Start a new session
tmux new -s <name>           # Start a named session
tmux ls                      # List sessions
tmux attach -t <name>        # Attach to a session
tmux kill-session -t <name>  # Kill a session
tmux kill-server             # Kill all sessions
```

```bash
# List all tmux keybindings
tmux list-keys

# Reload the tmux configuration
tmux source-file ~/.tmux.conf

# List all tmux commands
tmux list-commands

# Show global tmux options
tmux show-options -g
```
