local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
vim.opt.runtimepath:prepend(config_dir)

local ok, err = xpcall(function()
  dofile(config_dir .. "/init.lua")

  if vim.env.MISE_NVIM_VERIFY ~= "1" then
    local complete = false
    vim.api.nvim_create_autocmd("User", {
      pattern = "MasonToolsUpdateCompleted",
      once = true,
      callback = function()
        complete = true
      end,
    })
    require("mason-tool-installer").check_install(false, false)
    if not vim.wait(900000, function()
      return complete
    end, 100) then
      local registry = require("mason-registry")
      local mappings = require("mason-lspconfig").get_mappings().lspconfig_to_package
      local pending = {}
      for _, name in ipairs(require("plugins.mason")) do
        local package_name = mappings[name] or name
        if not registry.has_package(package_name) then
          table.insert(pending, package_name)
        else
          local package = registry.get_package(package_name)
          if
            package:is_installing()
            or not package:is_installed()
            or not package:get_receipt():is_present()
          then
            table.insert(pending, package_name)
          end
        end
      end
      local detail = #pending > 0 and table.concat(pending, ", ")
        or "none; installer completion event is missing"
      error("Mason installation exceeds 15 minutes. Pending tools: " .. detail)
    end
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
    local loaded, load_error = vim.treesitter.language.add(name)
    assert(loaded, "Cannot load parser: " .. name .. ": " .. tostring(load_error))
  end
end, debug.traceback)

if not ok then
  io.stderr:write(tostring(err) .. "\n")
  vim.cmd("cquit 1")
end
vim.cmd("qa!")
