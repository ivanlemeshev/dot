vim.pack.add({
  {
    src = "https://github.com/lewis6991/gitsigns.nvim",
    name = "gitsigns.nvim",
    version = "v2.1.0",
  },
}, {
  load = false, -- Don't load immediately
  confirm = false, -- Install without confirmation
})

local gitsigns_group =
  vim.api.nvim_create_augroup("pack-gitsigns", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
  group = gitsigns_group,
  once = true,
  callback = function()
    vim.cmd.packadd("gitsigns.nvim")

    require("gitsigns").setup({
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 1000,
      },
    })

    -- Keymaps
    local map = vim.keymap.set

    map(
      "n",
      "<leader>gb",
      "<cmd>Gitsigns blame_line<CR>",
      { desc = "Git: blame line", noremap = true, silent = true }
    )
  end,
})
