return {
  "folke/trouble.nvim",
  event = "BufRead",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
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
      desc = "Troule: toggle diagnostics panel",
    },
    {
      "<leader>dc",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Trouble: toggle buffer diagnostics",
    },
  },
}
