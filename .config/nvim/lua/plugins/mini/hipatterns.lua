vim.pack.add({
  {
    src = "https://github.com/echasnovski/mini.hipatterns",
    name = "mini.hipatterns",
    version = "v0.17.0",
  },
}, {
  load = false, -- Don't load immediately
  confirm = false, -- Install without confirmation
})

local mini_hipatterns_group = vim.api.nvim_create_augroup("pack-mini-hipatterns", { clear = true })

-- Initialize mini.hipatterns when a buffer is read or a new file is created
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = mini_hipatterns_group,
  once = true,
  callback = function()
    vim.cmd.packadd("mini.hipatterns")

    local hipatterns = require("mini.hipatterns")

    hipatterns.setup({
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
        hex_color = hipatterns.gen_highlighter.hex_color(),
      },
    })
  end,
})
