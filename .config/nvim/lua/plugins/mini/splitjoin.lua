vim.pack.add({
  {
    src = "https://github.com/echasnovski/mini.splitjoin",
    name = "mini.splitjoin",
    version = "v0.17.0",
  },
}, {
  load = false, -- Don't load immediately
  confirm = false, -- Install without confirmation
})

local mini_splitjoin_group = vim.api.nvim_create_augroup("pack-mini-splitjoin", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = mini_splitjoin_group,
  once = true,
  callback = function()
    vim.cmd.packadd("mini.splitjoin")

    local splitjoin = require("mini.splitjoin")
    local map = vim.keymap.set

    local config = {
      mappings = {
        toggle = "gS",
      },
    }

    splitjoin.setup(config)

    require("mini.splitjoin").setup({})

    -- Keymaps
    map("n", "gS", function()
      require("mini.splitjoin").toggle()
    end, { desc = "Split/join code block", noremap = true, silent = true })
  end,
})
