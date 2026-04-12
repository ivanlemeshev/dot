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

local conform_group =
  vim.api.nvim_create_augroup("pack-conform", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = conform_group,
  once = true,
  callback = function()
    vim.cmd.packadd("conform.nvim")

    require("conform").setup({
      formatters_by_ft = {
        c = { "clang_format" },
        go = { "gofumpt", "goimports" },
        javascript = { "biome" },
        json = { "biome" },
        lua = { "stylua" },
        markdown = { "prettier" },
        proto = { "buf" },
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
        sh = { "shfmt" },
        yaml = { "yamlfmt" },
      },
      formatters = {
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
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    })
  end,
})
