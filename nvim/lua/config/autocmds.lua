--- *config.autocmds* General-purpose editor autocommands
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

local helpers = require("config.helpers")

local reload_augroup = helpers.augroup("auto-reload")
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  group = reload_augroup,
  pattern = "*",
  callback = function()
    -- NOTE: checktime fails in Command-line mode and the command-line window.
    if vim.fn.mode() ~= "c" and vim.fn.getcmdwintype() == "" then
      vim.cmd("checktime")
    end
  end,
})

-- NOTE: Whitespace markers can obscure selected text.
local visual_list_augroup = helpers.augroup("visual-list-toggle")
vim.api.nvim_create_autocmd("ModeChanged", {
  group = visual_list_augroup,
  pattern = "*:[vV\22]*",
  callback = function()
    vim.w._list_before_visual = vim.wo.list
    vim.wo.list = false
  end,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  group = visual_list_augroup,
  pattern = "[vV\22]*:*",
  callback = function()
    if vim.w._list_before_visual == nil then
      return
    end

    vim.wo.list = vim.w._list_before_visual
    vim.w._list_before_visual = nil
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[set ff=unix]],
})

local trim_augroup = helpers.augroup("trim-whitespace")
vim.api.nvim_create_autocmd("BufWritePre", {
  group = trim_augroup,
  pattern = "*",
  callback = function()
    if vim.b.large_file then
      return
    end

    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})
