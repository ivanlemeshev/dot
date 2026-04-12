--- *config.large_files* Large file safeguards for Neovim buffers
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

local large_file_max_size = 2 * 1024 * 1024

--- Return file size in bytes.
---@param path string File path
---@return number? size File size, or nil if unavailable
local function file_size(path)
  local size = vim.fn.getfsize(path)
  if size < 0 then
    return nil
  end

  return size
end

--- Check whether the file should use large-file mode.
---@param path string File path
---@return boolean
local function is_large_file(path)
  if path == "" or vim.fn.isdirectory(path) == 1 then
    return false
  end

  local size = file_size(path)
  return size ~= nil and size >= large_file_max_size
end

--- Disable expensive buffer features for large files.
---@param buf number Buffer handle
local function apply_large_file_mode(buf)
  vim.b[buf].large_file = true
  vim.bo[buf].swapfile = false
  vim.bo[buf].undofile = false
  vim.bo[buf].bufhidden = "unload"
  vim.bo[buf].readonly = true

  for option, value in pairs({
    cursorline = false,
    foldenable = false,
    foldmethod = "manual",
    linebreak = false,
    list = false,
    number = false,
    relativenumber = false,
    spell = false,
    wrap = false,
  }) do
    vim.api.nvim_set_option_value(option, value, { buf = buf })
  end
end

--- Stop syntax, diagnostics, and Tree-sitter for a large file buffer.
---@param buf number Buffer handle
local function stop_large_file_features(buf)
  vim.bo[buf].syntax = "off"
  vim.diagnostic.enable(false, { bufnr = buf })

  local ok = pcall(vim.treesitter.stop, buf)
  if not ok then
    vim.schedule(function()
      pcall(vim.treesitter.stop, buf)
    end)
  end
end

local large_file_augroup =
  vim.api.nvim_create_augroup("large-files", { clear = true })

vim.api.nvim_create_autocmd("BufReadPre", {
  group = large_file_augroup,
  pattern = "*",
  callback = function(args)
    if is_large_file(args.match) then
      apply_large_file_mode(args.buf)
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = large_file_augroup,
  pattern = "*",
  callback = function(args)
    if not vim.b[args.buf].large_file then
      return
    end

    stop_large_file_features(args.buf)
  end,
})
