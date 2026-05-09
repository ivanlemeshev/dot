local function is_docker()
  return vim.uv.fs_stat("/.dockerenv") ~= nil
    or vim.uv.fs_stat("/run/.containerenv") ~= nil
end

local function ensure_pack_lockfile_writable()
  local config_home = vim.fn.fnamemodify(vim.fn.stdpath("config"), ":h")
  local lockfile = config_home .. "/nvim-pack-lock.json"

  if vim.fn.filewritable(lockfile) == 1 then
    return
  end

  if not is_docker() then
    return
  end

  local fallback_config_home = vim.fn.stdpath("state") .. "/xdg-config"
  vim.fn.mkdir(fallback_config_home, "p")
  vim.env.XDG_CONFIG_HOME = fallback_config_home
end

ensure_pack_lockfile_writable()

local plugin_modules = {
  "plugins.lem",
  "plugins.essentials",
  "plugins.ui",
  "plugins.mason",
  "plugins.autocomplete",
  "plugins.search",
  "plugins.lsp",
  "plugins.explorer",
  "plugins.git",
  "plugins.formatting",
  "plugins.linting",
  "plugins.editing",
  "plugins.indentation",
  "plugins.diagnostics",
  "plugins.filetypes",
  "plugins.treesitter",
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
