--- *lem.theme* Centralized color definitions for Neovim themes and plugins
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev
local M = {}

-- UI
M.ui = {
  bg = "#1d1f21",
  color_column = "#373b41",
  cursor = "#c5c8c6",
  cursor_column = "#373b41",
  cursor_line = "#373b41",
  cursor_line_nr = "#373b41",
  fg = "#c5c8c6",
  line_nr = "#c5c8c6",
  non_text = "#969896",
  special_key = "#282a2e",
  whitespace = "#282a2e",
}

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

function M.setup()
  local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  -- ============================================================================
  -- Neovim UI
  -- ============================================================================

  -- `Normal` is the default text area for the current window.
  hl("Normal", { fg = M.ui.fg, bg = M.ui.bg })

  -- `NormalNC` is the default text area for inactive windows.
  hl("NormalNC", { fg = M.ui.fg, bg = M.ui.bg })

  -- `Cursor` is the visual caret in the active window.
  hl("Cursor", { fg = M.ui.bg, bg = M.ui.cursor })

  -- `CursorLine` highlights the current line. TODO
  hl("CursorLine", { bg = M.ui.cursor_line })

  -- `CursorColumn` highlights the current cursor column. TODO
  hl("CursorColumn", { bg = M.ui.cursor_column })

  -- `CursorLineNr` highlights the number on the current line.
  hl("CursorLineNr", { bg = M.ui.cursor_line_nr, bold = true })

  -- `ColorColumn` marks preferred text width columns.
  hl("ColorColumn", { bg = M.ui.color_column })

  -- `LineNr` is the line number gutter for non-current lines.
  hl("LineNr", { fg = M.ui.line_nr })

  -- `SignColumn` holds signs such as diagnostics and git marks.
  hl("SignColumn", { fg = M.ui.fg, bg = M.ui.bg })

  -- `FoldColumn` shows fold markers.
  hl("FoldColumn", { fg = M.ui.fg, bg = M.ui.bg })

  -- `Folded` is used for folded text lines.
  -- hl("Folded", {})

  -- `Search` highlights the last search match.
  -- hl("Search", {})

  -- `CurSearch` highlights the current search match under the cursor.
  -- hl("CurSearch", {})

  -- `IncSearch` highlights incremental search matches.
  -- hl("IncSearch", {})

  -- `Visual` highlights visual selections.
  -- hl("Visual", {})

  -- `VisualNOS` highlights visual selections when not owned by Vim.
  -- hl("VisualNOS", {})

  -- `Pmenu` styles popup menu entries.
  -- hl("Pmenu", {})

  -- `PmenuSel` styles the selected popup menu entry.
  -- hl("PmenuSel", {})

  -- `PmenuSbar` styles the popup menu scrollbar track.
  -- hl("PmenuSbar", {})

  -- `PmenuThumb` styles the popup menu scrollbar thumb.
  -- hl("PmenuThumb", {})

  -- `NormalFloat` is the base background for floating windows.
  -- hl("NormalFloat", {})

  -- `FloatBorder` is the border around floating windows.
  -- hl("FloatBorder", {})

  -- `FloatTitle` is the title of floating windows.
  -- hl("FloatTitle", {})

  -- `StatusLine` is the active status line.
  -- hl("StatusLine", {})

  -- `StatusLineNC` is the inactive status line.
  -- hl("StatusLineNC", {})

  -- `TabLine` is the tab bar for inactive tabs.
  -- hl("TabLine", {})

  -- `TabLineSel` is the selected tab label.
  -- hl("TabLineSel", {})

  -- `TabLineFill` fills unused tab bar space.
  -- hl("TabLineFill", {})

  -- `VertSplit` separates vertically split windows.
  -- hl("VertSplit", {})

  -- `WinSeparator` separates split windows in newer Neovim.
  -- hl("WinSeparator", {})

  -- `WinBar` is the window-local bar above the buffer.
  -- hl("WinBar", {})

  -- `WinBarNC` is the inactive window bar.
  -- hl("WinBarNC", {})

  -- `Directory` marks directory names in listings.
  -- hl("Directory", {})

  -- `Title` is used for titles and headings.
  -- hl("Title", {})

  -- `Question` is used for yes/no prompts.
  -- hl("Question", {})

  -- `WarningMsg` is used for warning messages.
  -- hl("WarningMsg", {})

  -- `ErrorMsg` is used for error messages.
  -- hl("ErrorMsg", {})

  -- `ModeMsg` is used for mode/status messages.
  -- hl("ModeMsg", {})

  -- `MoreMsg` is used for pager prompts.
  -- hl("MoreMsg", {})

  -- `MsgArea` is the message area below the command line.
  -- hl("MsgArea", {})

  -- `MsgSeparator` separates message chunks in the command area.
  -- hl("MsgSeparator", {})

  -- `MatchParen` highlights the matching bracket pair.
  -- hl("MatchParen", {})

  -- `QuickFixLine` marks the current quickfix item.
  -- hl("QuickFixLine", {})

  -- `EndOfBuffer` is the filler after the last line of a buffer.
  -- hl("EndOfBuffer", {})

  -- `NonText` marks invisible buffer filler text like `~`.
  hl("NonText", { fg = M.ui.non_text })

  -- `SpecialKey` marks special non-printable key representations.
  hl("SpecialKey", { fg = M.ui.special_key })

  -- ============================================================================
  -- WhichKey
  -- ============================================================================

  -- `Whitespace` marks listchars whitespace.
  hl("Whitespace", { fg = M.ui.whitespace })

  -- `WhichKeyNormal` is the popup background and text area.
  hl("WhichKeyNormal", { fg = M.ui.fg, bg = M.ui.bg })

  -- `WhichKeyBorder` is the popup border.
  hl("WhichKeyBorder", { fg = M.ui.fg, bg = M.ui.bg })

  -- `WhichKeyTitle` labels the popup title.
  hl("WhichKeyTitle", { fg = M.ui.fg, bg = M.ui.bg })

  -- `WhichKeyGroup` marks grouped key prefixes. TODO: set fg
  hl("WhichKeyGroup", { fg = M.ui.fg, bg = M.ui.bg })

  -- `WhichKeyDesc` marks mapping descriptions.
  hl("WhichKeyDesc", { fg = M.ui.fg, bg = M.ui.bg })

  -- `WhichKeySeparator` separates keys from descriptions.
  hl("WhichKeySeparator", { fg = M.ui.fg, bg = M.ui.bg })

  -- `WhichKeyValue` shows plugin-provided values. TODO: set fg
  hl("WhichKeyValue", { fg = M.ui.fg, bg = M.ui.bg })
end

return M
