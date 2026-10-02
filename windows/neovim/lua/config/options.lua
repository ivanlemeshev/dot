-- Use curly underlines in terminals that support them.
vim.cmd([[let &t_Cs = "\e[4:3m"]])

-- Reset the terminal underline style.
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Set the cursor shape for each editing mode.
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block"

-- Let Backspace delete indentation, line breaks, and text before the line start.
vim.opt.backspace = "2"

-- Keep ten lines visible above and below the cursor.
vim.opt.scrolloff = 10

-- Show incomplete commands in the command area.
vim.opt.showcmd = true

-- Reload files when Neovim detects changes outside the editor.
vim.opt.autoread = true

-- Save the current buffer before commands that need a saved file.
vim.opt.autowrite = true

-- Save all modified buffers when Neovim exits or runs a command that needs them saved.
vim.opt.autowriteall = true

-- Highlight the line that contains the cursor.
vim.opt.cursorline = true

-- Show absolute line numbers.
vim.opt.number = true

-- Hide relative line numbers.
vim.opt.relativenumber = false

-- Show whitespace characters with the symbols below.
vim.opt.list = true

-- Set the symbols that show whitespace characters.
vim.opt.listchars = {
  eol = " ",
  tab = "  ",
  space = ".",
  multispace = ".",
  lead = ".",
  leadmultispace = ".",
  trail = ".",
  nbsp = ".",
}

-- Add a newline at the end of each file when needed.
vim.opt.fixeol = true

-- Use the system clipboard for yanks and puts.
vim.opt.clipboard = "unnamedplus"

-- Wrap long lines in the window.
vim.opt.wrap = true

-- Wrap lines at word boundaries when possible.
vim.opt.linebreak = true

-- Enable mouse input in Neovim.
vim.opt.mouse = "a"

-- Add a border to completion menus.
vim.opt.pumborder = "single"

-- Ignore letter case during searches.
vim.opt.ignorecase = true

-- Match letter case when a search pattern contains uppercase letters.
vim.opt.smartcase = true

-- Highlight all search matches.
vim.opt.hlsearch = true

-- Show search matches as the pattern is typed.
vim.opt.incsearch = true

-- Save undo history between Neovim sessions.
vim.opt.undofile = true

-- Open horizontal splits below the current window.
vim.opt.splitbelow = true

-- Open vertical splits to the right of the current window.
vim.opt.splitright = true

-- Copy indentation from the previous line.
vim.opt.autoindent = true

-- Do not create swap files.
vim.opt.swapfile = false

-- Wait this many milliseconds for a mapped key sequence to finish.
vim.opt.timeoutlen = 500

-- Wait this many milliseconds for a terminal key code to finish.
vim.opt.ttimeoutlen = 10

-- Wait this many milliseconds before Neovim runs CursorHold events.
vim.opt.updatetime = 250

-- Limit completion menus to ten lines.
vim.opt.pumheight = 10

-- Use 24-bit colors in the terminal.
vim.opt.termguicolors = true

-- Detect files that use Unix or Windows line endings.
vim.opt.fileformats = "unix,dos"
