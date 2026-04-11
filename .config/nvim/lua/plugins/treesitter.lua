return {
  -- Enable Treesitter for better syntax highlighting
  -- https://github.com/nvim-treesitter/nvim-treesitter
  "nvim-treesitter/nvim-treesitter",
  commit = "42fc28ba918343ebfd5565147a42a26580579482",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
  main = "nvim-treesitter.configs",
  config = function(_, opts)
    local install = require("nvim-treesitter.install")

    if vim.fn.has("win32") == 1 then
      install.compilers = { "zig", "cc", "gcc", "clang", "cl" }

      if vim.fn.executable("curl") == 1 and vim.fn.executable("tar") == 1 then
        install.prefer_git = false
      end
    end

    require("nvim-treesitter.configs").setup(opts)
  end,
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "c_sharp",
      "cmake",
      "cpp",
      "css",
      "csv",
      "diff",
      "dockerfile",
      "fish",
      "gitignore",
      "go",
      "gomod",
      "gosum",
      "gotmpl",
      "gowork",
      "graphql",
      "helm",
      "html",
      "javascript",
      "json",
      "lua",
      "make",
      "markdown",
      "markdown_inline",
      "php",
      "powershell",
      "python",
      "regex",
      "sql",
      "terraform",
      "tmux",
      "toml",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
      "zig",
    },
    auto_install = true,
    highlight = {
      enable = true,
      disable = function(_, buf)
        return vim.b[buf].large_file == true
      end,
    },
  },
}
