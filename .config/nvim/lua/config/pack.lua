local plugin_modules = {
  "plugins.lem",
  "plugins.ui",
  "plugins.essentials",
  "plugins.mason",
  "plugins.autocomplete",
  "plugins.lsp",
  "plugins.search",
  "plugins.explorer",
  "plugins.git",
  "plugins.formatting",
  "plugins.linting",
  "plugins.editing",
  "plugins.indentation",
  "plugins.diagnostics",
  "plugins.filetypes",
  "plugins.http",
  "plugins.copilot",
  "plugins.statusline",
}

for _, module in ipairs(plugin_modules) do
  local ok, err = pcall(require, module)
  if not ok then
    error(("Failed to load %s: %s"):format(module, err))
  end
end
