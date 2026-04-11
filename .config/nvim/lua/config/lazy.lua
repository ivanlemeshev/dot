-- Bootstrap github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim is installed, if not, clone it from GitHub
---@diagnostic disable-next-line: undefined-field
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

local is_windows = vim.fn.has("win32") == 1
local windows_full = vim.env.NVIM_WINDOWS_FULL == "1"
local spec = {
  { import = "plugins" },
}

if is_windows and not windows_full then
  spec = {
    { import = "plugins.lem" },
    { import = "plugins.lualine" },
    { import = "plugins.indent-blankline" },
    { import = "plugins.mini" },
    { import = "plugins.misc" },
    { import = "plugins.file-explorer" },
  }
end

-- Setup lazy.nvim
require("lazy").setup({
  defaults = { lazy = true },
  spec = spec,
  -- Disable automatic checking for plugin updates
  checker = { enabled = false, notify = false },
  ui = { border = "single" },
})
