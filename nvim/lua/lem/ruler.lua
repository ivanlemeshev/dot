--- *lem.ruler* Customizable vertical ruler for Neovim
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev

local M = {}

---@class LemRulerConfig
---@field enabled? boolean Enable ruler by default (default: true)
---@field columns? number[] Column positions where to draw the ruler (default: { 80 })
---@field char? string Character to use for the ruler line (default: "│")
---@field filetype_columns? table<string, number[]> Filetype-specific column positions (default: {})
---@field exclude_filetypes? string[] Filetypes to exclude from ruler
---@field exclude_buftypes? string[] Buffer types to exclude from ruler

---@type LemRulerConfig
local defaults = {
  enabled = true,
  columns = { 80 },
  char = "│",
  filetype_columns = {},
  exclude_filetypes = {
    "NvimTree",
    "TelescopePrompt",
    "TelescopeResults",
    "checkhealth",
    "fugitive",
    "gitcommit",
    "gitrebase",
    "help",
    "lazy",
    "lspinfo",
    "man",
    "mason",
    "qf",
    "toggleterm",
    "trouble",
  },
  exclude_buftypes = {
    "nofile",
    "prompt",
    "quickfix",
    "terminal",
  },
}

--- Active configuration
---@type LemRulerConfig
M.config = vim.deepcopy(defaults)

local ns_id = vim.api.nvim_create_namespace("lem_ruler")
local AUGROUP_NAME = "LemRuler"

--- Setup the ruler module with custom configuration
---@param config? LemRulerConfig Custom configuration options
function M.setup(config)
  -- Merge into a fresh copy of defaults to prevent state pollution
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(defaults), config or {})

  if M.config.enabled then
    M.enable()
  else
    M.disable()
  end
end

--- Enable the ruler and its autocommands
function M.enable()
  local update_events =
    { "BufEnter", "WinScrolled", "TextChanged", "TextChangedI" }

  vim.api.nvim_create_autocmd(update_events, {
    group = vim.api.nvim_create_augroup(AUGROUP_NAME, { clear = true }),
    callback = function()
      M.draw()
    end,
  })

  M.draw()
end

--- Disable the ruler, clear marks, and remove autocommands
function M.disable()
  local buf = vim.api.nvim_get_current_buf()

  -- Delete the augroup to clean up memory
  pcall(vim.api.nvim_del_augroup_by_name, AUGROUP_NAME)

  -- Clear all marks in the current buffer
  vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
end

--- Draw the ruler in the current buffer
function M.draw()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local buftype = vim.bo[buf].buftype
  local filetype = vim.bo[buf].filetype

  -- Skip if it's a floating window (ToggleTerm, Telescope, etc.)
  local win_config = vim.api.nvim_win_get_config(win)
  if win_config.relative ~= "" then
    return
  end

  -- Clear existing rulers first
  vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)

  -- Validations
  if vim.tbl_contains(M.config.exclude_buftypes, buftype) then
    return
  end
  if vim.tbl_contains(M.config.exclude_filetypes, filetype) then
    return
  end

  local top = vim.fn.line("w0")
  local bot = vim.fn.line("w$")
  local columns = M.config.filetype_columns[filetype] or M.config.columns

  for line = top, bot do
    local line_text = vim.api.nvim_buf_get_lines(buf, line - 1, line, false)[1]
      or ""

    -- Use strdisplaywidth to correctly handle Tabs and Multi-byte characters
    local visual_width = vim.fn.strdisplaywidth(line_text)

    for _, col in ipairs(columns) do
      if visual_width < col then
        vim.api.nvim_buf_set_extmark(buf, ns_id, line - 1, 0, {
          virt_text = { { M.config.char, "NonText" } },
          virt_text_pos = "overlay",
          virt_text_win_col = col - 1,
          hl_mode = "combine",
        })
      end
    end
  end
end

return M
