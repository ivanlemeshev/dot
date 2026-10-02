vim.pack.add({
  {
    src = "https://github.com/folke/which-key.nvim",
    name = "which-key.nvim",
    version = "v3.17.0",
  },
}, {
  load = true,
  confirm = false,
})

require("which-key").setup({
  icons = {
    mappings = false,
  },
  win = {
    border = "single",
  },
})
