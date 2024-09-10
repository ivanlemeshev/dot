return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
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
        "zig",
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
  },
  {
    "github/copilot.vim",
    lazy = false,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    lazy = false,
    branch = "canary",
    dependencies = {
      "github/copilot.vim",
      "nvim-lua/plenary.nvim",
    },
    build = "make tiktoken", -- only on MacOS or Linux
    opts = {
      debug = true,
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      filters = {
        enable = true,
        git_ignored = false,
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        no_bookmark = false,
        custom = {
          "^.git$",
        },
        exclude = {},
      },
    },
  },
}
