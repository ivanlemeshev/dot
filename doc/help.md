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

- `Ctrl+y`
    - Paste the last deleted text.

- `Ctrl+t`
    - Swap the last two characters before the cursor.

- `Ctrl+l`
    - Clear the screen.

- `Ctrl+z`
    - Suspend the current process and send it to the background.

- `Ctrl+c`
    - Kill the current running process.

- `Alt+e`
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

- `Ctrl+a`
    - The custom prefix key.

- `Ctrl+a c`
    - Create a new window.

- `Ctrl+a n`
    - Move to the next window.

- `Ctrl+a p`
    - Move to the previous window.

- `Ctrl+a %`
    - Split the window vertically.

- `Ctrl+a "`
    - Split the window horizontally.

- `Ctrl+a i`
    - Paste the text from the clipboard.

- `Ctrl+Shift+v`
    - Paste the text from the clipboard (Windows).

- `Ctrl+a y`
    - Copy the selected text to the clipboard.

- `Ctrl+a d`
    - Detach the current session.

- `Ctrl+a z`
    - Zoom in and out the current pane.

- `Ctrl+a ,`
    - Rename the current window.

- `Ctrl+a &`
    - Kill the current window.

- `Ctrl+a x`
    - Kill the current pane.

- `Ctrl+a [`
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

- `Ctrl+a ]`
    - Paste the copied text.

- `Ctrl+a Shift+i` (tmux-plugins/tpm)
    - Install plugins.

- `Ctrl+a Shift+u` (tmux-plugins/tpm)
    - Update plugins.

- `Ctrl+a u` (tmux-plugins/tpm)
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

- `i` (in normal mode)
    - Enter insert mode.

- `Esc` (in insert mode)
    - Exit insert mode.

- `:w` (in normal mode)
    - Save the file.

- `:q` (in normal mode)
    - Quit the file.

- `:wq` (in normal mode)
    - Save and quit the file.

- `:q!` (in normal mode)
    - Quit the file without saving.

- `qa` (in normal mode)
    - Quit all open files.

- `:qa!` (in normal mode)
    - Quit all open files without saving.

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

- `x` (in normal mode)
    - Delete the character under the cursor.

- `dd` (in normal mode)
    - Delete the current line.

- `yy` (in normal mode)
    - Copy the current line.

- `2yy` (in normal mode)
    - Copy the next two lines.

- `y$` (in normal mode)
    - Copy the text from the cursor to the end of the line.

- `y0` (in normal mode)
    - Copy the text from the cursor to the beginning of the line.

- `yw` (in normal mode)
    - Copy the next word.

- `p` (in normal mode)
    - Paste the copied text after the cursor.

- `P` (in normal mode)
    - Paste the copied text before the cursor.

- `u` (in normal mode)
    - Undo the last change.

- `o` (in normal mode)
    - Add a new line below the current line.

- `Ctrl+r` (in normal mode)
    - Redo the last change.

- `:s/foo/bar/g` (in normal mode)
    - Replace all occurrences of `foo` with `bar`.

- `v` (in normal mode)
    - Enter visual mode.

- `V` (in normal mode)
    - Enter visual line mode.

- `Ctrl+v` (in normal mode)
    - Enter visual block mode.

- `y` (in visual mode)
    - Copy the selected text.

- `d` (in visual mode)
    - Delete the selected text (The text is copied, you can paste it).

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

- `a*` (in visual mode)
    - Select *: ', ", `, (, [, {, and <.

- `ib` (in visual mode)
    - Select all inside a block with braces ().

- `iB` (in visual mode)
    - Select all inside a block with brackets {}.

- `i*` (in visual mode)
    - Select all inside *: ', ", `, (, [, {, and <.

- `~` (in visual mode)
    - Change the case of the selected text.

- `>` (in visual mode)
    - Indent the selected text.

- `<` (in visual mode)
    - Unindent the selected text.

- `Ctrl+6` (in normal mode)
    - Switch to the previous buffer.

- `leader e` (in normal mode)
    - Open/close the file explorer.

- `Shift h` (in normal mode)
    - Switch to the previous tab.

- `Shift l` (in normal mode)
    - Switch to the next tab.

- `a` (nvim-tree) Add a new file or directory.

- `m` (nvim-tree)
    - Move a file or directory.

- `r` (nvim-tree)
    - Rename a file or directory.

- `d` (nvim-tree)
    - Delete a file or directory.

- `x` (nvim-tree)
    - Cut a file or directory.

- `y` (nvim-tree)
    - Copy a file or directory.

- `p` (nvim-tree)
    - Paste a file or directory.

- `H` (nvim-tree)
    - Show/hide hidden files.

- `R` (nvim-tree)
    - Refresh the tree.

- `Ctrl+h` (christoomey/vim-tmux-navigator)
    - Move the cursor to the left pane.

- `Ctrl+j` (christoomey/vim-tmux-navigator)
    - Move the cursor to the bottom pane.

- `Ctrl+k` (christoomey/vim-tmux-navigator)
    - Move the cursor to the top pane.

- `Ctrl+l` (christoomey/vim-tmux-navigator)
    - Move the cursor to the right pane.

- `Space ff` (telescope)
    - Find a file.

- `Space fg` (telescope)
    - Find some text in the files.

- `Space fb` (telescope)
    - Find a file in open buffers.

- `Ctrl+p` (telescope)
    - Move to the previous entry.

- `Ctrl+n` (telescope)
    - Move to the next entry.

- `Shift k` (lsp)
    - Show the documentation of the symbol under the cursor.

- `gd` (lsp)
    - Go to the definition of the symbol under the cursor.

## Vim

- `i` (in normal mode)
    - Enter insert mode.

- `Esc` (in insert mode)
    - Exit insert mode.

- `:w` (in normal mode)
    - Save the file.

- `:q` (in normal mode)
    - Quit the file.

- `:wq` (in normal mode)
    - Save and quit the file.

- `:q!` (in normal mode)
    - Quit the file without saving.

- `qa` (in normal mode)
    - Quit all open files.

- `:qa!` (in normal mode)
    - Quit all open files without saving.

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

- `x` (in normal mode)
    - Delete the character under the cursor.

- `dd` (in normal mode)
    - Delete the current line.

- `yy` (in normal mode)
    - Copy the current line.

- `2yy` (in normal mode)
    - Copy the next two lines.

- `y$` (in normal mode)
    - Copy the text from the cursor to the end of the line.

- `y0` (in normal mode)
    - Copy the text from the cursor to the beginning of the line.

- `yw` (in normal mode)
    - Copy the next word.

- `p` (in normal mode)
    - Paste the copied text after the cursor.

- `P` (in normal mode)
    - Paste the copied text before the cursor.

- `u` (in normal mode)
    - Undo the last change.

- `o` (in normal mode)
    - Add a new line below the current line.

- `Ctrl+r` (in normal mode)
    - Redo the last change.

- `:s/foo/bar/g` (in normal mode)
    - Replace all occurrences of `foo` with `bar`.

- `v` (in normal mode)
    - Enter visual mode.

- `V` (in normal mode)
    - Enter visual line mode.

- `Ctrl+v` (in normal mode)
    - Enter visual block mode.

- `y` (in visual mode)
    - Copy the selected text.

- `d` (in visual mode)
    - Delete the selected text (the text is copied, you can paste it).

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

- `a*` (in visual mode)
    - Select *: ', ", `, (, [, {, and <.

- `ib` (in visual mode)
    - Select all inside a block with braces ().

- `iB` (in visual mode)
    - Select all inside a block with brackets {}.

- `i*` (in visual mode)
    - Select all inside *: ', ", `, (, [, {, and <.

- `~` (in visual mode)
    - Change the case of the selected text.

- `>` (in visual mode)
    - Indent the selected text.

- `<` (in visual mode)
    - Unindent the selected text.

- `%` (netrw)
    - Add a new file.

- `d` (netrw)
    - Add a new directory.

- `R` (netrw)
    - Rename a file or directory.

- `D` (netrw)
    - Delete a file or directory.

# 60% Keyboard

- `Alt+Fn+4`
    - Close the current window (Alt+F4).
