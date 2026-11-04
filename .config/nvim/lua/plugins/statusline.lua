vim.pack.add({
  {
    src = "https://github.com/nvim-lualine/lualine.nvim",
    name = "lualine.nvim",
    version = "master",
  },
}, {
  load = true, -- Load immediately
  confirm = false, -- Install without confirmation
})

local mode = {
  "mode",
  fmt = function(str)
    return " " .. str
  end,
}

local filename = {
  "filename",
  file_status = true,
  path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
}

local theme = require("lem.theme")

local branch = {
  "branch",
  icon = "",
  color = require("lem.git_status").color,
}

local diagnostic_colors = {}
for name, severity in pairs({
  error = vim.diagnostic.severity.ERROR,
  warn = vim.diagnostic.severity.WARN,
  info = vim.diagnostic.severity.INFO,
  hint = vim.diagnostic.severity.HINT,
}) do
  diagnostic_colors[name] = function()
    local count = vim.diagnostic.count(0)[severity] or 0
    return {
      fg = count > 0 and theme.diagnostic[name] or theme.statusline.inactive_fg,
      bg = theme.statusline.section_bg,
    }
  end
end

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn", "info", "hint" },
  symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
  colored = true,
  diagnostics_color = diagnostic_colors,
  update_in_insert = true,
  always_visible = true,
}

local function human_file_size()
  local path = vim.api.nvim_buf_get_name(0)
  if path == "" or vim.bo.buftype ~= "" then
    return ""
  end

  local size = vim.fn.getfsize(path)
  if size < 0 then
    return ""
  end

  if size < 1024 then
    return string.format("%d B", size)
  end

  local units = { "KB", "MB", "GB", "TB" }
  local value = size
  local unit_index = 0

  while value >= 1024 and unit_index < #units do
    value = value / 1024
    unit_index = unit_index + 1
  end

  if value >= 10 or unit_index == 1 then
    return string.format("%.0f %s", value, units[unit_index])
  end

  return string.format("%.1f %s", value, units[unit_index])
end

local function visible_encoding()
  if vim.bo.binary then
    return ""
  end

  return vim.opt_local.fileencoding:get()
end

local diff = {
  "diff",
  colored = false,
  sections = { "added", "modified", "removed" },
  symbols = { added = " ", modified = " ", removed = " " },
}

require("lualine").setup({
  options = {
    theme = theme.lualine_theme,
    icons_enabled = true,
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    always_divide_middle = true,
    disabled_filetypes = {
      "NvimTree",
    },
  },
  -- +-------------------------------------------------+
  -- | A | B | C                             X | Y | Z |
  -- +-------------------------------------------------+
  sections = {
    lualine_a = { mode },
    lualine_b = { branch, diff, filename },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {
      diagnostics,
      human_file_size,
      visible_encoding,
      "filetype",
      "location",
    },
    lualine_z = { "progress" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = {},
  },
})
