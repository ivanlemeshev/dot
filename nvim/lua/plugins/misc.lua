return {
  {
    -- Git integration for Vim
    "tpope/vim-fugitive",
    event = "BufRead",
  },
  {
    -- Hints keybinds
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
      icons = {
        mappings = false,
      },
    },
  },
  {
    -- Highlight todo, notes, etc in comments
    "folke/todo-comments.nvim",
    event = "BufRead",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      signs = false,
    },
  },
  {
    -- High-performance color highlighter
    "norcalli/nvim-colorizer.lua",
    event = "BufRead",
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
    event = "LspAttach",
    config = function()
      require("tiny-inline-diagnostic").setup()
    end,
  },
}
