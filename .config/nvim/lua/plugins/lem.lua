return {
  "lem.nvim",
  dir = vim.fn.stdpath("config") .. "/lua/lem",
  name = "lem.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("lem.colorscheme").setup()

    require("lem.ruler").setup({
      char = "┆", -- e.g. '┆', '┊', "│", etc.
      columns = { 80 }, -- default for all files
      exclude_filetypes = {
        "NvimTree",
        "TelescopePrompt",
        "TelescopeResults",
        "checkhealth",
        "csv",
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
  end,
}
