return {
  "folke/trouble.nvim",
  opts = {},
  cmd = "Trouble",
  keys = {
    {
      "<leader>xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Troule: toggle diagnostics panel",
    },
    {
      "<leader>xc",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Trouble: toggle buffer diagnostics",
    },
  },
}
