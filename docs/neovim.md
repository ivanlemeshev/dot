# Neovim

## Keybindings

_(Default)_ means Neovim provides the mapping. _(Custom)_ means this setup or one of its plugins adds or changes the mapping.

### Movement

- `h` - Move left. _(Default)_
- `j` - Move down. _(Default)_
- `k` - Move up. _(Default)_
- `l` - Move right. _(Default)_
- `w` - Move to the start of the next word. _(Default)_
- `W` - Move to the start of the next WORD. A WORD ends at a space. _(Default)_
- `b` - Move to the start of the previous word. _(Default)_
- `B` - Move to the start of the previous WORD. A WORD ends at a space. _(Default)_
- `e` - Move to the end of the current or next word. _(Default)_
- `E` - Move to the end of the current or next WORD. A WORD ends at a space. _(Default)_
- `0` - Move to the start of the line. _(Default)_
- `^` - Move to the first non-blank character on the line. _(Default)_
- `$` - Move to the end of the line. _(Default)_
- `gg` - Move to the start of the file. _(Default)_
- `G` - Move to the end of the file. _(Default)_
- `<C-d>` - Scroll down half a screen, then center the current line with `zz`. _(Custom)_
- `<C-u>` - Scroll up half a screen, then center the current line with `zz`. _(Custom)_
- `<C-f>` - Scroll forward one screen, then center the current line with `zz`. _(Custom)_
- `<C-b>` - Scroll backward one screen, then center the current line with `zz`. _(Custom)_
- `(` - Move to the previous sentence. _(Default)_
- `)` - Move to the next sentence. _(Default)_
- `{` - Move to the previous paragraph. _(Default)_
- `}` - Move to the next paragraph. _(Default)_

### Editing

- `i` - Insert before the cursor. _(Default)_
- `a` - Insert after the cursor. _(Default)_
- `o` - Open a new line below the cursor. _(Default)_
- `I` - Insert at the start of the line. _(Default)_
- `A` - Insert at the end of the line. _(Default)_
- `O` - Open a new line above the cursor. _(Default)_
- `x` - Delete the character under the cursor. _(Default)_
- `dd` - Delete the current line. _(Default)_
- `yy` - Copy the current line. _(Default)_
- `p` - Paste after the cursor. _(Default)_
- `P` - Paste before the cursor. _(Default)_
- `d{motion}` - Delete text covered by a motion. For example, `dw` deletes to the next word. _(Default)_
- `c{motion}` - Change text covered by a motion. _(Default)_
- `y{motion}` - Copy text covered by a motion. _(Default)_
- `di{object}` - Delete inside a text object. For example, `diw` deletes the word under the cursor. _(Default)_
- `da{object}` - Delete around a text object. For example, `daw` deletes the word and its following space. _(Default)_
- `u` - Undo the last change. _(Default)_
- `<C-r>` - Redo the last change. _(Default)_
- `.` - Repeat the last change. _(Default)_
- `<leader>sj` in Normal or Visual mode - Toggle bracketed arguments between one line and multiple lines. _(Custom)_
- `<M-h>` in Normal mode - Move the current line left. In Visual mode, move the selection left. _(Custom)_
- `<M-j>` in Normal mode - Move the current line down. In Visual mode, move the selection down. _(Custom)_
- `<M-k>` in Normal mode - Move the current line up. In Visual mode, move the selection up. _(Custom)_
- `<M-l>` in Normal mode - Move the current line right. In Visual mode, move the selection right. _(Custom)_

### Surround

- `ds{target}` in Normal mode - Remove the surrounding pair. For example, `ds"` removes the quotes. _(Custom)_
- `cs{target}{replacement}` in Normal mode - Change the surrounding pair. For example, `cs"'` changes double quotes to single quotes. _(Custom)_
- `cS{target}{replacement}` in Normal mode - Change the surrounding pair and place the text on separate lines. _(Custom)_
- `ys{motion}{replacement}` in Normal mode - Add a pair around the text selected by the motion. For example, `ysiw)` adds parentheses around the word. _(Custom)_
- `yS{motion}{replacement}` in Normal mode - Add a pair around the text selected by the motion and place it on separate indented lines. _(Custom)_
- `yss{replacement}` in Normal mode - Add a pair around the current line. _(Custom)_
- `ySS{replacement}` in Normal mode - Add a pair around the current line and place it on separate indented lines. _(Custom)_
- `S{replacement}` in Visual mode - Add a pair around the selection. Linewise selections go on separate indented lines. _(Custom)_
- `gS{replacement}` in Visual mode - Add a pair around the selection. Linewise selections go on separate lines without automatic indentation. _(Custom)_
- `<C-g>s`, `<C-g>S`, or `<C-s>` in Insert mode - Insert a pair and place the cursor inside it. `<C-s>` can be captured by terminal flow control. _(Custom)_

### Autocompletion

- `<C-n>` in insert mode - Select the next completion item. Use the existing key action if no item is available. _(Custom)_
- `<C-p>` in insert mode - Select the previous completion item. Use the existing key action if no item is available. _(Custom)_
- `<C-e>` in insert mode - Close the completion menu. _(Default)_
- `<C-y>` in insert mode - Confirm the selected completion item. _(Default)_
- `<Down>` in insert mode - Select the next completion item. _(Default)_
- `<Up>` in insert mode - Select the previous completion item. _(Default)_
- `<Tab>` in insert mode - Accept the highlighted completion. The first item is highlighted when the menu opens. Use the existing Tab action when the menu is closed. _(Custom)_
- `<Enter>` in insert mode - Accept a completion when the menu is open. Insert a newline otherwise. _(Custom)_

### CSV

- `if` in operator or visual mode - Select the current field contents. _(Custom)_
- `af` in operator or visual mode - Select the current field and its delimiter. _(Custom)_
- `<Tab>` in normal or visual mode - Move to the end of the next field. _(Custom)_
- `<S-Tab>` in normal or visual mode - Move to the end of the previous field. _(Custom)_

### Comments

- `gcc` - Toggle the comment on the current line. _(Default)_
- `gc{motion}` - Toggle comments across the motion. _(Default)_
- `gc` in visual mode - Toggle comments across the selection. _(Default)_
- `<leader>c` in normal mode - Run `gcc` to toggle the current line. _(Custom)_
- `<leader>c` in visual mode - Run `gc` to toggle the selection. _(Custom)_

### Modes

- `v` - Select characters. _(Default)_
- `V` - Select lines. _(Default)_
- `<C-v>` - Select a block. _(Default)_
- `<Esc>` - Return to normal mode. _(Default)_
- `<C-c>` - Return to normal mode. _(Default)_

### Search

- `/pattern` - Search forward for a pattern. _(Default)_
- `n` - Move to the next match. _(Default)_
- `N` - Move to the previous match. _(Default)_
- `?pattern` - Search backward for a pattern. _(Default)_
- `*` - Search forward for the word under the cursor. _(Default)_
- `#` - Search backward for the word under the cursor. _(Default)_
- `f{char}` - Find the next matching character on the current line. _(Default)_
- `F{char}` - Find the previous matching character on the current line. _(Default)_
- `t{char}` - Move to just before the next matching character on the current line. _(Default)_
- `T{char}` - Move to just after the previous matching character on the current line. _(Default)_
- `;` - Repeat the last `f`, `F`, `t`, or `T` search in the same direction. _(Default)_
- `%` - Move to the matching bracket, parenthesis, or brace. _(Default)_
- `:noh` - Clear search highlights. _(Default)_

### LSP

- `gd` - Go to the LSP definition. _(Default)_
- `gD` - Go to the LSP declaration. _(Default)_
- `grr` - Find LSP references. _(Default)_
- `gri` - Go to the LSP implementation. _(Default)_
- `grt` - Go to the LSP type definition. _(Default)_
- `gO` - Show LSP document symbols. _(Default)_
- `grn` - Rename the symbol under the cursor. _(Default)_
- `gra` - Show code actions for the cursor or selection. _(Default)_
- `K` - Show hover documentation. _(Default)_

### Commands

- `:` - Open the command line. Type a command, then press `<Enter>` to run it. _(Default)_
- `:w` - Save the current file. _(Default)_
- `:q` - Close the current window. _(Default)_
- `:wq` - Save the current file and close the window. _(Default)_
- `:q!` - Close the window without saving. _(Default)_
- `:qa` - Close all windows. _(Default)_
- `:qa!` - Close all windows without saving. _(Default)_
- `:s/old/new/g` - Replace text in the current line. _(Default)_
- `:%s/old/new/g` - Replace text in the whole file. _(Default)_
- `<leader>pu` - Update Neovim plugins. _(Custom)_

### Terminal

- `:terminal` - Open a terminal in the current window. _(Default)_
- `:split | terminal` - Open a terminal in a horizontal split. _(Default)_
- `:vsplit | terminal` - Open a terminal in a vertical split. _(Default)_
- `i`, `I`, `a`, or `A` - Enter terminal mode and send input to the process. _(Default)_
- `<C-\><C-n>` in terminal mode - Return to normal mode. _(Default)_
- `:q` in normal mode - Close the terminal window. _(Default)_

### HTTP requests

- `<leader>rs` - Send an HTTP request with Kulala. _(Custom)_

### Windows

- `<C-w>h` - Move to the left window. _(Default)_
- `<C-w>j` - Move to the lower window. _(Default)_
- `<C-w>k` - Move to the upper window. _(Default)_
- `<C-w>l` - Move to the right window. _(Default)_
- `<C-w>s` - Split the window horizontally. _(Default)_
- `<C-w>v` - Split the window vertically. _(Default)_
- `<C-w>w` - Move to the next window. _(Default)_
- `<C-w>W` - Move to the previous window. _(Default)_
- `<C-w>t` - Move to the top-left window. _(Default)_
- `<C-w>b` - Move to the bottom-right window. _(Default)_
- `<C-w>r` - Rotate windows downwards. _(Default)_
- `<C-w>R` - Rotate windows upwards. _(Default)_
- `<C-w>x` - Exchange the current window with the next window. _(Default)_
- `<C-w>q` - Close the current window. _(Default)_
- `<C-w>o` - Close all other windows. _(Default)_
- `<C-w>=` - Set windows to equal size. _(Default)_
- `<C-w>+` - Increase the current window height. _(Default)_
- `<C-w>-` - Decrease the current window height. _(Default)_
- `<C-w><` - Decrease the current window width. _(Default)_
- `<C-w>>` - Increase the current window width. _(Default)_
- `<C-w>_` - Set the current window to maximum height. _(Default)_
- `<C-w>|` - Set the current window to maximum width. _(Default)_

## FZF bindings

- `<leader>ff` - Find files by name. _(Custom)_
- `<leader>fb` - Find open buffers. _(Custom)_
- `<leader>fg` - Search text across project files. _(Custom)_
- `<leader>fd` - Find workspace diagnostics. _(Custom)_
- `<leader>fh` - Search help tags. _(Custom)_
- `<leader>fo` - Find recently opened files. _(Custom)_
- `<leader>fw` - Search for the word under the cursor. _(Custom)_
- `<leader>fc` - Search command history. _(Custom)_
- `<leader>fs` - Search search history. _(Custom)_
- `<leader>fr` - Resume the previous search. _(Custom)_
