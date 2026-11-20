local helpers = require("config.helpers")

vim.pack.add({
  {
    src = "https://github.com/nvim-mini/mini.indentscope",
    name = "mini.indentscope",
    version = "v0.17.0",
  },
  {
    src = "https://github.com/lukas-reineke/indent-blankline.nvim",
    name = "indent-blankline.nvim",
    version = "v3.9.1",
  },
}, {
  load = false,
  confirm = false,
})

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

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.b.miniindentscope_disable = true
  end,
})

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

require("ibl").setup({
  indent = {
    char = "▏",
    tab_char = "▏",
    smart_indent_cap = true,
  },
  scope = {
    show_start = false,
    show_end = false,
  },
})
