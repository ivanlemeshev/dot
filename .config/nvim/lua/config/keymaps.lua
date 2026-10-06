--- *config.keymaps* Global keymaps
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

local helpers = require("config.helpers")

helpers.nmap("<leader>w", "<cmd>write<CR>", "Save the current buffer")

local scroll_maps = {
  { "<C-d>", "<C-d>zz", "Scroll down half a screen" },
  { "<C-u>", "<C-u>zz", "Scroll up half a screen" },
  { "<C-f>", "<C-f>zz", "Scroll down one screen" },
  { "<C-b>", "<C-b>zz", "Scroll up one screen" },
}

for _, item in ipairs(scroll_maps) do
  helpers.nmap(item[1], item[2], item[3])
end

helpers.nmap("n", "nzzzv", "Move to the next search result")
helpers.nmap("N", "Nzzzv", "Move to the previous search result")

helpers.vmap("<", "<gv", "Indent selection left")
helpers.vmap(">", ">gv", "Indent selection right")

helpers.nmap("<leader>c", "gcc", "Toggle line comment", { remap = true })
helpers.vmap("<leader>c", "gc", "Toggle comment", { remap = true })

helpers.nmap("<leader>e", "<cmd>NvimTreeToggle<CR>", "Toggle file tree")

helpers.nmap("<leader>pu", function()
  vim.pack.update()
end, "Plugins: update")
