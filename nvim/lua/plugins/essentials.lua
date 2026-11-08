vim.pack.add({
  {
    -- A collection of Lua helper functions used by other plugins.
    src = "https://github.com/nvim-lua/plenary.nvim",
    name = "plenary.nvim",
    version = "master",
  },
}, {
  load = true, -- Load immediately for plugins that depend on shared Lua helpers
  confirm = false, -- Install without confirmation
})
