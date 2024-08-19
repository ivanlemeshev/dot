-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Controls how backspace behaves in insert mode. Specifically, setting it to
-- '2' allows the backspace key to delete over autoindent, line breaks (enter),
-- and the start of insert; essentially making backspace work more like it does
-- in other modern text editors.
vim.opt.backspace = "2"

-- Display incomplete commands in the bottom right corner of the window. This
-- feature is useful for seeing which keys you have pressed during a command
-- sequence, helping you understand what action is being performed or if you've
-- made a mistake in a multi-key command.
vim.opt.showcmd = true

-- The laststatus option controls when the status line is displayed. Setting it
-- to 2 means the status line is always displayed, regardless of whether there
-- are multiple windows open. This is useful for constantly showing information
-- like the current mode, file name, or any other status line integrations you
-- have configured.
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

-- Highlights the line where the cursor is currently positioned.
vim.opt.cursorline = true

-- Highlights column 80 in the editor, serving as a visual guide to indicate a
-- recommended maximum line length.
vim.opt.colorcolumn = "80"

-- Disables the creation of swap files. Swap files are used to store changes
-- that you've made to your documents, allowing recovery in case of an
-- unexpected program exit, crash, or power loss.
vim.cmd([[ set noswapfile ]])

-- Enables true color support in the terminal. Neovim attempts to use 24-bit
-- RGB colors (true colors) in the terminal.
vim.cmd([[ set termguicolors ]])

-- Display the line numbers next to each line.
vim.opt.number = true

-- Disable relative line numbers.
vim.opt.relativenumber = false

-- Display whitespace characters using special symbols.
vim.opt.list = true

vim.opt.listchars:append({
  tab = "→ ", -- U+2192
  multispace = " ",
  lead = ".",
  trail = "-",
  nbsp = " ",
  eol = "↲", -- U+21B2
})
