vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"

-- The leader key is a prefix used in combination with other keys to create
-- custom shortcuts. Any subsequent key mappings that use <leader> will require
-- pressing the space bar first.
vim.g.mapleader = " "

-- The local leader key functions similarly to the global leader key, acting as
-- a prefix for key mappings. However, the local leader key can be different in
-- each buffer, allowing for buffer-specific shortcuts.
vim.g.maplocalleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
