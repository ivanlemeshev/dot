-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Automatically save changes to a file if the current buffer is modified.
vim.api.nvim_create_autocmd({ "TextChanged", "BufLeave", "InsertLeave" }, {
  callback = function()
    if vim.bo.modified then
      vim.api.nvim_exec_autocmds("BufWritePre", {
        pattern = vim.fn.expand("%")
      })

      vim.api.nvim_command("write")

      vim.api.nvim_exec_autocmds("BufWritePost", {
        pattern = vim.fn.expand("%")
      })
    end
  end,
})
