return {
  {
    -- Git integration for Vim
    -- https://github.com/tpope/vim-fugitive
    "tpope/vim-fugitive",
    commit = "61b51c09b7c9ce04e821f6cf76ea4f6f903e3cf4",
  },
  {
    -- Git integration for buffers
    -- https://github.com/lewis6991/gitsigns.nvim
    "lewis6991/gitsigns.nvim",
    commit = "31217271a7314c343606acb4072a94a039a19fb5",
    opts = {},
    config = function(_, opts)
      require("gitsigns").setup(opts)

      local map = vim.keymap.set

      map(
        "n",
        "<leader>gb",
        "<cmd>Gitsigns blame_line<CR>",
        { desc = "Git: blame line" }
      )
    end,
  },
}
