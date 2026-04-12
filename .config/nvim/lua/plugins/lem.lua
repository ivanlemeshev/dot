-- Local custom lem modules - no need for vim.pack
-- Just require them directly since they're in lua/lem/

require("lem.colorscheme").setup()
require("lem.binary").setup()

require("lem.ruler").setup({
  char = "┆", -- e.g. '┆', '┊', "│", etc.
  columns = { 80 }, -- default for all files
  exclude_filetypes = {
    "NvimTree",
    "checkhealth",
    "csv",
    "gitcommit",
    "gitrebase",
    "help",
    "lspinfo",
    "man",
    "mason",
    "qf",
  },
  exclude_buftypes = {
    "nofile",
    "prompt",
    "quickfix",
    "terminal",
  },
  filetype_config = {
    lua = {
      columns = { 120 },
    },
  },
})

require("lem.terminal").setup({
  width_percent = 0.8,
  height_percent = 0.8,
  start_in_insert = true,
})
