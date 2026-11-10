-- NOTE: config/local.lua holds machine data and is not in Git.
pcall(require, "config.local")
require("config.options")
require("config.autocmds")
require("config.diagnostics")
require("config.large_files")
require("config.keymaps")
require("config.filetype_options")
require("config.pack")
