# Tmux

## Keybindings

_(Default)_ means tmux provides the binding. _(Custom)_ means this setup or a plugin adds or changes the binding. Copy mode uses Emacs keys by default. It uses vi keys when `VISUAL` or `EDITOR` contains `vi`.

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
- `Up`, `Down`, `Left`, or `Right` - Move the cursor. _(Default)_
- `PageUp` or `PageDown` - Scroll one page. _(Default)_
- `Alt+Up` or `Alt+Down` - Scroll half a page. _(Default)_
- `Ctrl+Space` - Start a selection. _(Default)_
- `Alt+w` - Copy the selection and exit copy mode. _(Default)_
- `Esc` - Exit copy mode. _(Default)_
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
