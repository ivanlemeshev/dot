local M = {}

-- Fzf
M.fzf = {
  fg = "#c5c8c6",
  bg = "#1d1f21",
  hl = "#f0c674",
  ["fg+"] = "#ffffff",
  ["bg+"] = "#373b41",
  ["hl+"] = "#f0c674",
  info = "#81a2be",
  border = "#969896",
  query = "#c5c8c6",
  prompt = "#de935f",
  pointer = "#de935f",
  marker = "#81a2be",
  spinner = "#de935f",
  header = "#969896",
  label = "#c5c8c6",
  gutter = "#1d1f21",
}

-- StatusLine
M.statusline = {
  normal_bg = "#c5c8c6",
  normal_fg = "#1d1f21",
  insert_bg = "#b5bd68",
  insert_fg = "#1d1f21",
  visual_bg = "#b294bb",
  visual_fg = "#1d1f21",
  replace_bg = "#cc6666",
  replace_fg = "#1d1f21",
  command_bg = "#de935f",
  command_fg = "#1d1f21",
  terminal_bg = "#81a2be",
  terminal_fg = "#1d1f21",
  section_bg = "#282a2e",
  section_fg = "#c5c8c6",
  inactive_bg = "#282a2e",
  inactive_fg = "#c5c8c6",
}

-- lualine theme
M.lualine_theme = {
  normal = {
    a = { bg = M.statusline.normal_bg, fg = M.statusline.normal_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.normal_bg, fg = M.statusline.normal_fg },
  },
  insert = {
    a = { bg = M.statusline.insert_bg, fg = M.statusline.insert_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.insert_bg, fg = M.statusline.insert_fg },
  },
  visual = {
    a = { bg = M.statusline.visual_bg, fg = M.statusline.visual_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.visual_bg, fg = M.statusline.visual_fg },
  },
  replace = {
    a = { bg = M.statusline.replace_bg, fg = M.statusline.replace_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.replace_bg, fg = M.statusline.replace_fg },
  },
  command = {
    a = { bg = M.statusline.command_bg, fg = M.statusline.command_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.command_bg, fg = M.statusline.command_fg },
  },
  terminal = {
    a = { bg = M.statusline.terminal_bg, fg = M.statusline.terminal_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.terminal_bg, fg = M.statusline.terminal_fg },
  },
  inactive = {
    a = { bg = M.statusline.inactive_bg, fg = M.statusline.inactive_fg },
    b = { bg = M.statusline.inactive_bg, fg = M.statusline.inactive_fg },
    c = { bg = M.statusline.inactive_bg, fg = M.statusline.inactive_fg },
    z = { bg = M.statusline.inactive_bg, fg = M.statusline.inactive_fg },
  },
}

function M.setup() end

return M
