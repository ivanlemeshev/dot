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

local mini_indentscope_group = vim.api.nvim_create_augroup("pack-mini-indentscope", { clear = true })

-- Initialize mini.indentscope when a buffer is read or a new file is created
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = mini_indentscope_group,
  once = true,
  callback = function()
    vim.cmd.packadd("mini.indentscope")

    local indentscope = require("mini.indentscope")

    local config = {
      symbol = "▏",
      options = {
        try_as_border = true,
      },
      draw = {
        animation = indentscope.gen_animation.none(),
      },
    }

    indentscope.setup(config)
  end,
})
