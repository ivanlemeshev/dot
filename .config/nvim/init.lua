require("config.options")
require("config.keymaps")

local minimal = vim.env.NVIM_MINIMAL == "1"

if not minimal then
  require("config.lazy")
end
