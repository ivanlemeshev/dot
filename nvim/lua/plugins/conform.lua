return {
  -- Formatting plugin
  -- https://github.com/stevearc/conform.nvim
  "stevearc/conform.nvim",
  lazy = false,
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        c = { "clang_format" },
        go = {
          "gofumpt",
          "goimports",
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
      formatters = {
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
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end,
}
