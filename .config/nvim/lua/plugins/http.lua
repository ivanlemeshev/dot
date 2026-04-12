local helpers = require("config.helpers")

vim.pack.add({
  {
    src = "https://github.com/mistweaverco/kulala.nvim",
    name = "kulala.nvim",
    version = "v5.3.4",
  },
}, {
  load = false, -- Don't load immediately
  confirm = false, -- Install without confirmation
})

helpers.load_on("FileType", "pack-kulala", "kulala.nvim", function()
  require("kulala").setup({
    global_keymaps = true,
    global_keymaps_prefix = "<leader>R",
    kulala_keymaps_prefix = "",
  })
end, {
  pattern = { "http", "rest" },
})
