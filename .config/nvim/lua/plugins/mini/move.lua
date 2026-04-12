vim.pack.add({
  {
    src = "https://github.com/echasnovski/mini.move",
    name = "mini.move",
    version = "v0.17.0",
  },
}, {
  load = false, -- Don't load immediately
  confirm = false, -- Install without confirmation
})

local mini_move_group = vim.api.nvim_create_augroup("pack-mini-move", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = mini_move_group,
  once = true,
  callback = function()
    vim.cmd.packadd("mini.move")
    require("mini.move").setup({})
  end,
})
