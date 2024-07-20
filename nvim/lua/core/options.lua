-- The leader key is a prefix used in combination with other keys to create
-- custom shortcuts. Any subsequent key mappings that use <leader> will require
-- pressing the space bar first.
vim.g.mapleader = ' '

-- The local leader key functions similarly to the global leader key, acting as
-- a prefix for key mappings. However, the local leader key can be different in
-- each buffer, allowing for buffer-specific shortcuts.
vim.g.maplocalleader = ' '

-- Controls how backspace behaves in insert mode. Specifically, setting it to
-- '2' allows the backspace key to delete over autoindent, line breaks (enter),
-- and the start of insert; essentially making backspace work more like it does
-- in other modern text editors.
vim.opt.backspace = '2'

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

-- Automatically save changes to a file when you switch to another file or
-- before running certain commands that would normally require saving the file
-- first.
vim.opt.autowrite = true

-- Highlights the line where the cursor is currently positioned.
vim.opt.cursorline = true

-- Automatically read the file from disk when it has been changed outside of
-- Neovim, ensuring that the file's contents are always up to date with its
-- external changes.
vim.opt.autoread = true

-- A tab character will be displayed as two spaces wide. This setting affects
-- the appearance of tab characters in the editor but does not change the actual
-- character in the file. It's commonly used to make code more readable and to
-- ensure consistent indentation when collaborating on projects with a preferred
-- indentation style.
vim.opt.tabstop = 2

-- Controls the number of spaces used for each step of indentation. When you
-- press the tab key (in insert mode) or use commands for indentation (like >>
-- or << in normal mode), Neovim will insert or remove spaces based on this
-- value.
vim.opt.shiftwidth = 2

-- Round the indentation to the nearest multiple of the value set in shiftwidth
-- when you use indentation commands like >>, <<, or when auto-indenting.
vim.opt.shiftround = true

-- Insert spaces instead of tab characters when the tab key is pressed or when
-- auto-indentation occurs.
vim.opt.expandtab = true

-- Highlights column 80 in the editor, serving as a visual guide to indicate a
-- recommended maximum line length.
vim.opt.colorcolumn = "80"

-- Disables the creation of swap files. Swap files are used to store changes
-- that you've made to your documents, allowing recovery in case of an
-- unexpected program exit, crash, or power loss.
vim.cmd [[ set noswapfile ]]

-- Enables true color support in the terminal. Neovim attempts to use 24-bit RGB
-- colors (true colors) in the terminal.
vim.cmd [[ set termguicolors ]]

-- Display the line numbers next to each line.
vim.wo.number = true
