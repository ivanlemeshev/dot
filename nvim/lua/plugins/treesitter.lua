return {
  "nvim-treesitter/nvim-treesitter",
  event = "BufRead",
  build = ":TSUpdate",
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      "bash",
      "c",
      "c_sharp",
      "cmake",
      "cpp",
      "csv",
      "css",
      "bash",
      "diff",
      "dockerfile",
      "gitignore",
      "fish",
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
      use_languagetree = true,
    },
    indent = { enable = true },
  },
}
