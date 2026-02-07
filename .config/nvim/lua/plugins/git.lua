return {
  {
    -- Git integration for Vim
    -- https://github.com/tpope/vim-fugitive
    "tpope/vim-fugitive",
  },
  {
    -- Git integration for buffers
    -- https://github.com/lewis6991/gitsigns.nvim
    "lewis6991/gitsigns.nvim",
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
