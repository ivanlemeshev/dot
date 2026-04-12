vim.pack.add({
  {
    src = "https://github.com/nvim-tree/nvim-web-devicons",
    name = "nvim-web-devicons",
    version = "master",
  },
  {
    src = "https://github.com/j-hui/fidget.nvim",
    name = "fidget.nvim",
    version = "v1.6.1",
  },
  {
    src = "https://github.com/folke/which-key.nvim",
    name = "which-key.nvim",
    version = "v3.17.0",
  },
  {
    src = "https://github.com/echasnovski/mini.hipatterns",
    name = "mini.hipatterns",
    version = "v0.17.0",
  },
}, {
  load = true, -- Load immediately
  confirm = false, -- Install without confirmation
})

require("fidget").setup({})

require("which-key").setup({
  icons = {
    mappings = false,
  },
  win = {
    border = "single",
  },
})

require("mini.hipatterns").setup({
  highlighters = {
    fixme = {
      pattern = "%f[%w]()FIXME()%f[%W]",
      group = "MiniHipatternsFixme",
    },
    hack = {
      pattern = "%f[%w]()HACK()%f[%W]",
      group = "MiniHipatternsHack",
    },
    todo = {
      pattern = "%f[%w]()TODO()%f[%W]",
      group = "MiniHipatternsTodo",
    },
    note = {
      pattern = "%f[%w]()NOTE()%f[%W]",
      group = "MiniHipatternsNote",
    },
    warning = {
      pattern = "%f[%w]()WARNING()%f[%W]",
      group = "MiniHipatternsFixme",
    },
    hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
  },
})
