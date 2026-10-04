# Neovim

## Keybindings

*(Default)* means a Neovim or plugin default. *(Custom)* means this setup adds or changes the mapping.

### Movement

- `h` - Move left. *(Default)*
- `j` - Move down. *(Default)*
- `k` - Move up. *(Default)*
- `l` - Move right. *(Default)*
- `w` - Move to the start of the next word. *(Default)*
- `W` - Move to the start of the next WORD. A WORD ends at a space. *(Default)*
- `b` - Move to the start of the previous word. *(Default)*
- `B` - Move to the start of the previous WORD. A WORD ends at a space. *(Default)*
- `e` - Move to the end of the current or next word. *(Default)*
- `E` - Move to the end of the current or next WORD. A WORD ends at a space. *(Default)*
- `0` - Move to the start of the line. *(Default)*
- `^` - Move to the first non-blank character on the line. *(Default)*
- `$` - Move to the end of the line. *(Default)*
- `gg` - Move to the start of the file. *(Default)*
- `G` - Move to the end of the file. *(Default)*
- `<C-d>` - Scroll down half a screen. *(Default)*
- `<C-u>` - Scroll up half a screen. *(Default)*
- `<C-f>` - Scroll forward one screen. *(Default)*
- `<C-b>` - Scroll backward one screen. *(Default)*
- `(` - Move to the previous sentence. *(Default)*
- `)` - Move to the next sentence. *(Default)*
- `{` - Move to the previous paragraph. *(Default)*
- `}` - Move to the next paragraph. *(Default)*

### Editing

- `i` - Insert before the cursor. *(Default)*
- `a` - Insert after the cursor. *(Default)*
- `o` - Open a new line below the cursor. *(Default)*
- `I` - Insert at the start of the line. *(Default)*
- `A` - Insert at the end of the line. *(Default)*
- `O` - Open a new line above the cursor. *(Default)*
- `x` - Delete the character under the cursor. *(Default)*
- `dd` - Delete the current line. *(Default)*
- `yy` - Copy the current line. *(Default)*
- `p` - Paste after the cursor. *(Default)*
- `P` - Paste before the cursor. *(Default)*
- `d{motion}` - Delete text covered by a motion. For example, `dw` deletes to the next word. *(Default)*
- `c{motion}` - Change text covered by a motion. *(Default)*
- `y{motion}` - Copy text covered by a motion. *(Default)*
- `di{object}` - Delete inside a text object. For example, `diw` deletes the word under the cursor. *(Default)*
- `da{object}` - Delete around a text object. For example, `daw` deletes the word and its following space. *(Default)*
- `u` - Undo the last change. *(Default)*
- `<C-r>` - Redo the last change. *(Default)*
- `.` - Repeat the last change. *(Default)*

### Comments

- `gcc` - Toggle the comment on the current line. *(Default)*
- `gc{motion}` - Toggle comments across the motion. *(Default)*
- `gc` in visual mode - Toggle comments across the selection. *(Default)*
- `<leader>c` in normal mode - Run `gcc` to toggle the current line. *(Custom)*
- `<leader>c` in visual mode - Run `gc` to toggle the selection. *(Custom)*

### Modes

- `v` - Select characters. *(Default)*
- `V` - Select lines. *(Default)*
- `<C-v>` - Select a block. *(Default)*
- `<Esc>` - Return to normal mode. *(Default)*
- `<C-c>` - Return to normal mode. *(Default)*

### Search

- `/pattern` - Search forward for a pattern. *(Default)*
- `n` - Move to the next match. *(Default)*
- `N` - Move to the previous match. *(Default)*
- `?pattern` - Search backward for a pattern. *(Default)*
- `*` - Search forward for the word under the cursor. *(Default)*
- `#` - Search backward for the word under the cursor. *(Default)*
- `f{char}` - Find the next matching character on the current line. *(Default)*
- `F{char}` - Find the previous matching character on the current line. *(Default)*
- `%` - Move to the matching bracket, parenthesis, or brace. *(Default)*
- `:noh` - Clear search highlights. *(Default)*

### Commands

- `:w` - Save the current file. *(Default)*
- `:q` - Close the current window. *(Default)*
- `:wq` - Save the current file and close the window. *(Default)*
- `:q!` - Close the window without saving. *(Default)*
- `:qa` - Close all windows. *(Default)*
- `:qa!` - Close all windows without saving. *(Default)*
- `:s/old/new/g` - Replace text in the current line. *(Default)*
- `:%s/old/new/g` - Replace text in the whole file. *(Default)*

### Windows

- `<C-w>h` - Move to the left window. *(Default)*
- `<C-w>j` - Move to the lower window. *(Default)*
- `<C-w>k` - Move to the upper window. *(Default)*
- `<C-w>l` - Move to the right window. *(Default)*
- `<C-w>s` - Split the window horizontally. *(Default)*
- `<C-w>v` - Split the window vertically. *(Default)*
- `<C-w>w` - Move to the next window. *(Default)*
- `<C-w>W` - Move to the previous window. *(Default)*
- `<C-w>t` - Move to the top-left window. *(Default)*
- `<C-w>b` - Move to the bottom-right window. *(Default)*
- `<C-w>r` - Rotate windows downwards. *(Default)*
- `<C-w>R` - Rotate windows upwards. *(Default)*
- `<C-w>x` - Exchange the current window with the next window. *(Default)*
- `<C-w>q` - Close the current window. *(Default)*
- `<C-w>o` - Close all other windows. *(Default)*
- `<C-w>=` - Set windows to equal size. *(Default)*
- `<C-w>+` - Increase the current window height. *(Default)*
- `<C-w>-` - Decrease the current window height. *(Default)*
- `<C-w><` - Decrease the current window width. *(Default)*
- `<C-w>>` - Increase the current window width. *(Default)*
- `<C-w>_` - Set the current window to maximum height. *(Default)*
- `<C-w>|` - Set the current window to maximum width. *(Default)*

## General

- `;` - Enter command mode as a shortcut for `:`. *(Custom)*

## FZF bindings

- `<leader>ff` - Find files by name. *(Custom)*
- `<leader>fb` - Find open buffers. *(Custom)*
- `<leader>fg` - Search text across project files. *(Custom)*
- `<leader>fd` - Find workspace diagnostics. *(Custom)*
- `<leader>fh` - Search help tags. *(Custom)*
- `<leader>fo` - Find recently opened files. *(Custom)*
- `<leader>fw` - Search for the word under the cursor. *(Custom)*
- `<leader>fc` - Search command history. *(Custom)*
- `<leader>fs` - Search search history. *(Custom)*
- `<leader>fr` - Resume the previous search. *(Custom)*
