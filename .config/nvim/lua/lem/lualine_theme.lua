-- Gruvbox Material lualine theme (custom, no external dependency)
-- Baked settings: dark/medium/material, statusline_style="default"

local p = require("lem.colorscheme").palette

return {
  normal = {
    a = { bg = p.grey2, fg = p.bg0, gui = "bold" },
    b = { bg = p.bg_statusline3, fg = p.fg1 },
    c = { bg = p.bg_statusline1, fg = p.fg1 },
  },
  insert = {
    a = { bg = p.bg_green, fg = p.bg0, gui = "bold" },
    b = { bg = p.bg_statusline3, fg = p.fg1 },
    c = { bg = p.bg_statusline1, fg = p.fg1 },
  },
  visual = {
    a = { bg = p.bg_red, fg = p.bg0, gui = "bold" },
    b = { bg = p.bg_statusline3, fg = p.fg1 },
    c = { bg = p.bg_statusline1, fg = p.fg1 },
  },
  replace = {
    a = { bg = p.bg_yellow, fg = p.bg0, gui = "bold" },
    b = { bg = p.bg_statusline3, fg = p.fg1 },
    c = { bg = p.bg_statusline1, fg = p.fg1 },
  },
  command = {
    a = { bg = p.blue, fg = p.bg0, gui = "bold" },
    b = { bg = p.bg_statusline3, fg = p.fg1 },
    c = { bg = p.bg_statusline1, fg = p.fg1 },
  },
  terminal = {
    a = { bg = p.purple, fg = p.bg0, gui = "bold" },
    b = { bg = p.bg_statusline3, fg = p.fg1 },
    c = { bg = p.bg_statusline1, fg = p.fg1 },
  },
  inactive = {
    a = { bg = p.bg_statusline1, fg = p.grey2 },
    b = { bg = p.bg_statusline1, fg = p.grey2 },
    c = { bg = p.bg_statusline1, fg = p.grey2 },
  },
}
