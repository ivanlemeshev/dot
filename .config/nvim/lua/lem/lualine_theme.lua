-- Custom lualine theme (no external dependency)

local p = require("lem.colorscheme").palette

return {
  normal = {
    a = { bg = p.fg_alt, fg = p.bg, gui = "bold" },
    b = { bg = p.bg_alt, fg = p.fg },
    c = { bg = p.bg_alt, fg = p.fg },
  },
  insert = {
    a = { bg = p.green, fg = p.bg, gui = "bold" },
    b = { bg = p.bg_alt, fg = p.fg },
    c = { bg = p.bg_alt, fg = p.fg },
  },
  visual = {
    a = { bg = p.orange, fg = p.bg, gui = "bold" },
    b = { bg = p.bg_alt, fg = p.fg },
    c = { bg = p.bg_alt, fg = p.fg },
  },
  replace = {
    a = { bg = p.yellow, fg = p.bg, gui = "bold" },
    b = { bg = p.bg_alt, fg = p.fg },
    c = { bg = p.bg_alt, fg = p.fg },
  },
  command = {
    a = { bg = p.blue, fg = p.bg, gui = "bold" },
    b = { bg = p.bg_alt, fg = p.fg },
    c = { bg = p.bg_alt, fg = p.fg },
  },
  terminal = {
    a = { bg = p.magenta, fg = p.bg, gui = "bold" },
    b = { bg = p.bg_alt, fg = p.fg },
    c = { bg = p.bg_alt, fg = p.fg },
  },
  inactive = {
    a = { bg = p.bg_alt, fg = p.dim },
    b = { bg = p.bg_alt, fg = p.dim },
    c = { bg = p.bg_alt, fg = p.dim },
  },
}
