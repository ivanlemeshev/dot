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
  "bashls",
  "biome",
  "buf_ls",
  "clangd",
  "denols",
  "dockerls",
  "gopls",
  "jsonls",
  "lemminx",
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
  "golangci-lint",
  "hadolint",
  "markdownlint",
  "tflint",
  "tfsec",
}

if vim.fn.has("win32") ~= 1 then
  table.insert(servers, 1, "ansible-language-server")
  table.insert(linters, "ansible-lint")
end

require("mason-tool-installer").setup({
  ensure_installed = vim
    .iter({ servers, formatters, linters })
    :flatten()
    :totable(),
})
