local helpers = require("config.helpers")

vim.pack.add({
  {
    src = "https://github.com/stevearc/conform.nvim",
    name = "conform.nvim",
    version = "v9.1.0",
  },
}, {
  load = false, -- Don't load immediately
  confirm = false, -- Install without confirmation
})

helpers.load_on(
  { "BufReadPost", "BufNewFile" },
  "pack-conform",
  "conform.nvim",
  function()
    local julia_bin = vim.fn.expand("~/.julia/bin")
    local path_separator = vim.fn.has("win32") == 1 and ";" or ":"
    vim.env.PATH = vim.env.PATH .. path_separator .. julia_bin

    require("conform").setup({
      formatters_by_ft = {
        c = { "clang_format" },
        cpp = { "clang_format" },
        go = { "gofumpt", "goimports" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        proto = { "buf" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        racket = { "raco_fmt" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        julia = { "runic" },
        typescript = { "biome" },
        typescriptreact = { "biome" },
        yaml = { "yamlfmt" },
      },
      formatters = {
        clang_format = {
          args = { "--style=LLVM", "--assume-filename", "$FILENAME" },
        },
        raco_fmt = {
          command = "raco",
          args = { "fmt" },
        },
        runic = { command = "runic" },
        prettier = {
          prepend_args = { "--prose-wrap", "preserve" },
        },
        yamlfmt = {
          command = "yamlfmt",
          args = { "-formatter", "retain_line_breaks=true", "indent=2", "-" },
        },
        -- To get the formatting appropriate for Google's Style guide,
        -- use shfmt -i 2 -ci.
        -- https://google.github.io/styleguide/shellguide.html
        shfmt = {
          inherit = false,
          command = "shfmt",
          args = { "-filename", "$FILENAME", "-i", "2", "-ci" },
        },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_format = "fallback",
      },
    })
  end
)
