return {
  "nvimtools/none-ls.nvim",
  lazy = false,
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "jayp0521/mason-null-ls.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    local ensure_installed = {
      "buf", -- buf
      "clang_format", -- c/c++
      "gofumpt", -- go
      "goimports", -- go
      "hadolint", -- docker
      "markdownlint", -- markdown
      "prettier", -- markdown, json
      "ruff", -- python
      "shfmt", -- bash
      "stylua", -- lua
      "tfsec", -- terraform
    }

    require("mason-null-ls").setup({
      ensure_installed = ensure_installed,
      automatic_installation = true,
    })

    local sources = {
      formatting.buf,
      formatting.clang_format,
      formatting.gofumpt,
      formatting.goimports,
      formatting.prettier.with({
        filetypes = { "markdown", "json" },
      }),
      formatting.shfmt.with({
        filetypes = { "sh" },
        -- To get the formatting appropriate for Google's Style guide,
        -- use shfmt -i 2 -ci.
        -- https://google.github.io/styleguide/shellguide.html
        args = { "-filename", "$FILENAME", "-i", "2", "-ci" },
      }),
      formatting.stylua,
      diagnostics.hadolint,
      diagnostics.markdownlint,
      diagnostics.tfsec,
    }

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    null_ls.setup({
      sources = sources,
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                async = false,
                filter = function(formatter_client)
                  return formatter_client.name == "null-ls"
                end,
              })
            end,
          })
        end
      end,
    })
  end,
}
