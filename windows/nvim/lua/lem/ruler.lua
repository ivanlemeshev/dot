--- *lem.ruler* Vertical ruler using colorcolumn for Neovim
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

local M = {}

---@class LemRulerFiletypeConfig
---@field columns? number[] Column positions for this filetype
---@field exclude_modes? string[] Modes to exclude for this filetype (e.g., { "n", "v" })

---@class LemRulerConfig
---@field enabled? boolean Enable ruler by default (default: true)
---@field columns? number[] Column positions where to draw the ruler (default: { 80 })
---@field exclude_filetypes? string[] Filetypes to exclude from ruler
---@field exclude_buftypes? string[] Buffer types to exclude from ruler
---@field filetype_config? table<string, LemRulerFiletypeConfig> Filetype-specific configuration

---@type LemRulerConfig
local defaults = {
  enabled = true,
  columns = { 80 },
  filetype_config = {},
  exclude_filetypes = {},
  exclude_buftypes = {},
}

--- Active configuration
---@type LemRulerConfig
M.config = vim.deepcopy(defaults)

local AUGROUP_NAME = "LemRuler"

--- Setup the ruler module with custom configuration
---@param config? LemRulerConfig Custom configuration options
function M.setup(config)
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), config or {})

  if M.config.enabled then
    M.enable()
  else
    M.disable()
  end
end

--- Enable the ruler and its autocommands
function M.enable()
  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter", "ModeChanged" }, {
    group = vim.api.nvim_create_augroup(AUGROUP_NAME, { clear = true }),
    callback = function()
      M.apply()
    end,
  })

  M.apply()
end

--- Disable the ruler and clear colorcolumn
function M.disable()
  pcall(vim.api.nvim_del_augroup_by_name, AUGROUP_NAME)
  vim.wo.colorcolumn = ""
end

--- Apply colorcolumn to the current window based on filetype/buftype/mode
function M.apply()
  local buf = vim.api.nvim_get_current_buf()
  local buftype = vim.bo[buf].buftype
  local filetype = vim.bo[buf].filetype

  if vim.tbl_contains(M.config.exclude_buftypes, buftype) then
    vim.wo.colorcolumn = ""
    return
  end

  if vim.tbl_contains(M.config.exclude_filetypes, filetype) then
    vim.wo.colorcolumn = ""
    return
  end

  local ft_config = M.config.filetype_config[filetype]

  if ft_config and ft_config.exclude_modes then
    if vim.tbl_contains(ft_config.exclude_modes, vim.fn.mode()) then
      vim.wo.colorcolumn = ""
      return
    end
  end

  local columns = (ft_config and ft_config.columns) or M.config.columns

  if not columns or #columns == 0 then
    vim.wo.colorcolumn = ""
    return
  end

  local shifted = {}
  for _, col in ipairs(columns) do
    shifted[#shifted + 1] = tostring(col + 1)
  end
  vim.wo.colorcolumn = table.concat(shifted, ",")
end

return M
