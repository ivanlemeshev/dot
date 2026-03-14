-- Custom lualine theme (no external dependency)

local p = require("lem.colorscheme").palette

return {
  normal = {
    a = { bg = p.fg_alt, fg = p.bg },
    b = { bg = p.background_3, fg = p.fg },
    c = { bg = p.background_3, fg = p.fg },
  },
  insert = {
    a = { bg = p.green, fg = p.bg },
    b = { bg = p.background_3, fg = p.fg },
    c = { bg = p.background_3, fg = p.fg },
  },
  visual = {
    a = { bg = p.orange, fg = p.bg },
    b = { bg = p.background_3, fg = p.fg },
    c = { bg = p.background_3, fg = p.fg },
  },
  replace = {
    a = { bg = p.yellow, fg = p.bg },
    b = { bg = p.background_3, fg = p.fg },
    c = { bg = p.background_3, fg = p.fg },
  },
  command = {
    a = { bg = p.blue, fg = p.bg },
    b = { bg = p.background_3, fg = p.fg },
    c = { bg = p.background_3, fg = p.fg },
  },
  terminal = {
    a = { bg = p.magenta, fg = p.bg },
    b = { bg = p.background_3, fg = p.fg },
    c = { bg = p.background_3, fg = p.fg },
  },
  inactive = {
    a = { bg = p.background_3, fg = p.dim },
    b = { bg = p.background_3, fg = p.dim },
    c = { bg = p.background_3, fg = p.dim },
  },
}
