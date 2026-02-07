# Neovim

**Leader key**: `Space`

## Basic Commands

- `:w` - Save file
- `:q` - Quit file
- `:wq` - Save and quit
- `:q!` - Quit without saving
- `:qa` - Quit all open files
- `:qa!` - Quit all without saving
- `:sp` - Split window horizontally
- `:vsp` - Split window vertically

## Modes

- `i` - Enter insert mode before cursor
- `a` - Enter insert mode after cursor
- `v` - Enter visual mode
- `V` - Enter visual line mode
- `Ctrl+v` - Enter visual block mode
- `Esc` or `Ctrl+c` - Exit to normal mode

## Navigation

### Basic Movement

- `h` - Move left
- `j` - Move down
- `k` - Move up
- `l` - Move right

### Word Movement

- `w` - Forward by word
- `W` - Forward by word (after space)
- `b` - Backward to beginning of word
- `B` - Backward to beginning of word (before space)
- `e` - Forward to end of word
- `E` - Forward to end of word (before space)

### Line Movement

- `0` - Beginning of line
- `$` - End of line
- `^` - First non-blank character of line

### File Movement

- `gg` - Beginning of file
- `G` - End of file
- `Ctrl+d` - Half page down
- `Ctrl+u` - Half page up
- `Ctrl+f` - Full page down
- `Ctrl+b` - Full page up

### Paragraph/Sentence Movement

- `(` - Beginning of previous sentence
- `)` - Beginning of next sentence
- `{` - Back one paragraph
- `}` - Forward one paragraph

### Search & Find

- `/pattern` - Search forward for pattern
- `?pattern` - Search backward for pattern
- `n` - Next occurrence
- `N` - Previous occurrence
- `*` - Search for word under cursor
- `#` - Search backward for word under cursor
- `f<char>` - Find next character
- `C<char>` - Find previous character
- `%` - Jump to matching parenthesis/bracket/brace character
- `:noh` - Clear search highlights

## Editing

### Insert Mode Variations

- `i` - Insert before cursor
- `a` - Insert after cursor
- `I` - Insert at beginning of line
- `A` - Insert at end of line
- `o` - Insert new line below
- `O` - Insert new line above
- `s` - Delete character and insert
- `S` - Delete line and insert

### Delete (Cut)

Note: Deleted text is copied to clipboard and can be pasted.

- `x` - Delete character under cursor
- `dd` - Delete current line
- `2dd` - Delete next 2 lines
- `d$` or `D` - Delete to end of line
- `d0` - Delete to beginning of line
- `dw` - Delete word from cursor
- `db` - Delete word before cursor
- `diw` - Delete inner word
- `dis` - Delete inner sentence
- `dip` - Delete inner paragraph
- `di<char>` - Delete inside: `'`, `"`, `` ` ``, `(`, `[`, `{`, `<`
- `da<char>` - Delete around (including delimiters)
- `dt<char>` - Delete until character

### Change (Delete and Insert)

- `cc` or `S` - Change entire line
- `C` - Change to end of line
- `cw` - Change word from cursor
- `cb` - Change word before cursor
- `ciw` - Change inner word
- `cis` - Change inner sentence
- `cip` - Change inner paragraph
- `cib` or `ci(` - Change inside parentheses
- `ciB` or `ci{` - Change inside braces
- `ci<char>` - Change inside delimiter
- `ca<char>` - Change around (including delimiter)

### Copy (Yank)

- `yy` - Copy current line
- `2yy` - Copy next 2 lines
- `y$` - Copy to end of line
- `y0` - Copy to beginning of line
- `yaw` - Copy word
- `yi<char>` - Copy inside delimiter
- `ya<char>` - Copy around delimiter

### Paste

- `p` - Paste after cursor
- `P` - Paste before cursor

### Undo/Redo

- `u` - Undo
- `Ctrl+r` - Redo
- `.` - Repeat last change

### Case Changes

- `~` - Toggle case of character
- `gUw` - Uppercase word
- `guw` - Lowercase word
- `gUU` - Uppercase line
- `guu` - Lowercase line
- `~` (in visual mode) - Toggle case of selection

### Find & Replace

- `:s/foo/bar/g` - Replace all in current line
- `:s/foo/bar/gc` - Replace all in line with confirmation
- `:%s/foo/bar/g` - Replace all in file
- `:%s/foo/bar/gc` - Replace all in file with confirmation
- `:g/foo/d` - Delete all lines containing foo
- `:v/foo/d` - Delete all lines NOT containing foo

## Visual Mode

### Selection

- `v` - Character-wise visual mode
- `V` - Line-wise visual mode
- `Ctrl+v` - Block-wise visual mode
- `o` (in visual) - Move to other end of selection

### Text Objects (in visual mode)

- `aw` - Select word
- `as` - Select sentence
- `ap` - Select paragraph
- `ab` or `a(` - Select block with ()
- `aB` or `a{` - Select block with {}
- `a<char>` - Select block with delimiter
- `ib` or `i(` - Select inside ()
- `iB` or `i{` - Select inside {}
- `i<char>` - Select inside delimiter

### Operations (in visual mode)

- `y` - Copy
- `d` - Delete
- `c` - Change
- `>` - Indent
- `<` - Unindent
- `=` - Auto-indent
- `J` - Join lines
- `:s/foo/bar/g` - Replace in selection
- `<leader>/` - Comment/uncomment

## Custom Keybindings

### Code Navigation

- `gd` - Go to definition
- `gr` - Go to references
- `gf` - Go to file under cursor
- `gI` - Go to implementation
- `gD` - Go to declaration
- `K` - Show documentation
- `Ctrl+6` - Go to last cursor position
- `<leader>D` - Go to type definition

### Buffer Management

- `Tab` - Next buffer
- `Shift+Tab` - Previous buffer
- `<leader>w` - Save buffer
- `<leader>b` - New empty buffer

### Window/Pane Management

- `<leader>v` - Split vertically
- `<leader>h` - Split horizontally
- `<leader>se` - Equalize pane sizes
- `<leader>xs` - Close pane
- `Ctrl+k` - Move to pane above
- `Ctrl+j` - Move to pane below
- `Ctrl+h` - Move to pane left
- `Ctrl+l` - Move to pane right
- `Up` - Resize pane up
- `Down` - Resize pane down
- `Left` - Resize pane left
- `Right` - Resize pane right

### Comments

- `<leader>/` (normal) - Comment/uncomment line
- `<leader>/` (visual) - Comment/uncomment selection

### LSP

- `gd` - Go to definition
- `gr` - Find references
- `gI` - Go to implementation
- `gD` - Go to declaration
- `<leader>D` - Type definition
- `<leader>rn` - Rename
- `<leader>ca` - Code actions

### File Tree (nvim-tree)

- `<leader>e` - Toggle file tree
- `\` - Switch to file tree
- `g?` (in tree) - Show help
- `a` (in tree) - Add file/directory
- `c` (in tree) - Copy
- `p` (in tree) - Paste
- `d` (in tree) - Delete
- `r` (in tree) - Rename
- `R` (in tree) - Refresh

### Telescope (Fuzzy Finder)

- `<leader>ff` - Find files
- `<leader>fg` - Find in all files (grep)
- `<leader>fd` - Find diagnostics
- `<leader>fb` - Find in buffers
- `<leader>fc` - Find in current buffer
- `<leader>fh` - Find in help
- `Esc` (in telescope) - Close
- `Ctrl+u` (in telescope) - Clear input
- `Ctrl+d` (in buffer picker) - Delete buffer

### GitHub Copilot

- `Ctrl+f` (insert) - Accept suggestion
- `Ctrl+e` (insert) - Dismiss suggestion
- `<leader>c` (normal) - Toggle copilot chat
- `<leader>ce` (visual) - Explain selected text
- `Ctrl+s` (copilot chat insert) - Submit message
- `Ctrl+c` (copilot chat insert) - Close chat
- `q` (copilot chat normal) - Close chat

### Autocompletion

- `Ctrl+n` (insert) - Next completion
- `Ctrl+p` (insert) - Previous completion
- `Ctrl+e` (insert) - Abort completion
- `Tab` (insert) - Confirm completion

### Testing (Neotest)

- `<leader>tt` - Run test
- `<leader>tf` - Run test file
- `<leader>tp` - Toggle test output panel
- `<leader>ts` - Toggle test summary

### Diagnostics (Trouble)

- `<leader>dd` - Toggle diagnostics panel
- `<leader>dc` - Toggle buffer diagnostics

## Tips & Tricks

### Delete a Column

1. Press `Ctrl+v`
2. Highlight columns to remove
3. Press `d` or `x`

### Insert Text on Multiple Lines (Before cursor)

1. Press `Ctrl+v` and select vertical lines
2. Press `I`
3. Type the text (appears only on first line)
4. Press `Esc` and wait - text applies to all lines

### Append Text on Multiple Lines (After selection)

1. Press `Ctrl+v` and select vertical lines
2. Press `A`
3. Type the text
4. Press `Esc` to apply to all lines

### Replace Word with Braces/Punctuation

For example: `interface{}` → `string`

**Using `cf}`:**

1. Cursor on first character (`i` in interface)
2. Type `cf}`
3. Type new text and press `Esc`

**Using `c2iw` (change 2 inner words):**

1. Cursor on first word
2. Type `c2iw`
3. Type new text and press `Esc`

### Macros

- `q<letter>` - Start recording macro
- `q` - Stop recording
- `@<letter>` - Play macro
- `@@` - Replay last macro

### Marks

- `m<letter>` - Set mark
- `` `<letter> `` - Jump to mark (exact position)
- `'<letter>` - Jump to mark (beginning of line)
- `` `. `` - Jump to last change
- `''` - Jump to previous position
