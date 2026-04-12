--- *config.keymaps* Global keymaps
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local helpers = require("config.helpers")

helpers.nmap(";", ":", "Enter command mode")

local scroll_maps = {
  { "<C-d>", "<C-d>zz", "Scroll down half a page" },
  { "<C-u>", "<C-u>zz", "Scroll up half a page" },
  { "<C-f>", "<C-f>zz", "Scroll down a page" },
  { "<C-b>", "<C-b>zz", "Scroll up a page" },
}

for _, item in ipairs(scroll_maps) do
  helpers.nmap(item[1], item[2], item[3])
end

helpers.nmap("n", "nzzzv", "Move to the next search result")
helpers.nmap("N", "Nzzzv", "Move to the previous search result")
helpers.nmap("<leader>w", "<cmd>w<CR>", "Save the current buffer")

local window_maps = {
  { "<C-k>", "<cmd>wincmd k<CR>", "Move to the pane above" },
  { "<C-j>", "<cmd>wincmd j<CR>", "Move to the pane below" },
  { "<C-h>", "<cmd>wincmd h<CR>", "Move to the pane on the left" },
  { "<C-l>", "<cmd>wincmd l<CR>", "Move to the pane on the right" },
  { "<Up>", "<cmd>resize -1<CR>", "Resize the pane up" },
  { "<Down>", "<cmd>resize +1<CR>", "Resize the pane down" },
  { "<Left>", "<cmd>vertical resize -1<CR>", "Resize the pane left" },
  { "<Right>", "<cmd>vertical resize +1<CR>", "Resize the pane right" },
}

for _, item in ipairs(window_maps) do
  helpers.nmap(item[1], item[2], item[3])
end

helpers.vmap("<", "<gv", "Indent to the left")
helpers.vmap(">", ">gv", "Indent to the right")
helpers.nmap("<leader>/", "gcc", "Toggle line comment", { remap = true })
helpers.vmap("<leader>/", "gc", "Toggle comment", { remap = true })
helpers.nmap("<leader>e", "<cmd>NvimTreeToggle<CR>", "Toggle NvimTree")
helpers.nmap("\\", "<cmd>NvimTreeFocus<CR>", "Focus NvimTree")
helpers.nmap("<leader>Pu", function()
  vim.pack.update()
end, "Plugins: update")
