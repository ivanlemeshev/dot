-- NOTE: Other plugins need these helpers during setup.
vim.pack.add({
  {
    src = "https://github.com/nvim-lua/plenary.nvim",
    name = "plenary.nvim",
    version = "master",
  },
}, {
  load = true,
  confirm = false,
})
