local helpers = require("config.helpers")

vim.pack.add({
  {
    src = "https://github.com/folke/snacks.nvim",
    name = "snacks.nvim",
    version = "v2.31.0",
  },
}, {
  load = true,
  confirm = false,
})

require("snacks").setup({
  terminal = {
    win = {
      position = "float",
      border = "single",
      backdrop = false,
    },
  },
})

local function toggle_terminal()
  require("snacks").terminal()
end

helpers.map({ "n", "t" }, "<C-/>", toggle_terminal, "Toggle terminal")
helpers.map({ "n", "t" }, "<C-_>", toggle_terminal, "Toggle terminal")
