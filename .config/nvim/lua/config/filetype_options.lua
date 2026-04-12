--- *config.filetype_options* Filetype-local editor options
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

---@class LemFiletypeIndentConfig
---@field expandtab boolean Expand tabs to spaces
---@field width number Value for tabstop, shiftwidth, and softtabstop

---@type table<string, LemFiletypeIndentConfig>
local indent_by_filetype = {
  c = { expandtab = true, width = 2 },
  cpp = { expandtab = true, width = 2 },
  cs = { expandtab = true, width = 4 },
  dockerfile = { expandtab = true, width = 2 },
  fish = { expandtab = true, width = 4 },
  go = { expandtab = false, width = 4 },
  gomod = { expandtab = false, width = 4 },
  gosum = { expandtab = false, width = 4 },
  json = { expandtab = true, width = 2 },
  lua = { expandtab = true, width = 2 },
  make = { expandtab = false, width = 4 },
  markdown = { expandtab = true, width = 2 },
  proto = { expandtab = true, width = 2 },
  ps1 = { expandtab = false, width = 4 },
  python = { expandtab = true, width = 4 },
  sh = { expandtab = true, width = 2 },
  terraform = { expandtab = true, width = 2 },
  toml = { expandtab = true, width = 2 },
  typescript = { expandtab = true, width = 2 },
  vim = { expandtab = true, width = 2 },
  yaml = { expandtab = true, width = 2 },
  ["yaml.ansible"] = { expandtab = true, width = 2 },
  zig = { expandtab = true, width = 4 },
}

--- Apply indentation settings for the buffer filetype.
---@param buf number Buffer handle
local function apply_indent_options(buf)
  local config = indent_by_filetype[vim.bo[buf].filetype]
  if config == nil then
    return
  end

  vim.bo[buf].expandtab = config.expandtab
  vim.bo[buf].tabstop = config.width
  vim.bo[buf].shiftwidth = config.width
  vim.bo[buf].softtabstop = config.width
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("filetype-options", { clear = true }),
  callback = function(args)
    apply_indent_options(args.buf)
  end,
})
