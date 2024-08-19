-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- The leader key is a prefix used in combination with other keys to create
-- custom shortcuts. Any subsequent key mappings that use <leader> will require
-- pressing the space bar first.
vim.g.mapleader = " "

-- The local leader key functions similarly to the global leader key, acting as
-- a prefix for key mappings. However, the local leader key can be different in
-- each buffer, allowing for buffer-specific shortcuts.
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
