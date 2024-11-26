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
    "rachartier/tiny-inline-diagnostic.nvim",
    config = function()
      require("tiny-inline-diagnostic").setup()
    end,
  },
}
