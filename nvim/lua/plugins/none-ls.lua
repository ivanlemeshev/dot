return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "jayp0521/mason-null-ls.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    local ensure_installed = {
      "ansiblelint", -- ansible
      "buf", -- buf
      "golangci-lint", -- go
      "gofumpt", -- go
      "goimports", -- go
      "golines", -- go
      "hadolint", -- docker
      "markdownlint", -- markdown
      "prettier", -- markdown, json
      "pyink", -- python
      "pylint", -- python
      "shfmt", -- bash
      "stylua", -- lua
      "terraform_fmt", -- terraform
      "terraform_validate", -- terraform
      "tfsec", -- terraform
      "yamllint", -- yaml
    }

    require("mason-null-ls").setup({
      ensure_installed = ensure_installed,
      automatic_installation = true,
    })

    local sources = {
      formatting.buf,
      formatting.gofumpt,
      formatting.goimports,
      formatting.golines.with({
        condition = function(utils)
          -- TODO: Think about a better way to disable it only for particular projects.
          return false
        end,
      }),
      formatting.prettier.with({
        filetypes = { "markdown", "json" },
      }),
      formatting.pyink,
      formatting.shfmt,
      formatting.stylua,
      formatting.terraform_fmt,

      diagnostics.ansiblelint,
      diagnostics.golangci_lint,
      diagnostics.hadolint,
      diagnostics.markdownlint,
      diagnostics.pylint,
      diagnostics.terraform_validate,
      diagnostics.tfsec,
      diagnostics.yamllint,
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
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end,
    })
  end,
}
