--- *lem.binary* Binary file handling for Neovim
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

local M = {}

---@alias LemBinaryExtensionMap table<string, boolean>

---@type LemBinaryExtensionMap
local binary_extensions = {
  ["7z"] = true,
  a = true,
  bin = true,
  bmp = true,
  class = true,
  db = true,
  dll = true,
  dylib = true,
  exe = true,
  gif = true,
  gz = true,
  icns = true,
  ico = true,
  jar = true,
  jpeg = true,
  jpg = true,
  o = true,
  pdf = true,
  png = true,
  pyc = true,
  pyd = true,
  pyo = true,
  so = true,
  sqlite = true,
  sqlite3 = true,
  tar = true,
  ttf = true,
  wasm = true,
  webp = true,
  xz = true,
  zip = true,
}

---@param path string File path
---@param size number Number of bytes to read
---@return string? data File contents, or nil if the file cannot be read
local function read_file_chunk(path, size)
  local file = io.open(path, "rb")
  if not file then
    return nil
  end

  local data = file:read(size)
  file:close()
  return data
end

---@param path string File path
---@return boolean
local function is_known_binary_extension(path)
  local extension = vim.fn.fnamemodify(path, ":e"):lower()
  return extension ~= "" and binary_extensions[extension] == true
end

---@param path string File path
---@return boolean
local function has_nul_byte(path)
  local chunk = read_file_chunk(path, 1024)
  return chunk ~= nil and chunk:find("\0", 1, true) ~= nil
end

---@param path string File path
---@return boolean
local function should_open_as_binary(path)
  if path == "" or vim.fn.isdirectory(path) == 1 then
    return false
  end

  return is_known_binary_extension(path) or has_nul_byte(path)
end

-- NOTE: Binary buffers stay read-only to prevent accidental changes.
---@param buf number Buffer handle
local function open_buffer_as_hex(buf)
  vim.bo[buf].swapfile = false
  vim.bo[buf].undofile = false
  vim.bo[buf].binary = true

  if vim.fn.executable("xxd") == 1 then
    vim.api.nvim_buf_call(buf, function()
      vim.cmd("%!xxd -g 1")
    end)
    vim.bo[buf].filetype = "xxd"
  end

  vim.bo[buf].modifiable = false
  vim.bo[buf].readonly = true
  vim.bo[buf].modified = false
end

function M.setup()
  local group = vim.api.nvim_create_augroup("binary-buffers", { clear = true })

  vim.api.nvim_create_autocmd("BufReadPost", {
    group = group,
    pattern = "*",
    callback = function(args)
      if vim.bo[args.buf].buftype ~= "" then
        return
      end

      if not should_open_as_binary(args.match) then
        return
      end

      open_buffer_as_hex(args.buf)
    end,
  })
end

return M
