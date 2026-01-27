return {
  "lem.nvim",
  dir = vim.fn.stdpath("config") .. "/lua/lem",
  name = "lem.ruler",
  lazy = false,
  config = function()
    require("lem.ruler").setup({
      char = "┆", -- e.g. '┆', '┊', "│", etc.
      columns = { 80 }, -- default for all files
      filetype_columns = {
        lua = { 120 },
      },
    })
  end,
}
