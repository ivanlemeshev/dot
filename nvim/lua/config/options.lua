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
-- current mode, file name, or any other status line integration.
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
vim.opt.colorcolumn = vim.opt.colorcolumn + "120"

vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "copilot-chat",
    "help",
    "NvimTree",
    "neotest-output-panel",
    "neotest-summary",
  },
  callback = function()
    vim.opt_local.colorcolumn = ""
  end,
})

-- Display the line numbers next to each line.
vim.opt.number = true

-- Disable relative line numbers.
vim.opt.relativenumber = false

-- Display whitespace characters using special symbols.
vim.opt.list = true

-- Display tabs, whitespaces, the end of the line.
vim.opt.listchars:append({
  eol = "¬",
  tab = "→ ",
  space = ".",
  multispace = ".",
  lead = ".",
  leadmultispace = ".",
  trail = " ",
  nbsp = ".",
})

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

-- Do not create backup files.
vim.opt.swapfile = false

-- Enable true color support in the terminal.
vim.opt.termguicolors = true

-- Disable standard spell checking (Harper is used instead).
vim.opt.spell = false

-- Disable diagnostic virtual text in buffer.
vim.diagnostic.config({
  virtual_text = false,
})

-- Set diagnostic signs.
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.INFO] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵",
    },
  },
})

-- Set options based on the file type.
-- You can check the file type using command :echo &filetype

-- Python settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- Go settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gomod", "gosum" },
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- C settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "c",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- C++ settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Zig settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "zig",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- YAML settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Dockerfile settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dockerfile",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Makefile settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "make",
  callback = function()
    vim.opt_local.expandtab = false
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- JSON settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "json",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Lua settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- TOML settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "toml",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- config.fish settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fish",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- .vimrc settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "vim",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Terraform settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "terraform",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})

-- Protobuf settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "proto",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
})

-- TypeScript settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "typescript",
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
})
