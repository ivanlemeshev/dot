local helpers = require("config.helpers")

vim.pack.add({
  {
    src = "https://github.com/tpope/vim-surround",
    name = "vim-surround",
    version = "v2.2",
  },
  {
    src = "https://github.com/echasnovski/mini.move",
    name = "mini.move",
    version = "v0.17.0",
  },
  {
    src = "https://github.com/echasnovski/mini.splitjoin",
    name = "mini.splitjoin",
    version = "v0.17.0",
  },
  {
    src = "https://github.com/allaman/emoji.nvim",
    name = "emoji.nvim",
    version = "v6.0.2",
  },
}, {
  load = false, -- Don't load immediately
  confirm = false, -- Install without confirmation
})

helpers.load_on({ "BufReadPost", "BufNewFile" }, "pack-editing", {
  "vim-surround",
  "mini.move",
  "emoji.nvim",
  "mini.splitjoin",
}, function()
  require("mini.move").setup({})

  require("emoji").setup({
    enable_cmp_integration = true,
    plugin_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/",
  })

  require("mini.splitjoin").setup({
    mappings = {
      toggle = "gS",
    },
  })

  helpers.nmap("gS", function()
    require("mini.splitjoin").toggle()
  end, "Split/join code block")
end)
