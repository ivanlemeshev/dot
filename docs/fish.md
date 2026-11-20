# Fish Shell

## Commands

Type `ls`, then press Space or Enter to expand it to `ls -al`. The abbreviation keeps Fish's color wrapper. On macOS, the wrapper uses GNU `gls` when it is available.

## Keybindings

_(Default)_ means Fish or the terminal provides the binding. _(Custom)_ means this setup adds or changes the binding.

### History

- `Ctrl+r` - Search command history. _(Default)_
- `Ctrl+p` - Move to the previous command in history. _(Default)_
- `Ctrl+n` - Move to the next command in history. _(Default)_

### Cursor movement

- `Ctrl+a` - Move the cursor to the start of the line. _(Default)_
- `Ctrl+e` - Move the cursor to the end of the line. _(Default)_
- `Ctrl+f` - Move the cursor forward one character. _(Default)_
- `Ctrl+b` - Move the cursor backward one character. _(Default)_

### Editing

- `Ctrl+k` - Delete text from the cursor to the end of the line. _(Default)_
- `Ctrl+u` - Delete text before the cursor. _(Default)_
- `Ctrl+w` - Delete the word before the cursor. _(Default)_
- `Ctrl+d` - Delete the character under the cursor. Exit the shell if the command line is empty. _(Default)_
- `Ctrl+h` - Delete the character before the cursor. _(Default)_
- `Ctrl+z` - Undo the last change. _(Default)_
- `Ctrl+y` - Paste the last deleted text. _(Default)_
- `Ctrl+t` - Swap the last two characters before the cursor. _(Default)_

### Screen and process control

- `Ctrl+l` - Clear the screen and repaint the prompt. _(Custom)_
- `Ctrl+z` while a command runs - Suspend the foreground process. _(Default)_
- `Ctrl+c` - Stop the current process. _(Default)_

### Job control

- `fg` - Resume the last suspended process in the foreground.
- `bg` - Resume a suspended process in the background.

### External editor

- `Alt+e` - Edit the current command line in an external editor. _(Default)_
- `Alt+v` - Edit the current command line in an external editor. _(Default)_
