-- Disable netrw, the built-in file explorer.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Allow the backspace key to delete over autoindent, line breaks (enter), and
-- the start of insert; essentially making backspace work more like it does
-- in other modern text editors.
vim.opt.backspace = "2"

-- Display incomplete commands in the bottom right corner of the window. This
-- feature is useful for seeing which keys you have pressed during a command
-- sequence, helping you understand what action is being performed or if you've
-- made a mistake in a multi-key command.
vim.opt.showcmd = true

-- Always display the status line, regardless of whether there are multiple
-- windows open. This is useful for constantly showing information like the
-- current mode, file name, or any other status line integrations.
vim.opt.laststatus = 2

-- Automatically read the file from disk when it has been changed outside of
-- Neovim, ensuring that the file's contents are always up to date with its
-- external changes.
vim.opt.autoread = true

-- Automatically save changes to a file when you switch to another file or
-- before running certain commands that would normally require saving the file
-- first.
vim.opt.autowrite = true

-- Automatically save changes to all modified buffers without prompting the
-- user. This can be particularly useful for preventing data loss and ensuring
-- that all changes are consistently saved.
vim.opt.autowriteall = true

-- Highlight the line where the cursor is currently positioned.
vim.opt.cursorline = true

-- Highlight column 80 in the editor, serving as a visual guide to indicate a
-- recommended maximum line length.
vim.opt.colorcolumn = "80"

-- Display the line numbers next to each line.
vim.opt.number = true

-- Disable relative line numbers.
vim.opt.relativenumber = false

-- Display whitespace characters using special symbols.
vim.opt.list = true

-- Display tabs, whitespaces, the end of the line.
vim.opt.listchars:append {
  eol = "¬",
  tab = "→ ",
  -- space = ".",
  -- multispace = ".",
  -- lead = ".",
  -- leadmultispace = ".",
  trail = " ",
  -- nbsp = ".",
}

-- Sync the system clipboard with the internal Neovim clipboard.
vim.opt.clipboard = "unnamedplus"

-- Wrap lines at the edge of the window.
vim.opt.wrap = true

-- Do not split words when wrapping lines.
vim.opt.linebreak = true

-- Enable the mouse in all modes.
vim.opt.mouse = "a"

-- Copy the indent from the previous line when starting a new line.
vim.opt.autoindent = true

-- Set the number of spaces to use for each step of (auto)indent.
vim.opt.shiftwidth = 4

-- Set the number of spaces that a <Tab> in the file counts for.
vim.opt.tabstop = 4

-- Set the number of spaces that a <Tab> in the file counts for while editing.
vim.opt.softtabstop = 4

-- Use spaces instead of tabs for indentation.
vim.opt.expandtab = true

-- Do not create backup files.
vim.opt.swapfile = false

-- Enable true color support in the terminal.
vim.opt.termguicolors = true

vim.opt.spell = true
vim.opt.spelllang = "en_us"
