vim.pack.add({
  {
    src = "https://github.com/MeanderingProgrammer/render-markdown.nvim",
    name = "render-markdown.nvim",
    version = "main",
  },
}, {
  load = true,
  confirm = false,
})

require("render-markdown").setup({
  file_types = { "markdown" },
  win_options = {
    wrap = {
      default = vim.wo.wrap,
      rendered = true,
    },
    linebreak = {
      default = vim.wo.linebreak,
      rendered = true,
    },
    breakindent = {
      default = vim.wo.breakindent,
      rendered = true,
    },
  },
})
