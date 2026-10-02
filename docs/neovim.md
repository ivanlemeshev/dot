# Neovim

## Default keys

### Movement

- `h`, `j`, `k`, `l` - Move left, down, up, and right.
- `w`, `W`, `b`, `B`, `e`, `E` - Move by words or WORDS. Uppercase motions treat spaces as separators.
- `0`, `^`, `$` - Move to the start, first non-blank, and end of the line.
- `gg`, `G` - Move to the start and end of the file.
- `<C-d>`, `<C-u>` - Move down and up by half a screen.
- `<C-f>`, `<C-b>` - Move down and up by a full screen.
- `(`, `)` - Move to the previous and next sentence.
- `{`, `}` - Move to the previous and next paragraph.

### Editing

- `i`, `a`, `o` - Insert before the cursor, after the cursor, and on a new line below.
- `I`, `A`, `O` - Insert at the start of the line, at the end of the line, and on a new line above.
- `x`, `dd`, `yy`, `p`, `P` - Delete a character, delete a line, copy a line, paste after the cursor, and paste before the cursor.
- `d{motion}`, `c{motion}`, `y{motion}` - Delete, change, or copy text covered by a motion. For example, `dw` deletes to the next word.
- `di{object}`, `da{object}` - Delete inside or around a text object. For example, `diw` deletes the word under the cursor.
- `u`, `<C-r>` - Undo and redo.
- `.` - Repeat the last change.

### Modes

- `v`, `V`, `<C-v>` - Select characters, lines, or a block.
- `<Esc>`, `<C-c>` - Return to normal mode.

### Search

- `/pattern`, `n`, `N` - Search forward, then move to the next and previous match.
- `?pattern` - Search backward.
- `*`, `#` - Search forward and backward for the word under the cursor.
- `f{char}`, `F{char}` - Find the next or previous matching character on the current line.
- `%` - Move to the matching bracket, parenthesis, or brace.
- `:noh` - Clear search highlights.

### Commands

- `:w` - Save the current file.
- `:q` - Close the current window.
- `:wq` - Save the current file and close the window.
- `:q!` - Close the window without saving.
- `:qa` - Close all windows.
- `:qa!` - Close all windows without saving.
- `:s/old/new/g` - Replace text in the current line.
- `:%s/old/new/g` - Replace text in the whole file.

### Windows

- `<C-w>h`, `<C-w>j`, `<C-w>k`, `<C-w>l` - Move to the left, lower, upper, and right window.
- `<C-w>s`, `<C-w>v` - Split the window horizontally and vertically.
- `<C-w>w`, `<C-w>W` - Move to the next and previous window.
- `<C-w>t`, `<C-w>b` - Move to the top-left and bottom-right window.
- `<C-w>r`, `<C-w>R` - Rotate windows downwards and upwards.
- `<C-w>x` - Exchange the current window with the next window.
- `<C-w>q`, `<C-w>o` - Close the current window and close all other windows.
- `<C-w>=` - Set windows to equal size.
- `<C-w>+`, `<C-w>-` - Increase and decrease the current window height.
- `<C-w><`, `<C-w>>` - Decrease and increase the current window width.
- `<C-w>_`, `<C-w>|` - Set the current window to maximum height and width.

## General

- `;` - Enter command mode as a shortcut for `:`.

## FZF bindings

- `<leader>ff` - Find files by name.
- `<leader>fb` - Find open buffers.
- `<leader>fg` - Search text across project files.
- `<leader>fd` - Find workspace diagnostics.
- `<leader>fh` - Search help tags.
- `<leader>fo` - Find recently opened files.
- `<leader>fw` - Search for the word under the cursor.
- `<leader>fc` - Search command history.
- `<leader>fs` - Search search history.
- `<leader>fr` - Resume the previous search.
