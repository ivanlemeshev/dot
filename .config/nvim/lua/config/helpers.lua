--- *config.helpers* Shared helper functions for Neovim config modules
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

local M = {}

--- Create a clear augroup.
---@param name string Augroup name
---@return integer group Augroup id
function M.augroup(name)
  return vim.api.nvim_create_augroup(name, { clear = true })
end

--- Define a keymap with common defaults.
---@param mode string|string[] Mode or modes
---@param lhs string Left-hand side
---@param rhs string|function Right-hand side
---@param desc? string Keymap description
---@param opts? vim.keymap.set.Opts Additional keymap options
function M.map(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  if opts.noremap == nil and opts.remap == nil then
    opts.noremap = true
  end
  if opts.silent == nil then
    opts.silent = true
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

--- Define a normal-mode keymap.
---@param lhs string Left-hand side
---@param rhs string|function Right-hand side
---@param desc? string Keymap description
---@param opts? vim.keymap.set.Opts Additional keymap options
function M.nmap(lhs, rhs, desc, opts)
  M.map("n", lhs, rhs, desc, opts)
end

--- Define a visual-mode keymap.
---@param lhs string Left-hand side
---@param rhs string|function Right-hand side
---@param desc? string Keymap description
---@param opts? vim.keymap.set.Opts Additional keymap options
function M.vmap(lhs, rhs, desc, opts)
  M.map("v", lhs, rhs, desc, opts)
end

--- Define a terminal-mode keymap.
---@param lhs string Left-hand side
---@param rhs string|function Right-hand side
---@param desc? string Keymap description
---@param opts? vim.keymap.set.Opts Additional keymap options
function M.tmap(lhs, rhs, desc, opts)
  M.map("t", lhs, rhs, desc, opts)
end

--- Load one or more optional packages with :packadd.
---@param names string|string[] Package name or names
function M.packadd(names)
  if type(names) == "string" then
    names = { names }
  end

  for _, name in ipairs(names) do
    vim.cmd.packadd(name)
  end
end

--- Load optional packages once when an event fires, then run setup code.
---@param events string|string[] Autocmd event or events
---@param group_name string Augroup name
---@param plugins string|string[] Optional package name or names
---@param callback fun(args: table) Setup callback
---@param opts? { pattern?: string|string[], once?: boolean } Autocmd options
function M.load_on(events, group_name, plugins, callback, opts)
  opts = opts or {}

  vim.api.nvim_create_autocmd(events, {
    group = M.augroup(group_name),
    pattern = opts.pattern,
    once = opts.once ~= false,
    callback = function(args)
      M.packadd(plugins)
      callback(args)
    end,
  })
end

return M
