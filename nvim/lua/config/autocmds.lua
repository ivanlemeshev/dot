-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Automatically save changes to a file if the current buffer is modified.
vim.api.nvim_create_autocmd({ "BufLeave", "InsertLeave" }, {
  callback = function()
    if vim.bo.modified then
      vim.cmd("write")
    end
  end,
})
