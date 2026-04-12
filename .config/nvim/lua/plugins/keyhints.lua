vim.pack.add({
  {
    src = "https://github.com/folke/which-key.nvim",
    name = "which-key.nvim",
    version = "3aab2147e74890957785941f0c1ad87d0a44c15a",
  },
}, {
  load = true, -- Load immediately
  confirm = false, -- Install without confirmation
})

require("which-key").setup({
  icons = {
    mappings = false,
  },
  win = {
    border = "single",
  },
})
