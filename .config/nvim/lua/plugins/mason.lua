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

local servers = {
  "ansible-language-server",
  "bashls",
  "biome",
  "buf_ls",
  "clangd",
  "denols",
  "dockerls",
  "gopls",
  "jsonls",
  "lua_ls",
  "powershell_es",
  "pyright",
  "ruff",
  "terraformls",
  "typos_lsp",
  "yamlls",
  "zls",
}

local formatters = {
  "buf",
  "clang-format",
  "gofumpt",
  "goimports",
  "golines",
  "prettier",
  "shfmt",
  "stylua",
  "yamlfmt",
}

local linters = {
  "ansible-lint",
  "golangci-lint",
  "hadolint",
  "markdownlint",
  "tflint",
  "tfsec",
}

require("mason-tool-installer").setup({
  ensure_installed = vim
    .iter({ servers, formatters, linters })
    :flatten()
    :totable(),
})
