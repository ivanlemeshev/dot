# Keyboard Shortcuts and Commands

## Fish

- `Ctrl+p`
    - Move to the previous command in the history.

- `Ctrl+n`
    - Move to the next command in the history.

- `Ctrl+r`
    - Search the command history.

- `Ctrl+a`
    - Move the cursor to the beginning of the line.

- `Ctrl+e`
    - Move the cursor to the end of the line.

- `Ctrl+f`
    - Move the cursor forward one character.

- `Ctrl+b`
    - Move the cursor backward one character.

- `Ctrl+k`
    - Delete the text from the cursor to the end of the line.

- `Ctrl+u`
    - Delete the text before the cursor.

- `Ctrl+w`
    - Delete the word before the cursor.

- `Ctrl+d`
    - Delete the character under the cursor.

- `Ctrl+h`
    - Delete the character before the cursor.

- `Ctrl+z`
    - Undo the last change.

- `Ctrl+y`
    - Paste the last deleted text.

- `Ctrl+t`
    - Swap the last two characters before the cursor.

- `Ctrl+l`
    - Clear the screen.

- `Ctrl+z` (in a running process)
    - Suspend the current process and send it to the background.

- `Ctrl+c`
    - Kill the current running process.

- `Alt+e`
    - Edit the current command line in an external editor.

- `Alt+v`
    - Edit the current command line in an external editor.

- `fg` (command)
    - Bring the most recently suspended process back to the foreground.

- `bg` (command)
    - Resume a suspended process in the background.

- `Ctrl+Alt+f`
    - Search a file in the current directory.

- `Ctrl+Alt+l` (fzf.fish)
    - Search a commit in git log.

- `Ctrl+Alt+s` (fzf.fish)
    - Search a file in git status.

- `Ctrl+r` (fzf.fish)
    - Search the command history.

- `Ctrl+Alt+p` (fzf.fish)
    - Search a process.

- `Ctrl+v` (fzf.fish)
    - Search an environment variable.

- `Ctrl+p` (fzf.fish)
    - Move to the previous entry.

- `Ctrl+n` (fzf.fish)
    - Move to the next entry.

- `Tab` (fzf.fish)
    - Select multiple entries.

## Tmux

- `Ctrl+Space`
    - The custom prefix key.

- `<prefix>c`
    - Create a new window.

- `<prefix>n`
    - Move to the next window.

- `<prefix>p`
    - Move to the previous window.

- `<prefix>%`
    - Split the window vertically.

- `<prefix>"`
    - Split the window horizontally.

- `<prefix>i`
    - Paste the text from the clipboard.

- `Ctrl+Shift+v`
    - Paste the text from the clipboard (Windows).

- `<prefix>y`
    - Copy the selected text to the clipboard.

- `<prefix>d`
    - Detach the current session.

- `<prefix>z`
    - Zoom in/out the current pane.

- `<prefix>,`
    - Rename the current window.

- `<prefix>&`
    - Kill the current window.

- `<prefix>x`
    - Kill the current pane.

- `<prefix>[`
    - Enter copy mode.

- `h` (in copy mode)
    - Move the cursor left.

- `j` (in copy mode)
    - Move the cursor down.

- `k` (in copy mode)
    - Move the cursor up.

- `l` (in copy mode)
    - Move the cursor right.

- `Space` (in copy mode)
    - Start selecting text.

- `Enter` (in copy mode)
    - Copy the selected text.

- `<prefix>]`
    - Paste the copied text.

- `<prefix>I` (tmux-plugins/tpm)
    - Install plugins.

- `<prefix>U` (tmux-plugins/tpm)
    - Update plugins.

- `<prefix>u` (tmux-plugins/tpm)
    - Remove plugins.

- `Ctrl+h` (christoomey/vim-tmux-navigator)
    - Move the cursor to the left pane.

- `Ctrl+j` (christoomey/vim-tmux-navigator)
    - Move the cursor to the bottom pane.

- `Ctrl+k` (christoomey/vim-tmux-navigator)
    - Move the cursor to the top pane.

- `Ctrl+l` (christoomey/vim-tmux-navigator)
    - Move the cursor to the right pane.

- `Ctrl+\` (christoomey/vim-tmux-navigator)
    - Move the cursor to the last active pane.

## Neovim

### Commands

- `w`
    - Save the file.

- `q`
    - Quit the file.

- `wq`
    - Save and quit the file.

- `q!`
    - Quit the file without saving.

- `qa`
    - Quit all open files.

- `qa!`
    - Quit all open files without saving.

- `sp`
    - Split the window horizontally.

- `vsp`
    - Split the window vertically.

### Key Bindings

#### Panes

- `Ctrl+h` (normal mode)
    - Move the cursor to the left pane.

- `Ctrl+j` (normal mode)
    - Move the cursor to the bottom pane.

- `Ctrl+k` (normal mode)
    - Move the cursor to the top pane.

- `Ctrl+l` (normal mode)
    - Move the cursor to the right pane.

- `Ctrl+w s` (normal mode)
    - Split the window horizontally.

- `Ctrl+w v` (normal mode)
    - Split the window vertically.

- `Ctrl+w =` (normal mode)
    - Balance the panes.

- `Ctrl+w -` (normal mode)
    - Decrease the height of the current pane.

- `Ctrl+w +` (normal mode)
    - Increase the height of the current pane.

- `Ctrl+w <` (normal mode)
    - Decrease the width of the current pane.

- `Ctrl+w >` (normal mode)
    - Increase the width of the current pane.

- `Ctrl+w _` (normal mode)
    - Maximize the height of the current pane.

- `Ctrl+w |` (normal mode)
    - Maximize the width of the current pane.

- `Ctrl+w o` (normal mode)
    - Close all panes except the current pane.

#### Navigation

- `h` (in normal mode)
    - Move the cursor left.

- `j` (in normal mode)
    - Move the cursor down.

- `k` (in normal mode)
    - Move the cursor up.

- `l` (in normal mode)
    - Move the cursor right.

- `w` (in normal mode)
    - Move the cursor to the beginning of the next word.

- `b` (in normal mode)
    - Move the cursor to the beginning of the previous word.

- `e` (in normal mode)
    - Move the cursor to the end of the next word.

- `0` (in normal mode)
    - Move the cursor to the beginning of the line.

- `$` (in normal mode)
    - Move the cursor to the end of the line.

- `gg` (in normal mode)
    - Move the cursor to the beginning of the file.

- `G` (in normal mode)
    - Move the cursor to the end of the file.

- `f<character>` (in normal mode)
    - Move the cursor tjo the next occurrence of a character.

- `F<character>` (in normal mode)
    - Move the cursor to the previous occurrence of a character.

- `(` (in normal mode)
    - Move the cursor to the beginning of the previous sentence.

- `)` (in normal mode)
    - Move the cursor to the beginning of the next sentence.

- `{` (in normal mode)
    - Move the cursor to the beginning of the previous paragraph.

- `}` (in normal mode)
    - Move the cursor to the beginning of the next paragraph.

- `Ctrl+d` (in normal mode)
    - Move the cursor half a page down.

- `Ctrl+u` (in normal mode)
    - Move the cursor half a page up.

- `Ctrl+f` (in normal mode)
    - Move the cursor a page down.

- `Ctrl+b` (in normal mode)
    - Move the cursor a page up.

- `/` (in normal mode)
    - Search for a pattern.

- `n` (in normal mode)
    - Move to the next occurrence of the pattern.

- `N` (in normal mode)
    - Move to the previous occurrence of the pattern.

- `*` (in normal mode)
    - Search for the word under the cursor.

- `#` (in normal mode)
    - Search for the previous occurrence of the word under the cursor.

- `%` (in normal mode)
    - Move to the matching parenthesis, bracket, or brace.

- `^` (in normal mode)
    - Switch to the previous buffer.

- `Tab` (in normal mode)
    - Switch to the next buffer.

- `Shift+Tab` (in normal mode)
    - Switch to the previous buffer.

#### Editing

Note: when you delete text in normal mode or visual mode, the text is copied to
the clipboard and you can paste it.

- `i` (in normal mode)
    - Enter insert mode before the cursor.

- `a` (in normal mode)
    - Enter insert mode after the cursor.

- `A` (in normal mode)
    - Enter insert mode at the end of the line.

- `I` (in normal mode)
    - Enter insert mode at the beginning of the line.

- `o` (in normal mode)
    - Enter insert mode below the current line.

- `O` (in normal mode)
    - Enter insert mode above the current line.

- `s` (in normal mode)
    - Delete the character under the cursor and enter insert mode.

- `S` (in normal mode)
    - Delete the current line and enter insert mode.

- `C` (in normal mode)
    - Delete the text from the cursor to the end of the line and enter insert
      mode.

- `ciw` (in normal mode)
    - Delete a word and enter insert mode.

- `cis` (in normal mode)
    - Delete a sentence and enter insert mode.

- `cip` (in normal mode)
    - Delete a paragraph and enter insert mode.

- `cib` (in normal mode)
    - Delete the text inside a block with braces () and enter insert mode.

- `ciB` (in normal mode)
    - Delete the text inside a block with brackets {} and enter insert mode.

- `ci<character>` (in normal mode)
    - Delete the text inside a block with characters including: ', ", `, (, [,
      {, and <, and enter insert mode.

- `cab` (in normal mode)
    - Delete all inside a block with braces () and enter insert mode.

- `caB` (in normal mode)
    - Delete all inside a block with brackets {} and enter insert mode.

- `ca<character>` (in normal mode)
    - Delete all inside a block with characters including: ', ", `, (, [, {,
      and <, and enter insert mode.

- `Ctrl+c` (in insert mode)
    - Exit insert mode.

- `Esc` (in insert mode)
    - Exit insert mode.

- `x` (in normal mode)
    - Delete the character under the cursor.

- `dd` (in normal mode)
    - Delete the current line.

- `2dd` (in normal mode)
    - Delete the next two lines.

- `d$` (in normal mode)
    - Delete the text from the cursor to the end of the line.

- `d0` (in normal mode)
    - Delete the text from the cursor to the beginning of the line.

- `dw` (in normal mode)
    - Delete a word.

- `diw` (in normal mode)
    - Delete a word.

- `dis` (in normal mode)
    - Delete a sentence.

- `dip` (in normal mode)
    - Delete a paragraph.

- `da<character>` (in normal mode)
    - Delete the text inside a block with characters including: ', ", `, (, [,
      {, and <.

- `di<character>` (in normal mode)
    - Delete the text inside a block with characters: ', ", `, (, [, {, and <.

- `dt<character>` (in normal mode)
    - Delete the text until a character.

- `yy` (in normal mode)
    - Copy the current line.

- `2yy` (in normal mode)
    - Copy the next two lines.

- `y$` (in normal mode)
    - Copy the text from the cursor to the end of the line.

- `y0` (in normal mode)
    - Copy the text from the cursor to the beginning of the line.

- `yaw` (in normal mode)
    - Copy a word.

- `ya<character>` (in normal mode)
    - Copy the text inside a block with characters including: ', ", `, (, [, {,
      and <.

- `yi<character>` (in normal mode)
    - Copy the text inside a block with characters: ', ", `, (, [, {, and <.

- `p` (in normal mode)
    - Paste the copied text after the cursor.

- `P` (in normal mode)
    - Paste the copied text before the cursor.

- `u` (in normal mode)
    - Undo the last change.

- `Ctrl+r` (in normal mode)
    - Redo the last change.

- `.` (in normal mode)
    - Repeat the last change.

- `:s/foo/bar/g` (in normal mode)
    - Replace all occurrences of `foo` with `bar` in the current line.

- `:s/foo/bar/gc` (in normal mode)
    - Replace all occurrences of `foo` with `bar` in the current line with
      confirmation.

- `:%s/foo/bar/g` (in normal mode)
    - Replace all occurrences of `foo` with `bar` in the entire file.

- `:%s/foo/bar/gc` (in normal mode)
    - Replace all occurrences of `foo` with `bar` in the entire file with
      confirmation.

- `:g/foo/d` (in normal mode)
    - Delete all occurrences of `foo`.

- `:g/foo/dc` (in normal mode)
    - Delete all occurrences of `foo` with confirmation.

- `:v/foo/d` (in normal mode)
    - Delete all lines that do not contain `foo`.

- `:v/foo/dc` (in normal mode)
    - Delete all lines that do not contain `foo` with confirmation.

- `~` (in normal mode)
    - Change the case of the character under the cursor.

- `gUw` (in normal mode)
    - Change the case of a word to uppercase.

- `guw` (in normal mode)
    - Change the case of a word to lowercase.

- `gUU` (in normal mode)
    - Change the case of the current line to uppercase.

- `guu` (in normal mode)
    - Change the case of the current line to lowercase.

#### Visual Mode

- `v` (in normal mode)
    - Enter visual mode.

- `V` (in normal mode)
    - Enter visual line mode.

- `Ctrl+v` (in normal mode)
    - Enter visual block mode.

- `y` (in visual mode)
    - Copy the selected text.

- `d` (in visual mode)
    - Delete the selected text.

- `c` (in visual mode)
    - Change the selected text.

- `o` (in visual mode)
    - Move the cursor to the other end of the selection.

- `aw` (in visual mode)
    - Select a word.

- `as` (in visual mode)
    - Select a sentence.

- `ap` (in visual mode)
    - Select a paragraph.

- `ab` (in visual mode)
    - Select a block with braces ().

- `aB` (in visual mode)
    - Select a block with brackets {}.

- `a<character>` (in visual mode)
    - Select a block with characters: ', ", `, (, [, {, and <.

- `ib` (in visual mode)
    - Select all inside a block with braces ().

- `iB` (in visual mode)
    - Select all inside a block with brackets {}.

- `i<character>` (in visual mode)
    - Select all inside a block with characters: ', ", `, (, [, {, and <.

- `~` (in visual mode)
    - Change the case of the selected text.

- `>` (in visual mode)
    - Indent the selected text.

- `<` (in visual mode)
    - Unindent the selected text.

- `=` (in visual mode)
    - Auto-indent the selected text.

- `J` (in visual mode)
    - Join the selected lines.

- `:s/foo/bar/g` (in visual mode)
    - Replace all occurrences of `foo` with `bar` in the selected text.

#### NvChad

Note: the leader key is `Space`.

- `<leader>e` (in normal mode)
    - Open nvim-tree (file explorer).

- `g?` (nvim-tree)
    - Show the key bindings.

- `q` (nvim-tree)
    - Close nvim-tree.

- `a` (nvim-tree)
    - Add a new file or directory.

- `r` (nvim-tree)
    - Rename a file or directory.

- `d` (nvim-tree)
    - Delete a file or directory.

- `y` (nvim-tree)
    - Copy a file or directory.

- `x` (nvim-tree)
    - Cut a file or directory.

- `p` (nvim-tree)
    - Paste a file or directory.

- `H` (nvim-tree)
    - Show/hide hidden files.

- `R` (nvim-tree)
    - Refresh the tree.

- `<leader>ff` (in normal mode)
    - Find a file in the current project.

- `<leader>fb` (in normal mode)
    - Find a file in  open buffers.

- `<leader>fw` (in normal mode)
    - Find in files in the current project.

- `<leader>x` (in normal mode)
    - Close the current buffer.

- `<leader>h` (in normal mode)
    - Open a terminal in a horizontal split.

- `<leader>v` (in normal mode)
    - Open a terminal in a vertical split.

- `Ctrl+x` (in terminal)
    - Exit the terminal mode.

- `i` (in normal mode)
    - Back to normal mode.

- `Ctrl+x <leader>x` (in terminal)
    - Close the terminal.


# 60% Keyboard

- `Alt+Fn+4`
    - Close the current window (Alt+F4).
