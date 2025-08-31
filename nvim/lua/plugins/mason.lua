return {
  "williamboman/mason.nvim",
  dependencies = {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
    mason_tool_installer.setup({
      ensure_installed = {
        -- LSP servers
        "bashls", -- bash
        "biome", -- JSON, JavaScript
        "buf_ls", -- Protobuf
        "clangd", -- C/C++
        "denols", -- JavaScript, TypeScript
        "dockerls", -- Docker
        "gopls", -- Go
        "harper_ls", -- Grammar checker, https://writewithharper.com/docs/integrations/neovim
        "jsonls", -- JSON
        "lua_ls", -- Lua
        "powershell_es", -- PowerShell
        "pyright", -- Python
        "ruff", -- Python
        "terraformls", -- Terraform
        "yamlls", -- YAML
        "zls", -- Zig
        -- Formatters
        "buf", -- Protobuf
        "clang-format", -- C/C++
        "gofumpt", -- Go
        "goimports", -- Go
        "golines", -- Go
        "prettier", -- Markdown
        "shfmt", -- Bash
        "stylua", -- Lua
        "yamlfmt", -- YAML
        -- Linters
        "golangci-lint", -- Go
        "hadolint", -- Docker
        "markdownlint", -- Markdown
        "tflint", -- Terraform
        "tfsec", -- Terraform
      },
    })
  end,
}
