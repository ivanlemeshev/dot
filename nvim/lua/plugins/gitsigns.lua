return {
  "lewis6991/gitsigns.nvim",
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    signs_staged = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
  },
  config = function(_, opts)
    require("gitsigns").setup(opts)

    local map = vim.keymap.set

    map(
      "n",
      "<leader>gb",
      "<cmd>Gitsigns blame_line<CR>",
      { desc = "Git: blame line" }
    )
    map(
      "n",
      "<leader>gd",
      "<cmd>Gitsigns diffthis<CR>",
      { desc = "Git: diff this" }
    )
    map(
      "n",
      "<leader>gn",
      "<cmd>Gitsigns next_hunk<CR>",
      { desc = "Git: next hunk" }
    )
    map(
      "n",
      "<leader>gp",
      "<cmd>Gitsigns prev_hunk<CR>",
      { desc = "Git: previous hunk" }
    )
  end,
}
