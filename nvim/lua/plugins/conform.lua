return {
  "stevearc/conform.nvim",
  lazy = false,
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        c = { "clang_format" },
        go = {
          "gofumpt",
          "goimports",
          -- "golangci-lint", -- TODO
          -- "golines",
        },
        javascript = { "biome" },
        json = { "biome" },
        lua = { "stylua" },
        markdown = { "prettier" },
        proto = { "buf" },
        python = {
          "ruff_fix",
          "ruff_format",
          "ruff_organize_imports",
        },
        sh = { "shfmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end,
}

-- TODO: configure shfmt to use Google's Style guide
--   formatting.shfmt.with({
--     filetypes = { "sh" },
--     -- To get the formatting appropriate for Google's Style guide,
--     -- use shfmt -i 2 -ci.
--     -- https://google.github.io/styleguide/shellguide.html
--     args = { "-filename", "$FILENAME", "-i", "2", "-ci" },
--   }),
