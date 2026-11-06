local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
vim.opt.runtimepath:prepend(config_dir)

local ok, err = xpcall(function()
  dofile(config_dir .. "/init.lua")

  if vim.env.MISE_NVIM_VERIFY ~= "1" then
    require("mason-tool-installer").check_install(false, true)
  end

  local registry = require("mason-registry")
  local mappings = require("mason-lspconfig").get_mappings().lspconfig_to_package
  for _, name in ipairs(require("plugins.mason")) do
    local package_name = mappings[name] or name
    local package = registry.get_package(package_name)
    assert(package:is_installed(), "Missing tool: " .. package_name)
    assert(package:get_receipt():is_present(), "Missing tool receipt: " .. package_name)
  end

  local installed = require("nvim-treesitter.config").get_installed("parsers")
  for _, name in ipairs(require("plugins.treesitter")) do
    assert(vim.tbl_contains(installed, name), "Missing parser: " .. name)
    assert(vim.treesitter.language.add(name), "Cannot load parser: " .. name)
  end
end, debug.traceback)

if not ok then
  io.stderr:write(tostring(err) .. "\n")
  vim.cmd("cquit 1")
end
vim.cmd("qa!")
