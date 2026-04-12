vim.pack.add({
  {
    src = "https://github.com/lukas-reineke/indent-blankline.nvim",
    name = "indent-blankline.nvim",
    version = "v3.9.1",
  },
  {
    src = "https://github.com/echasnovski/mini.indentscope",
    name = "mini.indentscope",
    version = "v0.17.0",
  },
}, {
  load = false, -- Don't load immediately
  confirm = false, -- Install without confirmation
})

local indent_blankline_group = vim.api.nvim_create_augroup("pack-indent-blankline", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = indent_blankline_group,
  once = true,
  callback = function()
    vim.cmd.packadd("indent-blankline.nvim")
    require("ibl").setup({
      indent = {
        char = "▏",
        tab_char = "▏",
      },
      exclude = {
        filetypes = {
          "help",
        },
        buftypes = {
          "terminal",
        },
      },
      scope = {
        enabled = false,
      },
    })
  end,
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

    indentscope.setup({
      symbol = "▏",
      options = {
        try_as_border = true,
      },
      draw = {
        animation = indentscope.gen_animation.none(),
      },
    })
  end,
})
