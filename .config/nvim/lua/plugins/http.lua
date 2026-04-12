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

local kulala_group =
  vim.api.nvim_create_augroup("pack-kulala", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = kulala_group,
  pattern = { "http", "rest" },
  once = true,
  callback = function()
    vim.cmd.packadd("kulala.nvim")

    require("kulala").setup({
      global_keymaps = true,
      global_keymaps_prefix = "<leader>R",
      kulala_keymaps_prefix = "",
    })
  end,
})
