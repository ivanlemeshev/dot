vim.pack.add({
  {
    src = "https://github.com/mason-org/mason.nvim",
    name = "mason.nvim",
    version = "v2.2.1",
  },
  {
    src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
    name = "mason-tool-installer.nvim",
    version = "main",
  },
  {
    src = "https://github.com/mason-org/mason-lspconfig.nvim",
    name = "mason-lspconfig.nvim",
    version = "v2.1.0",
  },
}, {
  load = true, -- Load immediately
  confirm = false, -- Install without confirmation
})

require("mason").setup({
  ui = {
    border = "single",
  },
})

require("mason-tool-installer").setup({
  ensure_installed = {
    -- LSP servers
    "ansible-language-server", -- Ansible
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
    "ansible-lint", -- Ansible
    "golangci-lint", -- Go
    "hadolint", -- Docker
    "markdownlint", -- Markdown
    "tflint", -- Terraform
    "tfsec", -- Terraform
  },
})
