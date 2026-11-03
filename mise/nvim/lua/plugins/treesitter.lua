local helpers = require("config.helpers")

vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    name = "nvim-treesitter",
    version = "main",
  },
}, {
  load = true, -- Load immediately
  confirm = false, -- Install without confirmation
})

local ensure_installed = {
  "bash",
  "c",
  "c_sharp",
  "cmake",
  "cpp",
  "css",
  "csv",
  "diff",
  "dockerfile",
  "fish",
  "gitignore",
  "go",
  "gomod",
  "gosum",
  "gotmpl",
  "gowork",
  "graphql",
  "helm",
  "html",
  "http",
  "javascript",
  "julia",
  "json",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "php",
  "powershell",
  "python",
  "racket",
  "regex",
  "rust",
  "sql",
  "terraform",
  "toml",
  "typescript",
  "tsx",
  "vim",
  "vimdoc",
  "yaml",
  "zig",
}

local treesitter = require("nvim-treesitter")
treesitter.setup({ install_dir = vim.fn.stdpath("data") .. "/site" })

local install_task = treesitter.install(ensure_installed)
if vim.env.MISE_TREESITTER_INSTALL == "1" then
  if not install_task:wait(300000) then
    error("Tree-sitter parser installation failed or timed out")
  end
end

vim.api.nvim_create_autocmd("FileType", {
  group = helpers.augroup("treesitter"),
  callback = function(args)
    -- Enable treesitter highlighting and disable regex syntax per buffer.
    pcall(vim.treesitter.start, args.buf)
    -- Enable treesitter-based indentation for this buffer.
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
