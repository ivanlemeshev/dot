local helpers = require("config.helpers")

-- Re-assert the save mapping after plugins load so it cannot be shadowed by a
-- filetype/plugin-specific mapping.
helpers.nmap("<leader>w", "<cmd>write<CR>", "Save the current buffer")
