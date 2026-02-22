return {
  "williamboman/mason.nvim",
  commit = "44d1e90e1f66e077268191e3ee9d2ac97cc18e65",
  dependencies = {
    { "WhoIsSethDaniel/mason-tool-installer.nvim", commit = "443f1ef8b5e6bf47045cb2217b6f748a223cf7dc" },
  },
  config = function()
    local mason = require("mason")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        border = "single",
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
        "jsonls", -- JSON
        "lua_ls", -- Lua
        "powershell_es", -- PowerShell
        "pyright", -- Python
        "ruff", -- Python
        "terraformls", -- Terraform
        "typos_lsp", -- Spell checker
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
