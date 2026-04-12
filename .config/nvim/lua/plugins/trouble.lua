vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
    name = "nvim-web-devicons",
    version = "master",
  },
  {
    src = "https://github.com/folke/trouble.nvim",
    name = "trouble.nvim",
    version = "v3.7.1",
  },
}, {
  load = true, -- Load the plugin immediately
  confirm = false, -- Install without confirmation
})

require("trouble").setup({
  focus = true,
  modes = {
    diagnostics = {
      auto_close = true,
    },
  },
})

-- Keymaps
local map = vim.keymap.set

map(
  "n",
  "<leader>dd",
  "<cmd>Trouble diagnostics toggle<CR>",
  { desc = "Trouble: toggle diagnostics panel", noremap = true, silent = true }
)

map(
  "n",
  "<leader>dc",
  "<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
  { desc = "Trouble: toggle buffer diagnostics", noremap = true, silent = true }
)
