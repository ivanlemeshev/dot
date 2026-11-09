--- *config.keymaps* Global keymaps
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

local helpers = require("config.helpers")

helpers.nmap("<leader>w", "<cmd>write<CR>", "Save the current buffer")
helpers.nmap("<leader>fn", function()
  vim.api.nvim_set_current_buf(vim.api.nvim_create_buf(true, false))
end, "New file")

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

helpers.nmap("<leader>e", function()
  local api = require("nvim-tree.api")
  local has_file = false
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buflisted and vim.bo[buf].buftype == "" then
      if vim.api.nvim_buf_get_name(buf) ~= "" or vim.bo[buf].modified then
        has_file = true
        break
      end
    end
  end

  if api.tree.is_visible() then
    api.tree.close()
    if not has_file then
      require("config.welcome").show()
    end
    return
  end
  if has_file then
    api.tree.open()
    return
  end

  local buf = vim.api.nvim_get_current_buf()
  local empty = vim.bo[buf].buftype == ""
    and vim.api.nvim_buf_get_name(buf) == ""
    and not vim.bo[buf].modified
    and vim.api.nvim_buf_line_count(buf) == 1
    and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
  api.tree.open({ current_window = true })
  if empty and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_delete(buf, {})
  end
end, "Toggle file tree")

helpers.nmap("<leader>tw", function()
  local markers = vim.opt_local.listchars:get()
  if markers.space == "·" then
    markers.space = nil
  else
    markers.space = "·"
  end
  vim.opt_local.listchars = markers
  vim.wo.list = true
end, "Toggle all space markers")

helpers.nmap("<leader>pu", function()
  vim.pack.update()
end, "Plugins: update")
