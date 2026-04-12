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

local editing_group = vim.api.nvim_create_augroup("pack-editing", { clear = true })

vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
  group = editing_group,
  once = true,
  callback = function()
    vim.cmd.packadd("vim-surround")
    vim.cmd.packadd("mini.move")
    vim.cmd.packadd("emoji.nvim")
    vim.cmd.packadd("mini.splitjoin")

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

    -- Kaymaps
    local map = vim.keymap.set

    map("n", "gS", function()
      require("mini.splitjoin").toggle()
    end, { desc = "Split/join code block", noremap = true, silent = true })
  end,
})
