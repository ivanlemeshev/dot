return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "c_sharp",
        "cmake",
        "cpp",
        "csv",
        "css",
        "fish",
        "go",
        "gomod",
        "gosum",
        "gotmpl",
        "gowork",
        "helm",
        "html",
        "json",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "tmux",
        "toml",
        "vim",
        "vimdoc",
        "yaml",
      },
      highlight = {
        enable = true,
        use_languagetree = true,
      },
      indent = { enable = true },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
      },
    },
  }
}
