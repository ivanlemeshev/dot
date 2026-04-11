require("config.options")
require("config.keymaps")

local is_windows = vim.fn.has("win32") == 1
local minimal = vim.env.NVIM_MINIMAL == "1"
local windows_full = vim.env.NVIM_WINDOWS_FULL == "1"

if not minimal and (not is_windows or windows_full) then
  require("config.lazy")
end
