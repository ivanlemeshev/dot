vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
    name = "nvim-web-devicons",
    version = "master",
  },
}, {
  load = true, -- Load immediately for UI plugins that depend on icons
  confirm = false, -- Install without confirmation
})
