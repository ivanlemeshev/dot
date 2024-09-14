return {
  {
    -- Automatically adjust 'shiftwidth' and 'expandtab' heuristically based
    -- on the current file, or, in the case the current file is new, blank, or
    -- otherwise insufficient, by looking at other files of the same type in
    -- the current and parent directories.
    "tpope/vim-sleuth",
  },
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
    event = "VimEnter",
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
}
