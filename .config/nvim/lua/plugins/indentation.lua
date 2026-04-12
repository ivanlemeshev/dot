local helpers = require("config.helpers")

vim.pack.add({
  {
    src = "https://github.com/echasnovski/mini.indentscope",
    name = "mini.indentscope",
    version = "v0.17.0",
  },
}, {
  load = false, -- Don't load immediately
  confirm = false, -- Install without confirmation
})

-- Disable mini.indentscope for certain filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "help",
    "mason",
    "NvimTree",
  },
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

-- Disable mini.indentscope for terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

-- Initialize mini.indentscope when a buffer is read or a new file is created
helpers.load_on(
  { "BufReadPost", "BufNewFile" },
  "pack-mini-indentscope",
  "mini.indentscope",
  function()
    local indentscope = require("mini.indentscope")

    indentscope.setup({
      symbol = "▏",
      options = {
        try_as_border = true,
      },
      draw = {
        animation = indentscope.gen_animation.none(),
      },
    })
  end
)
