vim.pack.add({
  {
    src = "https://github.com/bjarneo/pixel.nvim",
    name = "pixel.nvim",
    version = "main",
  },
}, {
  load = true,
  confirm = false,
})

vim.cmd.colorscheme("pixel")
