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
  "javascript",
  "json",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "php",
  "powershell",
  "python",
  "regex",
  "sql",
  "terraform",
  "tmux",
  "toml",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "zig",
}

local already_installed = require("nvim-treesitter.config").get_installed()
local parsers_to_install = vim
  .iter(ensure_installed)
  :filter(function(parser)
    return not vim.tbl_contains(already_installed, parser)
  end)
  :totable()

if #parsers_to_install > 0 then
  require("nvim-treesitter").install(parsers_to_install)
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
