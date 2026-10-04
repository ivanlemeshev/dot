--- *config.keymaps* Global keymaps
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

local helpers = require("config.helpers")

helpers.nmap(";", function()
  vim.api.nvim_feedkeys(":", "nt", false)
end, "Enter command mode")

helpers.nmap("<leader>w", "<cmd>write<CR>", "Save the current buffer")

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

helpers.vmap("<", "<gv", "Indent to the left")
helpers.vmap(">", ">gv", "Indent to the right")

helpers.nmap("<leader>c", "gcc", "Toggle line comment", { remap = true })
helpers.vmap("<leader>c", "gc", "Toggle comment", { remap = true })

helpers.nmap("<leader>e", "<cmd>NvimTreeToggle<CR>", "Toggle NvimTree")

helpers.nmap("<leader>Pu", function()
  vim.pack.update()
end, "Plugins: update")
