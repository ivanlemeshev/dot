return {
  "folke/trouble.nvim",
  commit = "bd67efe408d4816e25e8491cc5ad4088e708a69a",
  dependencies = {
    { "nvim-tree/nvim-web-devicons", commit = "746ffbb17975ebd6c40142362eee1b0249969c5c" },
  },
  opts = {
    focus = true,
    modes = {
      diagnostics = {
        auto_close = true,
      },
    },
  },
  cmd = "Trouble",
  keys = {
    {
      "<leader>dd",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Trouble: toggle diagnostics panel",
    },
    {
      "<leader>dc",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Trouble: toggle buffer diagnostics",
    },
  },
}
