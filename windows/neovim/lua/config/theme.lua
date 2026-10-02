local config_path = vim.uv.fs_realpath(vim.fn.stdpath("config"))
if not config_path then
  error("Unable to resolve the Windows Neovim config link")
end

local repo_root = vim.fs.dirname(vim.fs.dirname(config_path))
local theme_path = vim.fs.joinpath(
  repo_root,
  ".config",
  "nvim",
  "lua",
  "lem",
  "theme.lua"
)
local theme = dofile(theme_path)
theme.setup()

return theme
