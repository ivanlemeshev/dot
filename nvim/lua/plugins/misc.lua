return {
  {
    -- Git integration for Vim
    "tpope/vim-fugitive",
  },
  {
    -- Hints keybinds
    "folke/which-key.nvim",
    opts = {
      icons = {
        mappings = false,
      },
    },
  },
  {
    -- Highlight todo, notes, etc in comments
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = false,
    },
  },
  {
    -- High-performance color highlighter
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    config = function()
      require("tiny-inline-diagnostic").setup()
    end,
  },
}
