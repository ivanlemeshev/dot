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
    src = "https://github.com/nvim-mini/mini.hipatterns",
    name = "mini.hipatterns",
    version = "v0.17.0",
  },
}, {
  load = true, -- Load immediately
  confirm = false, -- Install without confirmation
})

local devicons = require("nvim-web-devicons")
local theme = require("lem.theme")
devicons.setup({ color_icons = true })
local icons = vim.deepcopy(devicons.get_icons())
local icon_colors = {}
for _, icon in pairs(icons) do
  local color = theme.icon_color(icon.color)
  icon_colors[icon.name] = math.min(icon_colors[icon.name] or color, color)
end
for _, icon in pairs(icons) do
  icon.cterm_color = tostring(icon_colors[icon.name])
  icon.color = nil
end
devicons.set_icon(icons)
devicons.set_default_icon("", nil, "7")

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
      group = "MiniHipatternsWarning",
    },
  },
})
