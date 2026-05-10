--- *lem.theme* Centralized color definitions for Neovim themes and plugins
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev
local M = {}

-- UI
M.ui = {
  bg = "#1d1f21",
  color_column = "#282a2e",
  cursor = "#c5c8c6",
  cursor_column = "#282a2e",
  cursor_line = "#282a2e",
  cursor_line_nr = "#282a2e",
  cur_search_bg = "#de935f",
  cur_search_fg = "#1d1f21",
  directory_fg = "#81a2be",
  end_of_buffer_fg = "#969896",
  error_fg = "#cc6666",
  float_bg = "#1d1f21",
  float_border_fg = "#969896",
  float_fg = "#c5c8c6",
  float_title_fg = "#c5c8c6",
  folded_bg = "#282a2e",
  folded_fg = "#969896",
  fg = "#c5c8c6",
  inc_search_bg = "#de935f",
  inc_search_fg = "#1d1f21",
  line_nr = "#c5c8c6",
  matchparen_bg = "#373b41",
  mode_fg = "#c5c8c6",
  non_text = "#969896",
  more_fg = "#de935f",
  msg_area_fg = "#c5c8c6",
  msg_separator_fg = "#969896",
  pmenu_bg = "#1d1f21",
  pmenu_fg = "#c5c8c6",
  pmenu_sel_bg = "#282a2e",
  pmenu_sel_fg = "#c5c8c6",
  pmenu_sbar_bg = "#282a2e",
  pmenu_thumb_bg = "#969896",
  question_fg = "#81a2be",
  quickfix_line_bg = "#373b41",
  search_bg = "#f0c674",
  search_fg = "#1d1f21",
  selection_bg = "#282a2e",
  selection_fg = "#c5c8c6",
  split_fg = "#969896",
  statusline_bg = "#373b41",
  statusline_fg = "#c5c8c6",
  statusline_nc_bg = "#282a2e",
  statusline_nc_fg = "#c5c8c6",
  special_key = "#282a2e",
  tabline_bg = "#282a2e",
  tabline_fill_bg = "#282a2e",
  tabline_fg = "#c5c8c6",
  tabline_sel_bg = "#282a2e",
  tabline_sel_fg = "#c5c8c6",
  title_fg = "#f0c674",
  warning_fg = "#de935f",
  winbar_bg = "#282a2e",
  winbar_fg = "#c5c8c6",
  winbar_nc_bg = "#282a2e",
  winbar_nc_fg = "#969896",
  whitespace = "#282a2e",
}

-- Syntax
M.syntax = {
  comment = "#969896",
  constant = "#de935f",
  constant_builtin = "#de935f",
  constant_macro = "#de935f",
  error = "#cc6666",
  delimiter = "#c5c8c6",
  character = "#de935f",
  character_special = "#de935f",
  float = "#de935f",
  variable_builtin = "#cc6666",
  variable_parameter = "#de935f",
  variable_parameter_builtin = "#de935f",
  variable_member = "#cc6666",
  identifier = "#cc6666",
  namespace = "#f0c674",
  namespace_builtin = "#f0c674",
  field = "#cc6666",
  field_builtin = "#cc6666",
  parameter = "#de935f",
  parameter_builtin = "#de935f",
  boolean = "#de935f",
  module = "#f0c674",
  module_builtin = "#f0c674",
  label = "#b294bb",
  statement = "#b294bb",
  conditional = "#b294bb",
  ["repeat"] = "#b294bb",
  exception = "#b294bb",
  attribute = "#b294bb",
  attribute_builtin = "#b294bb",
  property = "#cc6666",
  constructor = "#f0c674",
  include = "#de935f",
  define = "#de935f",
  macro = "#de935f",
  precondit = "#de935f",
  text = "#c5c8c6",
  text_strong = "#de935f",
  text_emphasis = "#de935f",
  text_strike = "#de935f",
  text_underline = "#de935f",
  text_title = "#b5bd68",
  text_literal = "#b5bd68",
  text_quote = "#8abeb7",
  text_uri = "#cc6666",
  text_math = "#8abeb7",
  text_todo = "#969896",
  text_note = "#969896",
  text_warning = "#969896",
  text_reference = "#cc6666",
  ["function"] = "#81a2be",
  function_builtin = "#81a2be",
  function_call = "#81a2be",
  function_macro = "#de935f",
  function_method = "#81a2be",
  function_method_call = "#81a2be",
  keyword = "#b294bb",
  keyword_coroutine = "#b294bb",
  keyword_function = "#b294bb",
  keyword_operator = "#8abeb7",
  keyword_import = "#b294bb",
  keyword_type = "#b294bb",
  keyword_modifier = "#b294bb",
  keyword_repeat = "#b294bb",
  keyword_return = "#b294bb",
  keyword_debug = "#b294bb",
  keyword_exception = "#b294bb",
  keyword_conditional = "#b294bb",
  keyword_conditional_ternary = "#8abeb7",
  keyword_directive = "#de935f",
  keyword_directive_define = "#de935f",
  number = "#de935f",
  number_float = "#de935f",
  operator = "#8abeb7",
  preproc = "#de935f",
  storageclass = "#b294bb",
  structure = "#f0c674",
  typedef = "#f0c674",
  punctuation_delimiter = "#c5c8c6",
  punctuation_bracket = "#c5c8c6",
  punctuation_special = "#8abeb7",
  special = "#8abeb7",
  comment_special = "#969896",
  debug = "#8abeb7",
  underlined = "#8abeb7",
  todo = "#969896",
  string = "#b5bd68",
  string_documentation = "#b5bd68",
  string_regexp = "#cc6666",
  string_escape = "#de935f",
  string_special = "#8abeb7",
  string_special_symbol = "#b5bd68",
  string_special_path = "#cc6666",
  string_special_url = "#cc6666",
  type = "#f0c674",
  type_builtin = "#f0c674",
  type_definition = "#f0c674",
  variable = "#cc6666",
  comment_documentation = "#969896",
  comment_error = "#969896",
  comment_warning = "#969896",
  comment_todo = "#969896",
  comment_note = "#969896",
  markup_strong = "#de935f",
  markup_italic = "#de935f",
  markup_strikethrough = "#de935f",
  markup_underline = "#de935f",
  markup_heading = "#b5bd68",
  markup_heading_1 = "#b5bd68",
  markup_heading_2 = "#b5bd68",
  markup_heading_3 = "#b5bd68",
  markup_heading_4 = "#b5bd68",
  markup_heading_5 = "#b5bd68",
  markup_heading_6 = "#b5bd68",
  markup_quote = "#8abeb7",
  markup_math = "#8abeb7",
  markup_link = "#cc6666",
  markup_link_label = "#cc6666",
  markup_link_url = "#cc6666",
  markup_raw = "#b5bd68",
  markup_raw_block = "#b5bd68",
  markup_list = "#c5c8c6",
  markup_list_checked = "#c5c8c6",
  markup_list_unchecked = "#c5c8c6",
  diff_plus = "#de935f",
  diff_minus = "#de935f",
  diff_delta = "#de935f",
  tag = "#cc6666",
  tag_builtin = "#cc6666",
  tag_attribute = "#cc6666",
  tag_delimiter = "#c5c8c6",
}

-- Fzf
M.fzf = {
  fg = "#c5c8c6",
  bg = "#1d1f21",
  hl = "#f0c674",
  ["fg+"] = "#ffffff",
  ["bg+"] = "#282a2e",
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

-- FzfLua
M.fzf_lua = {
  normal_fg = M.fzf.fg,
  normal_bg = M.fzf.bg,
  border_fg = M.fzf.border,
  border_bg = M.fzf.bg,
  title_fg = M.fzf.hl,
  title_bg = M.fzf.bg,
  preview_fg = M.fzf.fg,
  preview_bg = M.fzf.bg,
  preview_border_fg = M.fzf.border,
  preview_border_bg = M.fzf.bg,
  search_fg = M.fzf.bg,
  search_bg = M.fzf.hl,
  cursorline_bg = M.fzf["bg+"],
  backdrop_bg = M.fzf.bg,
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
  section_bg = "#373b41",
  section_fg = "#c5c8c6",
  inactive_bg = "#373b41",
  inactive_fg = "#c5c8c6",
}

-- Git
M.git = {
  add = "#b5bd68",
  change = "#de935f",
  delete = "#cc6666",
  rename = "#81a2be",
  ignored = "#969896",
  blame = "#8abeb7",
}

-- Diagnostic
M.diagnostic = {
  error = "#cc6666",
  warn = "#de935f",
  info = "#81a2be",
  hint = "#8abeb7",
  ok = "#b5bd68",
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

  -- `Normal` is the default text area for the current window, such as plain
  -- file contents like `local x = 1`.
  hl("Normal", { fg = M.ui.fg, bg = M.ui.bg })

  -- `NormalNC` is the default text area for inactive windows, such as a split
  -- showing the same buffer but not currently focused.
  hl("NormalNC", { fg = M.ui.fg, bg = M.ui.bg })

  -- `Cursor` is the visual caret in the active window, the block or bar that
  -- marks the insertion point in text like `foo|bar`.
  hl("Cursor", { fg = M.ui.bg, bg = M.ui.cursor })

  -- `CursorLine` highlights the current line, for example the line containing
  -- the active word while editing a multi-line file.
  hl("CursorLine", { bg = M.ui.cursor_line })

  -- `CursorColumn` highlights the vertical column under the cursor, which is
  -- useful when tracking a fixed indentation or character position.
  hl("CursorColumn", { bg = M.ui.cursor_column })

  -- `CursorLineNr` highlights the line number on the current line, such as the
  -- `42` in the gutter when line 42 is active.
  hl("CursorLineNr", { bg = M.ui.cursor_line_nr, bold = true })

  -- `ColorColumn` marks preferred text width columns, such as an 80-column wrap
  -- guide in the editor.
  hl("ColorColumn", { bg = M.ui.color_column })

  -- `LineNr` is the line number gutter for non-current lines, such as `1`, `2`,
  -- `3` beside the active line.
  hl("LineNr", { fg = M.ui.line_nr })

  -- `SignColumn` holds signs such as diagnostics and git marks, for example
  -- the gutter markers from LSP errors or Git signs.
  hl("SignColumn", { fg = M.ui.fg, bg = M.ui.bg })

  -- `FoldColumn` shows fold markers, such as `+--` or closed fold indicators
  -- beside collapsed code blocks.
  hl("FoldColumn", { fg = M.ui.fg, bg = M.ui.bg })

  -- `Folded` is used for folded text lines, like a collapsed function body or
  -- block comment preview.
  hl("Folded", { fg = M.ui.folded_fg, bg = M.ui.folded_bg })

  -- `Search` highlights the last search match, such as the remaining matches
  -- after running `/pattern`.
  hl("Search", { fg = M.ui.search_fg, bg = M.ui.search_bg, bold = true })

  -- `CurSearch` highlights the current search match under the cursor, the one
  -- currently selected while stepping through search hits.
  hl(
    "CurSearch",
    { fg = M.ui.cur_search_fg, bg = M.ui.cur_search_bg, bold = true }
  )

  -- `IncSearch` highlights incremental search matches, the live preview while
  -- typing `/part` before the search is confirmed.
  hl(
    "IncSearch",
    { fg = M.ui.cur_search_fg, bg = M.ui.inc_search_bg, bold = true }
  )

  -- `Visual` highlights visual selections, such as text selected with `v`,
  -- `V`, or `Ctrl-V`.
  hl("Visual", { fg = M.ui.selection_fg, bg = M.ui.selection_bg })

  -- `VisualNOS` highlights visual selections when not owned by Vim, which is
  -- rare but keeps the selection visible in special ownership cases.
  hl("VisualNOS", { fg = M.ui.selection_fg, bg = M.ui.selection_bg })

  -- `Pmenu` styles popup menu entries, such as completion items in insert mode.
  hl("Pmenu", { fg = M.ui.pmenu_fg, bg = M.ui.pmenu_bg })

  -- `PmenuSel` styles the selected popup menu entry, the currently highlighted
  -- completion candidate in the menu.
  hl("PmenuSel", { fg = M.ui.pmenu_sel_fg, bg = M.ui.pmenu_sel_bg })

  -- `PmenuSbar` styles the popup menu scrollbar track, the background behind
  -- the completion list thumb.
  hl("PmenuSbar", { bg = M.ui.pmenu_sbar_bg })

  -- `PmenuThumb` styles the popup menu scrollbar thumb, the small draggable
  -- block that indicates scroll position in the menu.
  hl("PmenuThumb", { bg = M.ui.pmenu_thumb_bg })

  -- `NormalFloat` is the base background for floating windows, such as help,
  -- diagnostics, hover popups, or command-line floats.
  hl("NormalFloat", { fg = M.ui.float_fg, bg = M.ui.float_bg })

  -- `FloatBorder` is the border around floating windows, the frame drawn
  -- around help popups, LSP hovers, and other overlays.
  hl("FloatBorder", { fg = M.ui.float_border_fg, bg = M.ui.float_bg })

  -- `FloatTitle` is the title of floating windows, such as `Documentation` or
  -- `Diagnostics` at the top of a popup.
  hl(
    "FloatTitle",
    { fg = M.ui.float_title_fg, bg = M.ui.float_bg, bold = true }
  )

  -- `StatusLine` is the active status line, the bar at the bottom showing mode,
  -- file name, diagnostics, and cursor position.
  hl("StatusLine", { fg = M.ui.statusline_fg, bg = M.ui.statusline_bg })

  -- `StatusLineNC` is the inactive status line, used for other windows that are
  -- not currently focused.
  hl("StatusLineNC", { fg = M.ui.statusline_nc_fg, bg = M.ui.statusline_nc_bg })

  -- `TabLine` is the tab bar for inactive tabs, the labels for tabs that are
  -- not currently selected.
  hl("TabLine", { fg = M.ui.tabline_fg, bg = M.ui.tabline_bg })

  -- `TabLineSel` is the selected tab label, the active tab shown in the tab
  -- bar.
  hl(
    "TabLineSel",
    { fg = M.ui.tabline_sel_fg, bg = M.ui.tabline_sel_bg, bold = true }
  )

  -- `TabLineFill` fills unused tab bar space, the empty area around tab labels.
  hl("TabLineFill", { bg = M.ui.tabline_fill_bg })

  -- `VertSplit` separates vertically split windows, the divider between side by
  -- side panes.
  hl("VertSplit", { fg = M.ui.split_fg, bg = M.ui.bg })

  -- `WinSeparator` separates split windows in newer Neovim, usually the same
  -- visual divider as `VertSplit`.
  hl("WinSeparator", { fg = M.ui.split_fg, bg = M.ui.bg })

  -- `WinBar` is the window-local bar above the buffer, for per-window titles or
  -- breadcrumbs.
  hl("WinBar", { fg = M.ui.winbar_fg, bg = M.ui.winbar_bg })

  -- `WinBarNC` is the inactive window bar, shown for windows that are not in
  -- focus.
  hl("WinBarNC", { fg = M.ui.winbar_nc_fg, bg = M.ui.winbar_nc_bg })

  -- `Directory` marks directory names in listings, for example `src/` in a file
  -- explorer or `:edit` path completion.
  hl("Directory", { fg = M.ui.directory_fg })

  -- `Title` is used for titles and headings, such as help page headers or
  -- command output titles.
  hl("Title", { fg = M.ui.title_fg, bold = true })

  -- `Question` is used for yes/no prompts, such as `Save changes? [y/n]`.
  hl("Question", { fg = M.ui.question_fg, bold = true })

  -- `WarningMsg` is used for warning messages, such as deprecation or caution
  -- notices.
  hl("WarningMsg", { fg = M.ui.warning_fg, bold = true })

  -- `ErrorMsg` is used for error messages, such as failed commands or runtime
  -- errors.
  hl("ErrorMsg", { fg = M.ui.error_fg, bold = true })

  -- `ModeMsg` is used for mode/status messages, such as `-- INSERT --`.
  hl("ModeMsg", { fg = M.ui.mode_fg })

  -- `MoreMsg` is used for pager prompts, such as the `-- More --` message when
  -- output is paged.
  hl("MoreMsg", { fg = M.ui.more_fg, bold = true })

  -- `MsgArea` is the message area below the command line, where echo messages
  -- and notifications appear.
  hl("MsgArea", { fg = M.ui.msg_area_fg, bg = M.ui.bg })

  -- `MsgSeparator` separates message chunks in the command area, for example
  -- dividers between repeated messages.
  hl("MsgSeparator", { fg = M.ui.msg_separator_fg, bg = M.ui.bg })

  -- `MatchParen` highlights the matching bracket pair, such as the `)` that
  -- matches a `(` under the cursor.
  hl("MatchParen", { bg = M.ui.matchparen_bg, bold = true })

  -- `QuickFixLine` marks the current quickfix item, the highlighted row in the
  -- quickfix or location list.
  hl("QuickFixLine", { bg = M.ui.quickfix_line_bg })

  -- `EndOfBuffer` is the filler after the last line of a buffer, usually shown
  -- as `~` on empty lines past the file end.
  hl("EndOfBuffer", { fg = M.ui.end_of_buffer_fg })

  -- `NonText` marks invisible buffer filler text like `~` or text shown only
  -- for layout purposes.
  hl("NonText", { fg = M.ui.non_text })

  -- `SpecialKey` marks special non-printable key representations, such as list
  -- markers for tabs, trailing spaces, or control characters.
  hl("SpecialKey", { fg = M.ui.special_key })

  -- `Whitespace` marks listchars whitespace, such as visible spaces or tabs in
  -- `:set list` mode.
  hl("Whitespace", { fg = M.ui.whitespace })

  -- ============================================================================
  -- Mason
  -- ============================================================================

  -- `MasonBackdrop` is the dimmed backdrop behind the Mason window.
  hl("MasonBackdrop", { bg = M.ui.bg })

  -- `MasonNormal` is the main Mason window surface.
  hl("MasonNormal", { fg = M.ui.float_fg, bg = M.ui.float_bg })

  -- `MasonHeader` is the primary Mason title bar.
  hl("MasonHeader", { fg = M.ui.title_fg, bg = M.ui.float_bg, bold = true })

  -- `MasonHeaderSecondary` is the secondary Mason title bar.
  hl(
    "MasonHeaderSecondary",
    { fg = M.ui.question_fg, bg = M.ui.float_bg, bold = true }
  )

  -- `MasonHighlight` marks emphasized Mason text.
  hl("MasonHighlight", { fg = M.ui.directory_fg })

  -- `MasonHighlightBlock` marks emphasized block text in Mason.
  hl("MasonHighlightBlock", { fg = M.ui.bg, bg = M.ui.directory_fg })

  -- `MasonHighlightBlockBold` marks bold emphasized block text in Mason.
  hl(
    "MasonHighlightBlockBold",
    { fg = M.ui.bg, bg = M.ui.directory_fg, bold = true }
  )

  -- `MasonHighlightSecondary` marks the secondary emphasis color in Mason.
  hl("MasonHighlightSecondary", { fg = M.ui.title_fg })

  -- `MasonHighlightBlockSecondary` marks the secondary block emphasis color.
  hl("MasonHighlightBlockSecondary", { fg = M.ui.bg, bg = M.ui.title_fg })

  -- `MasonHighlightBlockBoldSecondary` marks the bold secondary block emphasis.
  hl(
    "MasonHighlightBlockBoldSecondary",
    { fg = M.ui.bg, bg = M.ui.title_fg, bold = true }
  )

  -- `MasonLink` marks URLs and link-like references in Mason.
  hl("MasonLink", { fg = M.ui.directory_fg, underline = true })

  -- `MasonMuted` marks low-priority text in Mason.
  hl("MasonMuted", { fg = M.ui.non_text })

  -- `MasonMutedBlock` marks muted block text in Mason.
  hl("MasonMutedBlock", { fg = M.ui.bg, bg = M.ui.non_text })

  -- `MasonMutedBlockBold` marks bold muted block text in Mason.
  hl("MasonMutedBlockBold", { fg = M.ui.bg, bg = M.ui.non_text, bold = true })

  -- `MasonError` marks Mason error text.
  hl("MasonError", { fg = M.ui.error_fg, bold = true })

  -- `MasonWarning` marks Mason warning text.
  hl("MasonWarning", { fg = M.ui.warning_fg, bold = true })

  -- `MasonHeading` marks section headings in Mason.
  hl("MasonHeading", { fg = M.ui.title_fg, bold = true })

  -- ============================================================================
  -- NvimTree
  -- ============================================================================

  -- `NvimTreeNormal` is the main file explorer surface.
  hl("NvimTreeNormal", { fg = M.ui.float_fg, bg = M.ui.float_bg })

  -- `NvimTreeNormalFloat` is the floating help/search surface inside NvimTree.
  hl("NvimTreeNormalFloat", { fg = M.ui.float_fg, bg = M.ui.float_bg })

  -- `NvimTreeNormalFloatBorder` is the border around floating NvimTree windows.
  hl(
    "NvimTreeNormalFloatBorder",
    { fg = M.ui.float_border_fg, bg = M.ui.float_bg }
  )

  -- `NvimTreeNormalNC` is the explorer surface when the window is inactive.
  hl("NvimTreeNormalNC", { fg = M.ui.float_fg, bg = M.ui.float_bg })

  -- `NvimTreeLineNr` is the line number gutter in the tree view.
  hl("NvimTreeLineNr", { fg = M.ui.line_nr })

  -- `NvimTreeWinSeparator` separates the tree from the main editing window.
  hl("NvimTreeWinSeparator", { fg = M.ui.split_fg, bg = M.ui.bg })

  -- `NvimTreeEndOfBuffer` is the filler after the last tree entry.
  hl("NvimTreeEndOfBuffer", { fg = M.ui.end_of_buffer_fg })

  -- `NvimTreePopup` is the base surface for small tree popups.
  hl("NvimTreePopup", { fg = M.ui.float_fg, bg = M.ui.float_bg })

  -- `NvimTreeSignColumn` is the sign gutter used by the tree window.
  hl("NvimTreeSignColumn", { fg = M.ui.fg, bg = M.ui.bg })

  -- `NvimTreeCursorColumn` highlights the current tree cursor column.
  hl("NvimTreeCursorColumn", { bg = M.ui.cursor_column })

  -- `NvimTreeCursorLine` highlights the current tree row.
  hl("NvimTreeCursorLine", { bg = M.ui.cursor_line })

  -- `NvimTreeCursorLineNr` highlights the current tree line number.
  hl("NvimTreeCursorLineNr", { bg = M.ui.cursor_line_nr, bold = true })

  -- `NvimTreeStatusLine` is the active status line when the tree window is focused.
  hl("NvimTreeStatusLine", { fg = M.ui.statusline_fg, bg = M.ui.statusline_bg })

  -- `NvimTreeStatusLineNC` is the inactive status line for the tree window.
  hl(
    "NvimTreeStatusLineNC",
    { fg = M.ui.statusline_nc_fg, bg = M.ui.statusline_nc_bg }
  )

  -- `NvimTreeExecFile` marks executable files, like `script.sh`.
  hl("NvimTreeExecFile", { fg = M.ui.fg })

  -- `NvimTreeImageFile` marks image files, like `icon.png`.
  hl("NvimTreeImageFile", { fg = M.ui.fg })

  -- `NvimTreeSpecialFile` marks special files, like help or config entries.
  hl("NvimTreeSpecialFile", { fg = M.ui.fg })

  -- `NvimTreeSymlink` marks symlink entries, like `link -> target`.
  hl("NvimTreeSymlink", { fg = M.ui.fg, underline = true })

  -- `NvimTreeRootFolder` marks the project root folder.
  hl("NvimTreeRootFolder", { fg = M.ui.title_fg, bold = true })

  -- `NvimTreeFolderName` marks regular folder names, like `src/`.
  hl("NvimTreeFolderName", { fg = M.ui.directory_fg })

  -- `NvimTreeEmptyFolderName` marks empty folders.
  hl("NvimTreeEmptyFolderName", { fg = M.ui.directory_fg })

  -- `NvimTreeOpenedFolderName` marks folders that are expanded.
  hl("NvimTreeOpenedFolderName", { fg = M.ui.directory_fg, bold = true })

  -- `NvimTreeSymlinkFolderName` marks symlinked folders.
  hl("NvimTreeSymlinkFolderName", { fg = M.ui.directory_fg, underline = true })

  -- `NvimTreeFileIcon` marks file icons in the tree.
  hl("NvimTreeFileIcon", { fg = M.ui.fg })

  -- `NvimTreeSymlinkIcon` marks symlink icons in the tree.
  hl("NvimTreeSymlinkIcon", { fg = M.ui.directory_fg })

  -- `NvimTreeFolderIcon` marks folder icons in the tree.
  hl("NvimTreeFolderIcon", { fg = M.ui.directory_fg })

  -- `NvimTreeOpenedFolderIcon` marks open folder icons.
  hl("NvimTreeOpenedFolderIcon", { fg = M.ui.directory_fg, bold = true })

  -- `NvimTreeClosedFolderIcon` marks closed folder icons.
  hl("NvimTreeClosedFolderIcon", { fg = M.ui.directory_fg })

  -- `NvimTreeFolderArrowClosed` marks collapsed folder arrows.
  hl("NvimTreeFolderArrowClosed", { fg = M.ui.non_text })

  -- `NvimTreeFolderArrowOpen` marks expanded folder arrows.
  hl("NvimTreeFolderArrowOpen", { fg = M.ui.non_text })

  -- `NvimTreeIndentMarker` marks the indentation guide icons.
  hl("NvimTreeIndentMarker", { fg = M.ui.non_text })

  -- `NvimTreeWindowPicker` marks the window picker prompt in NvimTree.
  hl("NvimTreeWindowPicker", { fg = M.ui.bg, bg = M.ui.title_fg, bold = true })

  -- `NvimTreeLiveFilterPrefix` marks the live filter prefix text.
  hl("NvimTreeLiveFilterPrefix", { fg = M.ui.title_fg })

  -- `NvimTreeLiveFilterValue` marks the live filter value text.
  hl("NvimTreeLiveFilterValue", { fg = M.ui.mode_fg })

  -- `NvimTreeCutHL` marks cut entries.
  hl("NvimTreeCutHL", { fg = M.ui.error_fg, bold = true })

  -- `NvimTreeCopiedHL` marks copied entries.
  hl("NvimTreeCopiedHL", { fg = M.ui.question_fg, bold = true })

  -- `NvimTreeBookmarkIcon` marks bookmark icons.
  hl("NvimTreeBookmarkIcon", { fg = M.ui.title_fg })

  -- `NvimTreeBookmarkHL` marks bookmarked entries.
  hl("NvimTreeBookmarkHL", { fg = M.ui.title_fg, bold = true })

  -- `NvimTreeModifiedIcon` marks modified files and folders.
  hl("NvimTreeModifiedIcon", { fg = M.ui.warning_fg })

  -- `NvimTreeModifiedFileHL` marks modified files.
  hl("NvimTreeModifiedFileHL", { fg = M.ui.warning_fg, bold = true })

  -- `NvimTreeModifiedFolderHL` marks modified folders.
  hl("NvimTreeModifiedFolderHL", { fg = M.ui.warning_fg, bold = true })

  -- `NvimTreeHiddenIcon` marks hidden entries.
  hl("NvimTreeHiddenIcon", { fg = M.ui.non_text })

  -- `NvimTreeHiddenFileHL` marks hidden files.
  hl("NvimTreeHiddenFileHL", { fg = M.ui.non_text })

  -- `NvimTreeHiddenFolderHL` marks hidden folders.
  hl("NvimTreeHiddenFolderHL", { fg = M.ui.non_text })

  -- `NvimTreeHiddenDisplay` marks the hidden-items summary line.
  hl("NvimTreeHiddenDisplay", { fg = M.ui.non_text })

  -- `NvimTreeOpenedHL` marks opened entries.
  hl("NvimTreeOpenedHL", { fg = M.ui.special_key })

  -- `NvimTreeGitDeletedIcon` marks deleted Git states.
  hl("NvimTreeGitDeletedIcon", { fg = M.git.delete })

  -- `NvimTreeGitDirtyIcon` marks dirty Git states.
  hl("NvimTreeGitDirtyIcon", { fg = M.git.change })

  -- `NvimTreeGitIgnoredIcon` marks ignored Git states.
  hl("NvimTreeGitIgnoredIcon", { fg = M.git.ignored })

  -- `NvimTreeGitMergeIcon` marks merge-conflict Git states.
  hl("NvimTreeGitMergeIcon", { fg = M.git.delete, bold = true })

  -- `NvimTreeGitNewIcon` marks new Git states.
  hl("NvimTreeGitNewIcon", { fg = M.git.add })

  -- `NvimTreeGitRenamedIcon` marks renamed Git states.
  hl("NvimTreeGitRenamedIcon", { fg = M.git.rename })

  -- `NvimTreeGitStagedIcon` marks staged Git states.
  hl("NvimTreeGitStagedIcon", { fg = M.git.add })

  -- `NvimTreeGitFileDeletedHL` marks deleted files.
  hl("NvimTreeGitFileDeletedHL", { fg = M.git.delete })

  -- `NvimTreeGitFileDirtyHL` marks dirty files.
  hl("NvimTreeGitFileDirtyHL", { fg = M.git.change })

  -- `NvimTreeGitFileIgnoredHL` marks ignored files.
  hl("NvimTreeGitFileIgnoredHL", { fg = M.git.ignored })

  -- `NvimTreeGitFileMergeHL` marks merge-conflict files.
  hl("NvimTreeGitFileMergeHL", { fg = M.git.delete, bold = true })

  -- `NvimTreeGitFileNewHL` marks new files.
  hl("NvimTreeGitFileNewHL", { fg = M.git.add })

  -- `NvimTreeGitFileRenamedHL` marks renamed files.
  hl("NvimTreeGitFileRenamedHL", { fg = M.git.rename })

  -- `NvimTreeGitFileStagedHL` marks staged files.
  hl("NvimTreeGitFileStagedHL", { fg = M.git.add })

  -- `NvimTreeGitFolderDeletedHL` marks deleted folders.
  hl("NvimTreeGitFolderDeletedHL", { fg = M.git.delete })

  -- `NvimTreeGitFolderDirtyHL` marks dirty folders.
  hl("NvimTreeGitFolderDirtyHL", { fg = M.git.change })

  -- `NvimTreeGitFolderIgnoredHL` marks ignored folders.
  hl("NvimTreeGitFolderIgnoredHL", { fg = M.git.ignored })

  -- `NvimTreeGitFolderMergeHL` marks merge-conflict folders.
  hl("NvimTreeGitFolderMergeHL", { fg = M.git.delete, bold = true })

  -- `NvimTreeGitFolderNewHL` marks new folders.
  hl("NvimTreeGitFolderNewHL", { fg = M.git.add })

  -- `NvimTreeGitFolderRenamedHL` marks renamed folders.
  hl("NvimTreeGitFolderRenamedHL", { fg = M.git.rename })

  -- `NvimTreeGitFolderStagedHL` marks staged folders.
  hl("NvimTreeGitFolderStagedHL", { fg = M.git.add })

  -- `NvimTreeDiagnosticErrorIcon` marks error diagnostics.
  hl("NvimTreeDiagnosticErrorIcon", { fg = M.diagnostic.error })

  -- `NvimTreeDiagnosticWarnIcon` marks warning diagnostics.
  hl("NvimTreeDiagnosticWarnIcon", { fg = M.diagnostic.warn })

  -- `NvimTreeDiagnosticInfoIcon` marks info diagnostics.
  hl("NvimTreeDiagnosticInfoIcon", { fg = M.diagnostic.info })

  -- `NvimTreeDiagnosticHintIcon` marks hint diagnostics.
  hl("NvimTreeDiagnosticHintIcon", { fg = M.diagnostic.hint })

  -- `NvimTreeDiagnosticErrorFileHL` marks error-highlighted files.
  hl(
    "NvimTreeDiagnosticErrorFileHL",
    { fg = M.diagnostic.error, undercurl = true }
  )

  -- `NvimTreeDiagnosticWarnFileHL` marks warning-highlighted files.
  hl(
    "NvimTreeDiagnosticWarnFileHL",
    { fg = M.diagnostic.warn, undercurl = true }
  )

  -- `NvimTreeDiagnosticInfoFileHL` marks info-highlighted files.
  hl(
    "NvimTreeDiagnosticInfoFileHL",
    { fg = M.diagnostic.info, undercurl = true }
  )

  -- `NvimTreeDiagnosticHintFileHL` marks hint-highlighted files.
  hl(
    "NvimTreeDiagnosticHintFileHL",
    { fg = M.diagnostic.hint, undercurl = true }
  )

  -- `NvimTreeDiagnosticErrorFolderHL` marks error-highlighted folders.
  hl(
    "NvimTreeDiagnosticErrorFolderHL",
    { fg = M.diagnostic.error, undercurl = true }
  )

  -- `NvimTreeDiagnosticWarnFolderHL` marks warning-highlighted folders.
  hl(
    "NvimTreeDiagnosticWarnFolderHL",
    { fg = M.diagnostic.warn, undercurl = true }
  )

  -- `NvimTreeDiagnosticInfoFolderHL` marks info-highlighted folders.
  hl(
    "NvimTreeDiagnosticInfoFolderHL",
    { fg = M.diagnostic.info, undercurl = true }
  )

  -- `NvimTreeDiagnosticHintFolderHL` marks hint-highlighted folders.
  hl(
    "NvimTreeDiagnosticHintFolderHL",
    { fg = M.diagnostic.hint, undercurl = true }
  )

  -- ============================================================================
  -- FzfLua
  -- ============================================================================

  -- `FzfLuaNormal` is the main picker surface.
  hl("FzfLuaNormal", { fg = M.fzf_lua.normal_fg, bg = M.fzf_lua.normal_bg })

  -- `FzfLuaBorder` is the picker border.
  hl("FzfLuaBorder", { fg = M.fzf_lua.border_fg, bg = M.fzf_lua.border_bg })

  -- `FzfLuaTitle` is the picker title.
  hl(
    "FzfLuaTitle",
    { fg = M.fzf_lua.title_fg, bg = M.fzf_lua.title_bg, bold = true }
  )

  -- `FzfLuaBackdrop` is the dimmed backdrop behind the picker.
  hl("FzfLuaBackdrop", { bg = M.fzf_lua.backdrop_bg })

  -- `FzfLuaPreviewNormal` is the preview surface.
  hl(
    "FzfLuaPreviewNormal",
    { fg = M.fzf_lua.preview_fg, bg = M.fzf_lua.preview_bg }
  )

  -- `FzfLuaPreviewBorder` is the preview border.
  hl(
    "FzfLuaPreviewBorder",
    { fg = M.fzf_lua.preview_border_fg, bg = M.fzf_lua.preview_border_bg }
  )

  -- `FzfLuaPreviewTitle` is the preview title.
  hl(
    "FzfLuaPreviewTitle",
    { fg = M.fzf_lua.title_fg, bg = M.fzf_lua.preview_bg, bold = true }
  )

  -- `FzfLuaCursorLine` is the selected row in the picker and preview.
  hl(
    "FzfLuaCursorLine",
    { fg = M.fzf_lua.normal_fg, bg = M.fzf_lua.cursorline_bg }
  )

  -- `FzfLuaSearch` highlights search matches inside the picker or preview.
  hl(
    "FzfLuaSearch",
    { fg = M.fzf_lua.search_fg, bg = M.fzf_lua.search_bg, bold = true }
  )

  -- `FzfLuaTitleFlags` is the extra flag text in the picker title, such as
  -- mode or source indicators beside the main title.
  hl("FzfLuaTitleFlags", { fg = M.fzf.header, bg = M.fzf.bg, bold = true })

  -- `FzfLuaCursor` is the cursor inside the preview window, such as the caret
  -- position in a file preview.
  hl("FzfLuaCursor", { fg = M.fzf.bg, bg = M.fzf.hl })

  -- `FzfLuaCursorLineNr` is the line number on the cursor line inside the
  -- preview window, such as the active line number in a code preview.
  hl("FzfLuaCursorLineNr", { fg = M.fzf.info, bg = M.fzf["bg+"] })

  -- `FzfLuaScrollBorderEmpty` is the preview border scrollbar when there is no
  -- more content in that direction.
  hl("FzfLuaScrollBorderEmpty", { fg = M.fzf.border, bg = M.fzf.bg })

  -- `FzfLuaScrollBorderFull` is the preview border scrollbar when the preview
  -- is fully scrollable in that direction.
  hl("FzfLuaScrollBorderFull", { fg = M.fzf.hl, bg = M.fzf.bg })

  -- `FzfLuaScrollFloatEmpty` is the floating scrollbar track for an empty edge
  -- in the preview window.
  hl("FzfLuaScrollFloatEmpty", { fg = M.fzf.border, bg = M.fzf.bg })

  -- `FzfLuaScrollFloatFull` is the floating scrollbar thumb for a filled edge
  -- in the preview window.
  hl("FzfLuaScrollFloatFull", { fg = M.fzf.pointer, bg = M.fzf.bg })

  -- `FzfLuaHelpNormal` is the base surface for the built-in help window.
  hl("FzfLuaHelpNormal", { fg = M.fzf.fg, bg = M.fzf.bg })

  -- `FzfLuaHelpBorder` is the border around the built-in help window.
  hl("FzfLuaHelpBorder", { fg = M.fzf.border, bg = M.fzf.bg })

  -- `FzfLuaHeaderBind` is the keybind label text in the fzf-lua header, such
  -- as shortcut hints shown above the results list.
  hl("FzfLuaHeaderBind", { fg = M.fzf.prompt, bg = M.fzf.bg, bold = true })

  -- `FzfLuaHeaderText` is the descriptive header text in the fzf-lua title
  -- area, such as the picker name or a short hint.
  hl("FzfLuaHeaderText", { fg = M.fzf.header, bg = M.fzf.bg })

  -- `FzfLuaPathColNr` is the column number shown in path-based results, such as
  -- diagnostics or quickfix entries with `file:line:col` data.
  hl("FzfLuaPathColNr", { fg = M.fzf.info })

  -- `FzfLuaPathLineNr` is the line number shown in path-based results, such as
  -- diagnostics or quickfix entries with `file:line:col` data.
  hl("FzfLuaPathLineNr", { fg = M.fzf.marker })

  -- `FzfLuaBufName` is the buffer name text in the buffers and lines pickers.
  hl("FzfLuaBufName", { fg = M.fzf.fg })

  -- `FzfLuaBufId` is the buffer identifier text in the lines picker.
  hl("FzfLuaBufId", { fg = M.fzf.prompt })

  -- `FzfLuaBufNr` is the buffer number text in buffers and tabs lists.
  hl("FzfLuaBufNr", { fg = M.fzf.border })

  -- `FzfLuaBufLineNr` is the line number text in the buffers and blines lists.
  hl("FzfLuaBufLineNr", { fg = M.fzf.border })

  -- `FzfLuaBufFlagCur` marks the current buffer entry in the buffers list.
  hl("FzfLuaBufFlagCur", { fg = M.fzf.header, bold = true })

  -- `FzfLuaBufFlagAlt` marks the alternate buffer entry in the buffers list.
  hl("FzfLuaBufFlagAlt", { fg = M.fzf.info })

  -- `FzfLuaTabTitle` is the tab title text in the tabs picker.
  hl("FzfLuaTabTitle", { fg = M.fzf.info, bold = true })

  -- `FzfLuaTabMarker` is the tab marker text in the tabs picker.
  hl("FzfLuaTabMarker", { fg = M.fzf.prompt })

  -- `FzfLuaDirIcon` is the directory icon shown in path-style pickers.
  hl("FzfLuaDirIcon", { fg = M.fzf.header })

  -- `FzfLuaDirPart` is the directory portion of a path, such as `src/` in a
  -- file path entry.
  hl("FzfLuaDirPart", { fg = M.fzf.fg })

  -- `FzfLuaFilePart` is the file portion of a path, such as `main.lua` in a
  -- file path entry.
  hl("FzfLuaFilePart", { fg = M.fzf.fg })

  -- `FzfLuaLivePrompt` is the prompt text shown while typing live queries.
  hl("FzfLuaLivePrompt", { fg = M.fzf.prompt, bold = true })

  -- `FzfLuaLiveSym` is the live symbol match text in the LSP symbol picker.
  hl("FzfLuaLiveSym", { fg = M.fzf.hl, bold = true })

  -- `FzfLuaCmdEx` is the command text in the command picker for Ex commands.
  hl("FzfLuaCmdEx", { fg = M.fzf.prompt })

  -- `FzfLuaCmdBuf` is the command text in the command picker for buffer-local
  -- commands.
  hl("FzfLuaCmdBuf", { fg = M.fzf.info })

  -- `FzfLuaCmdGlobal` is the command text in the command picker for global
  -- commands.
  hl("FzfLuaCmdGlobal", { fg = M.fzf.header })

  -- `FzfLuaFzfNormal` is the raw fzf fg/bg surface used by the embedded fzf
  -- UI.
  hl("FzfLuaFzfNormal", { fg = M.fzf.fg, bg = M.fzf.bg })

  -- `FzfLuaFzfCursorLine` is the embedded fzf current line highlight.
  hl("FzfLuaFzfCursorLine", { fg = M.fzf.bg, bg = M.fzf["bg+"] })

  -- `FzfLuaFzfMatch` is the embedded fzf match highlight for search hits.
  hl("FzfLuaFzfMatch", { fg = M.fzf.hl })

  -- `FzfLuaFzfBorder` is the embedded fzf border color.
  hl("FzfLuaFzfBorder", { fg = M.fzf.border, bg = M.fzf.bg })

  -- `FzfLuaFzfScrollbar` is the embedded fzf scrollbar color.
  hl("FzfLuaFzfScrollbar", { fg = M.fzf.border })

  -- `FzfLuaFzfSeparator` is the embedded fzf separator color.
  hl("FzfLuaFzfSeparator", { fg = M.fzf.border })

  -- `FzfLuaFzfGutter` is the embedded fzf gutter color.
  hl("FzfLuaFzfGutter", { fg = M.fzf.fg, bg = M.fzf.gutter })

  -- `FzfLuaFzfHeader` is the embedded fzf header color.
  hl("FzfLuaFzfHeader", { fg = M.fzf.header, bg = M.fzf.bg, bold = true })

  -- `FzfLuaFzfInfo` is the embedded fzf info text color.
  hl("FzfLuaFzfInfo", { fg = M.fzf.info })

  -- `FzfLuaFzfPointer` is the embedded fzf pointer marker color.
  hl("FzfLuaFzfPointer", { fg = M.fzf.pointer })

  -- `FzfLuaFzfMarker` is the embedded fzf multi-select marker color.
  hl("FzfLuaFzfMarker", { fg = M.fzf.marker })

  -- `FzfLuaFzfSpinner` is the embedded fzf loading spinner color.
  hl("FzfLuaFzfSpinner", { fg = M.fzf.spinner })

  -- ============================================================================
  -- Diagnostics
  -- ============================================================================

  -- `DiagnosticError` is the base error color for diagnostics.
  hl("DiagnosticError", { fg = M.diagnostic.error })

  -- `DiagnosticWarn` is the base warning color for diagnostics.
  hl("DiagnosticWarn", { fg = M.diagnostic.warn })

  -- `DiagnosticInfo` is the base info color for diagnostics.
  hl("DiagnosticInfo", { fg = M.diagnostic.info })

  -- `DiagnosticHint` is the base hint color for diagnostics.
  hl("DiagnosticHint", { fg = M.diagnostic.hint })

  -- `DiagnosticOk` is the base ok color for diagnostics.
  hl("DiagnosticOk", { fg = M.diagnostic.ok })

  -- `DiagnosticVirtualTextError` colors error virtual text.
  hl("DiagnosticVirtualTextError", { fg = M.diagnostic.error })

  -- `DiagnosticVirtualTextWarn` colors warning virtual text.
  hl("DiagnosticVirtualTextWarn", { fg = M.diagnostic.warn })

  -- `DiagnosticVirtualTextInfo` colors info virtual text.
  hl("DiagnosticVirtualTextInfo", { fg = M.diagnostic.info })

  -- `DiagnosticVirtualTextHint` colors hint virtual text.
  hl("DiagnosticVirtualTextHint", { fg = M.diagnostic.hint })

  -- `DiagnosticVirtualTextOk` colors ok virtual text.
  hl("DiagnosticVirtualTextOk", { fg = M.diagnostic.ok })

  -- `DiagnosticUnderlineError` underlines error diagnostics.
  hl("DiagnosticUnderlineError", { sp = M.diagnostic.error, undercurl = true })

  -- `DiagnosticUnderlineWarn` underlines warning diagnostics.
  hl("DiagnosticUnderlineWarn", { sp = M.diagnostic.warn, undercurl = true })

  -- `DiagnosticUnderlineInfo` underlines info diagnostics.
  hl("DiagnosticUnderlineInfo", { sp = M.diagnostic.info, undercurl = true })

  -- `DiagnosticUnderlineHint` underlines hint diagnostics.
  hl("DiagnosticUnderlineHint", { sp = M.diagnostic.hint, undercurl = true })

  -- `DiagnosticUnderlineOk` underlines ok diagnostics.
  hl("DiagnosticUnderlineOk", { sp = M.diagnostic.ok, undercurl = true })

  -- `DiagnosticFloatingError` colors error text in floating windows.
  hl("DiagnosticFloatingError", { fg = M.diagnostic.error, bg = M.ui.float_bg })

  -- `DiagnosticFloatingWarn` colors warning text in floating windows.
  hl("DiagnosticFloatingWarn", { fg = M.diagnostic.warn, bg = M.ui.float_bg })

  -- `DiagnosticFloatingInfo` colors info text in floating windows.
  hl("DiagnosticFloatingInfo", { fg = M.diagnostic.info, bg = M.ui.float_bg })

  -- `DiagnosticFloatingHint` colors hint text in floating windows.
  hl("DiagnosticFloatingHint", { fg = M.diagnostic.hint, bg = M.ui.float_bg })

  -- `DiagnosticFloatingOk` colors ok text in floating windows.
  hl("DiagnosticFloatingOk", { fg = M.diagnostic.ok, bg = M.ui.float_bg })

  -- `DiagnosticSignError` colors error signs.
  hl("DiagnosticSignError", { fg = M.diagnostic.error })

  -- `DiagnosticSignWarn` colors warning signs.
  hl("DiagnosticSignWarn", { fg = M.diagnostic.warn })

  -- `DiagnosticSignInfo` colors info signs.
  hl("DiagnosticSignInfo", { fg = M.diagnostic.info })

  -- `DiagnosticSignHint` colors hint signs.
  hl("DiagnosticSignHint", { fg = M.diagnostic.hint })

  -- `DiagnosticSignOk` colors ok signs.
  hl("DiagnosticSignOk", { fg = M.diagnostic.ok })

  -- ============================================================================
  -- Git
  -- ============================================================================

  -- `GitSignsAdd` marks added text in the sign column.
  hl("GitSignsAdd", { fg = M.git.add })

  -- `GitSignsAddNr` marks added line numbers.
  hl("GitSignsAddNr", { fg = M.git.add })

  -- `GitSignsAddLn` marks added lines.
  hl("GitSignsAddLn", { fg = M.git.add })

  -- `GitSignsAddCul` marks added text on the cursor line.
  hl("GitSignsAddCul", { fg = M.git.add })

  -- `GitSignsChange` marks modified text in the sign column.
  hl("GitSignsChange", { fg = M.git.change })

  -- `GitSignsChangeNr` marks modified line numbers.
  hl("GitSignsChangeNr", { fg = M.git.change })

  -- `GitSignsChangeLn` marks modified lines.
  hl("GitSignsChangeLn", { fg = M.git.change })

  -- `GitSignsChangeCul` marks modified text on the cursor line.
  hl("GitSignsChangeCul", { fg = M.git.change })

  -- `GitSignsDelete` marks deleted text in the sign column.
  hl("GitSignsDelete", { fg = M.git.delete })

  -- `GitSignsDeleteNr` marks deleted line numbers.
  hl("GitSignsDeleteNr", { fg = M.git.delete })

  -- `GitSignsDeleteLn` marks deleted lines.
  hl("GitSignsDeleteLn", { fg = M.git.delete })

  -- `GitSignsDeleteCul` marks deleted text on the cursor line.
  hl("GitSignsDeleteCul", { fg = M.git.delete })

  -- `GitSignsCurrentLineBlame` shows blame text for the current line.
  hl("GitSignsCurrentLineBlame", { fg = M.git.blame })

  -- `GitSignsAddPreview` marks added preview lines.
  hl("GitSignsAddPreview", { fg = M.git.add })

  -- `GitSignsDeletePreview` marks deleted preview lines.
  hl("GitSignsDeletePreview", { fg = M.git.delete })

  -- `GitSignsNoEOLPreview` marks the no-newline-at-EOF warning.
  hl("GitSignsNoEOLPreview", { fg = M.git.change })

  -- `GitSignsAddInline` marks inline added regions.
  hl("GitSignsAddInline", { fg = M.git.add, bg = M.ui.bg })

  -- `GitSignsChangeInline` marks inline changed regions.
  hl("GitSignsChangeInline", { fg = M.git.change, bg = M.ui.bg })

  -- `GitSignsDeleteInline` marks inline deleted regions.
  hl("GitSignsDeleteInline", { fg = M.git.delete, bg = M.ui.bg })

  -- `GitSignsAddLnInline` marks added inline line regions.
  hl("GitSignsAddLnInline", { fg = M.git.add, bg = M.ui.bg })

  -- `GitSignsChangeLnInline` marks changed inline line regions.
  hl("GitSignsChangeLnInline", { fg = M.git.change, bg = M.ui.bg })

  -- `GitSignsDeleteLnInline` marks deleted inline line regions.
  hl("GitSignsDeleteLnInline", { fg = M.git.delete, bg = M.ui.bg })

  -- ============================================================================
  -- Completion
  -- ============================================================================

  -- `CmpItemAbbr` is the main completion label, such as `printf` in a menu row.
  hl("CmpItemAbbr", { fg = M.ui.fg })

  -- `CmpItemAbbrDeprecated` is a deprecated completion label, such as an old
  -- function or symbol that still appears in the menu.
  hl("CmpItemAbbrDeprecated", { fg = M.ui.non_text, strikethrough = true })

  -- `CmpItemAbbrMatch` is the matched part of the completion label, such as
  -- the `test` inside `test_utils`.
  hl("CmpItemAbbrMatch", { fg = M.ui.title_fg, bold = true })

  -- `CmpItemAbbrMatchFuzzy` is the fuzzy-match part of the completion label,
  -- such as a partially matched symbol name.
  hl("CmpItemAbbrMatchFuzzy", { fg = M.ui.title_fg, bold = true })

  -- `CmpItemKind` is the generic completion kind label shown beside entries.
  hl("CmpItemKind", { fg = M.syntax.special })

  -- `CmpItemMenu` is the extra menu text on the right, such as the source name.
  hl("CmpItemMenu", { fg = M.ui.non_text })

  -- Completion kinds reuse the theme's semantic syntax slots.
  local cmp_kind_groups = {
    { "Text", M.syntax.text },
    { "Method", M.syntax["function"] },
    { "Function", M.syntax["function"] },
    { "Constructor", M.syntax.constructor },
    { "Field", M.syntax.field },
    { "Variable", M.syntax.variable },
    { "Class", M.syntax.type_definition },
    { "Interface", M.syntax.type_definition },
    { "Module", M.syntax.module },
    { "Property", M.syntax.property },
    { "Unit", M.syntax.constant },
    { "Value", M.syntax.constant },
    { "Enum", M.syntax.type_definition },
    { "Keyword", M.syntax.keyword },
    { "Snippet", M.syntax.keyword_directive },
    { "Color", M.syntax.special },
    { "File", M.ui.fg },
    { "Reference", M.syntax.special },
    { "Folder", M.ui.directory_fg },
    { "EnumMember", M.syntax.constant },
    { "Constant", M.syntax.constant },
    { "Struct", M.syntax.type_definition },
    { "Event", M.syntax.keyword },
    { "Operator", M.syntax.operator },
    { "TypeParameter", M.syntax.type },
  }

  for _, item in ipairs(cmp_kind_groups) do
    hl("CmpItemKind" .. item[1], { fg = item[2] })
  end

  -- ============================================================================
  -- Copilot
  -- ============================================================================

  -- `CopilotSuggestion` is the inline ghost text suggestion, like a faded
  -- completion hint after the cursor.
  hl("CopilotSuggestion", { fg = M.ui.non_text, italic = true })

  -- `CopilotAnnotation` is the annotation text shown in Copilot panels and
  -- suggestion tails.
  hl("CopilotAnnotation", { fg = M.ui.non_text })

  -- ============================================================================
  -- Syntax
  -- ============================================================================

  -- `Comment` is used for regular comments, like `-- note` or `// note`.
  hl("Comment", { fg = M.syntax.comment })

  -- `String` is used for quoted strings, like `"hello"` or `'world'`.
  hl("String", { fg = M.syntax.string })

  -- `Character` is used for character literals, like `'a'` or `'\n'`.
  hl("Character", { fg = M.syntax.character })

  -- `Number` is used for integer literals, like `42` or `0xff`.
  hl("Number", { fg = M.syntax.number })

  -- `Float` is used for floating-point literals, like `3.14` or `1e10`.
  hl("Float", { fg = M.syntax.float })

  -- `Boolean` is used for boolean literals, like `true` or `false`.
  hl("Boolean", { fg = M.syntax.boolean })

  -- `Constant` is used for generic constants, like `PI` or `MAX_SIZE`.
  hl("Constant", { fg = M.syntax.constant })

  -- `Identifier` is used for variables and identifiers, like `foo` or `count`.
  hl("Identifier", { fg = M.syntax.identifier })

  -- `Function` is used for function names, like `print` or `map`.
  hl("Function", { fg = M.syntax["function"] })

  -- `Statement` is used for language statements, like `return` or `break`.
  hl("Statement", { fg = M.syntax.statement })

  -- `Conditional` is used for if/else style constructs, like `if` or `else`.
  hl("Conditional", { fg = M.syntax.conditional })

  -- `Repeat` is used for loop constructs, like `for` or `while`.
  hl("Repeat", { fg = M.syntax["repeat"] })

  -- `Label` is used for goto-style labels, like `loop:` or `::retry::`.
  hl("Label", { fg = M.syntax.label })

  -- `Operator` is used for symbolic operators, like `+`, `-`, `=`, or `*`.
  hl("Operator", { fg = M.syntax.operator })

  -- `Keyword` is used for reserved words, like `function`, `local`, or `end`.
  hl("Keyword", { fg = M.syntax.keyword })

  -- `Exception` is used for error-handling keywords, like `try` or `catch`.
  hl("Exception", { fg = M.syntax.exception })

  -- `PreProc` is used for preprocessor directives, like `#include` or `#define`.
  hl("PreProc", { fg = M.syntax.preproc })

  -- `Include` is used for include/import directives, like `#include <stdio.h>`.
  hl("Include", { fg = M.syntax.include })

  -- `Define` is used for macro or constant definitions, like `#define MAX 10`.
  hl("Define", { fg = M.syntax.define })

  -- `Macro` is used for macro invocations, like `MAX(10)`.
  hl("Macro", { fg = M.syntax.macro })

  -- `PreCondit` is used for conditional preprocessing, like `#if` or `#ifdef`.
  hl("PreCondit", { fg = M.syntax.precondit })

  -- `Type` is used for type names, like `int`, `String`, or `MyStruct`.
  hl("Type", { fg = M.syntax.type })

  -- `StorageClass` is used for storage modifiers, like `static` or `extern`.
  hl("StorageClass", { fg = M.syntax.storageclass })

  -- `Structure` is used for composite types, like `struct Point`.
  hl("Structure", { fg = M.syntax.structure })

  -- `Typedef` is used for type aliases, like `typedef Foo Bar`.
  hl("Typedef", { fg = M.syntax.typedef })

  -- `Special` is used for special symbols, like punctuation-heavy tokens or atoms.
  hl("Special", { fg = M.syntax.special })

  -- `SpecialChar` is used for escapes and special characters, like `\n` or `\t`.
  hl("SpecialChar", { fg = M.syntax.character_special })

  -- `Tag` is used for tag-like names, like `div` in HTML tags.
  hl("Tag", { fg = M.syntax.tag })

  -- `Delimiter` is used for punctuation and separators, like `,` or `;`.
  hl("Delimiter", { fg = M.syntax.delimiter })

  -- `SpecialComment` is used for comment variants like `TODO` or `FIXME`.
  hl("SpecialComment", { fg = M.syntax.comment_special })

  -- `Debug` is used for debugging-related syntax, like `dbg!` or trace markers.
  hl("Debug", { fg = M.syntax.debug })

  -- `Underlined` is used for underlined text, like links or emphasis.
  hl("Underlined", { fg = M.syntax.underlined, underline = true })

  -- `Ignore` is used for text that should be ignored.
  -- NOTE: This is a special case where the text is typically hidden or not rendered,
  -- so we set it to the background color to effectively hide it.
  -- hl("Ignore", {})

  -- `Error` is used for syntax errors, like invalid tokens or broken constructs.
  hl("Error", { fg = M.syntax.error, bold = true })

  -- `Todo` is used for TODO/FIXME-style markers, like `TODO`, `FIXME`, or `XXX`.
  hl("Todo", { fg = M.syntax.todo, bold = true })

  -- ============================================================================
  -- Treesitter
  -- ============================================================================

  -- `@variable` matches variable-like identifiers, like `foo`, `count`, or `result`.
  hl("@variable", { fg = M.syntax.variable })

  -- `@variable.builtin` matches built-in variables, like `self` or `this`.
  hl("@variable.builtin", { fg = M.syntax.variable_builtin })

  -- `@variable.parameter` matches function parameters, like `foo` in `function f(foo) end`.
  hl("@variable.parameter", { fg = M.syntax.variable_parameter })

  -- `@variable.parameter.builtin` matches special built-in parameters, like `_` or `it`.
  hl(
    "@variable.parameter.builtin",
    { fg = M.syntax.variable_parameter_builtin }
  )

  -- `@variable.member` matches object and struct fields, like `user.name` or `point.x`.
  hl("@variable.member", { fg = M.syntax.variable_member })

  -- `@namespace` matches namespace and module paths, like `std` in `std::env`.
  hl("@namespace", { fg = M.syntax.namespace })

  -- `@namespace.builtin` matches built-in namespaces, like `vim` or `std`.
  hl("@namespace.builtin", { fg = M.syntax.namespace_builtin })

  -- `@field` matches struct and object fields, like `name` in `user.name`.
  hl("@field", { fg = M.syntax.field })

  -- `@field.builtin` matches built-in fields used by a grammar or language.
  hl("@field.builtin", { fg = M.syntax.field_builtin })

  -- `@parameter` matches function parameters, like `foo` in `function f(foo) end`.
  hl("@parameter", { fg = M.syntax.parameter })

  -- `@parameter.builtin` matches built-in parameters, like `_` or `it`.
  hl("@parameter.builtin", { fg = M.syntax.parameter_builtin })

  -- `@constant` matches constant identifiers, like `PI` or `MAX_SIZE`.
  hl("@constant", { fg = M.syntax.constant })

  -- `@constant.builtin` matches built-in constants, like `true`, `false`, or `nil`.
  hl("@constant.builtin", { fg = M.syntax.constant_builtin })

  -- `@constant.macro` matches macro-defined constants, like `MAX(10)` in a C macro.
  hl("@constant.macro", { fg = M.syntax.constant_macro })

  -- `@module` matches module and namespace names, like `vim` in `vim.api`.
  hl("@module", { fg = M.syntax.module })

  -- `@module.builtin` matches built-in modules or namespaces, like `math` or `vim`.
  hl("@module.builtin", { fg = M.syntax.module_builtin })

  -- `@label` matches labels and goto targets, like `loop:` or `::retry::`.
  hl("@label", { fg = M.syntax.label })

  -- `@string` matches string literals, like `"hello"` or `'world'`.
  hl("@string", { fg = M.syntax.string })

  -- `@string.documentation` matches documentation strings, like Python docstrings.
  hl("@string.documentation", { fg = M.syntax.string_documentation })

  -- `@string.regexp` matches regular expressions, like `/foo.*/` or `r"[0-9]+"`.
  hl("@string.regexp", { fg = M.syntax.string_regexp })

  -- `@string.escape` matches escapes inside strings, like `\n` or `\t`.
  hl("@string.escape", { fg = M.syntax.string_escape })

  -- `@string.special` matches special string forms, like dates or symbols.
  hl("@string.special", { fg = M.syntax.string_special })

  -- `@string.special.symbol` matches symbols or atoms, like `:ok` or `:error`.
  hl("@string.special.symbol", { fg = M.syntax.string_special_symbol })

  -- `@string.special.path` matches file paths, like `src/main.lua`.
  hl("@string.special.path", { fg = M.syntax.string_special_path })

  -- `@string.special.url` matches URLs, like `https://example.com`.
  hl("@string.special.url", { fg = M.syntax.string_special_url })

  -- `@character` matches character literals, like `'a'` or `'\n'`.
  hl("@character", { fg = M.syntax.character })

  -- `@character.special` matches special character literals, like `'\t'` or `'\x1b'`.
  hl("@character.special", { fg = M.syntax.character_special })

  -- `@boolean` matches boolean literals, like `true` or `false`.
  hl("@boolean", { fg = M.syntax.boolean })

  -- `@number` matches numeric literals, like `42` or `0xff`.
  hl("@number", { fg = M.syntax.number })

  -- `@number.float` matches floating-point literals, like `3.14` or `1e10`.
  hl("@number.float", { fg = M.syntax.number_float })

  -- `@type` matches type names, like `int`, `String`, or `MyStruct`.
  hl("@type", { fg = M.syntax.type })

  -- `@type.builtin` matches built-in types, like `int` or `string`.
  hl("@type.builtin", { fg = M.syntax.type_builtin })

  -- `@type.definition` matches type-definition names, like `typedef Foo Bar`.
  hl("@type.definition", { fg = M.syntax.type_definition })

  -- `@attribute` matches annotations and attributes, like `@deprecated` or `#[test]`.
  hl("@attribute", { fg = M.syntax.attribute })

  -- `@attribute.builtin` matches built-in attributes, like `@property`.
  hl("@attribute.builtin", { fg = M.syntax.attribute_builtin })

  -- `@property` matches object properties and keys, like `name` in `user.name`.
  hl("@property", { fg = M.syntax.property })

  -- `@function` matches function definitions, like `function foo() end`.
  hl("@function", { fg = M.syntax["function"] })

  -- `@function.builtin` matches built-in functions, like `print` or `len`.
  hl("@function.builtin", { fg = M.syntax.function_builtin })

  -- `@function.call` matches function call sites, like `print(x)` or `foo(bar)`.
  hl("@function.call", { fg = M.syntax.function_call })

  -- `@function.macro` matches macro-like functions, like `#define FOO(x)`.
  hl("@function.macro", { fg = M.syntax.function_macro })

  -- `@function.method` matches method definitions, like `obj:method()`.
  hl("@function.method", { fg = M.syntax.function_method })

  -- `@function.method.call` matches method calls, like `obj:method()`.
  hl("@function.method.call", { fg = M.syntax.function_method_call })

  -- `@constructor` matches constructor calls and definitions, like `Foo.new()`.
  hl("@constructor", { fg = M.syntax.constructor })

  -- `@operator` matches symbolic operators, like `+`, `-`, `=`, or `*`.
  hl("@operator", { fg = M.syntax.operator })

  -- `@keyword` matches reserved words, like `return` or `break`.
  hl("@keyword", { fg = M.syntax.keyword })

  -- `@keyword.coroutine` matches coroutine-related keywords, like `async` or `await`.
  hl("@keyword.coroutine", { fg = M.syntax.keyword_coroutine })

  -- `@keyword.function` matches function-defining keywords, like `function` or `def`.
  hl("@keyword.function", { fg = M.syntax.keyword_function })

  -- `@keyword.operator` matches word-based operators, like `and`, `or`, or `not`.
  hl("@keyword.operator", { fg = M.syntax.keyword_operator })

  -- `@keyword.import` matches import/export keywords, like `import`, `from`, or `use`.
  hl("@keyword.import", { fg = M.syntax.keyword_import })

  -- `@keyword.type` matches type-oriented keywords, like `struct`, `enum`, or `class`.
  hl("@keyword.type", { fg = M.syntax.keyword_type })

  -- `@keyword.modifier` matches modifiers like `const`, `static`, or `public`.
  hl("@keyword.modifier", { fg = M.syntax.keyword_modifier })

  -- `@keyword.repeat` matches loop keywords, like `for`, `while`, or `loop`.
  hl("@keyword.repeat", { fg = M.syntax.keyword_repeat })

  -- `@keyword.return` matches return-style keywords, like `return` or `yield`.
  hl("@keyword.return", { fg = M.syntax.keyword_return })

  -- `@keyword.debug` matches debugging keywords, like `breakpoint`-style commands.
  hl("@keyword.debug", { fg = M.syntax.keyword_debug })

  -- `@keyword.exception` matches exception keywords, like `throw` or `catch`.
  hl("@keyword.exception", { fg = M.syntax.keyword_exception })

  -- `@keyword.conditional` matches conditionals, like `if`, `else`, and `elseif`.
  hl("@keyword.conditional", { fg = M.syntax.keyword_conditional })

  -- `@keyword.conditional.ternary` matches ternary operators, like `? :`.
  hl(
    "@keyword.conditional.ternary",
    { fg = M.syntax.keyword_conditional_ternary }
  )

  -- `@keyword.directive` matches preprocessor directives and shebangs, like `#include` or `#!/usr/bin/env sh`.
  hl("@keyword.directive", { fg = M.syntax.keyword_directive })

  -- `@keyword.directive.define` matches directive definitions, like `#define`.
  hl("@keyword.directive.define", { fg = M.syntax.keyword_directive_define })

  -- `@punctuation.delimiter` matches commas, dots, and separators, like `,` or `.`.
  hl("@punctuation.delimiter", { fg = M.syntax.punctuation_delimiter })

  -- `@punctuation.bracket` matches brackets and braces, like `(`, `)`, `{`, or `}`.
  hl("@punctuation.bracket", { fg = M.syntax.punctuation_bracket })

  -- `@punctuation.special` matches special punctuation in interpolations, like `{` in `${var}`.
  hl("@punctuation.special", { fg = M.syntax.punctuation_special })

  -- `@comment` matches comments, like `-- note` or `// note`.
  hl("@comment", { fg = M.syntax.comment })

  -- `@comment.documentation` matches documentation comments, like `/// docs` or `/** docs */`.
  hl("@comment.documentation", { fg = M.syntax.comment_documentation })

  -- `@comment.error` matches error-like comments, like `ERROR` or `BROKEN`.
  hl("@comment.error", { fg = M.syntax.comment_error })

  -- `@comment.warning` matches warning-like comments, like `WARNING` or `HACK`.
  hl("@comment.warning", { fg = M.syntax.comment_warning })

  -- `@comment.todo` matches TODO-style comments, like `TODO`, `FIXME`, or `XXX`.
  hl("@comment.todo", { fg = M.syntax.comment_todo, bold = true })

  -- `@comment.note` matches note-style comments, like `NOTE` or `INFO`.
  hl("@comment.note", { fg = M.syntax.comment_note })

  -- `@text` matches plain prose text.
  hl("@text", { fg = M.syntax.text })

  -- `@text.strong` matches strong emphasis in prose.
  hl("@text.strong", { fg = M.syntax.text_strong, bold = true })

  -- `@text.emphasis` matches emphasized prose text.
  hl("@text.emphasis", { fg = M.syntax.text_emphasis, italic = true })

  -- `@text.strike` matches struck-through prose text.
  hl("@text.strike", { fg = M.syntax.text_strike, strikethrough = true })

  -- `@text.underline` matches underlined prose text.
  hl("@text.underline", { fg = M.syntax.text_underline, underline = true })

  -- `@text.title` matches prose titles and headings.
  hl("@text.title", { fg = M.syntax.text_title, bold = true })

  -- `@text.literal` matches inline literal text.
  hl("@text.literal", { fg = M.syntax.text_literal })

  -- `@text.quote` matches quoted prose blocks.
  hl("@text.quote", { fg = M.syntax.text_quote })

  -- `@text.uri` matches plain URLs in prose.
  hl("@text.uri", { fg = M.syntax.text_uri, underline = true })

  -- `@text.math` matches inline math content.
  hl("@text.math", { fg = M.syntax.text_math })

  -- `@text.todo` matches TODO-style prose markers.
  hl("@text.todo", { fg = M.syntax.text_todo, bold = true })

  -- `@text.note` matches note-style prose markers.
  hl("@text.note", { fg = M.syntax.text_note })

  -- `@text.warning` matches warning-style prose markers.
  hl("@text.warning", { fg = M.syntax.text_warning })

  -- `@text.reference` matches references and citation-like prose.
  hl("@text.reference", { fg = M.syntax.text_reference })

  -- `@markup.strong` matches bold markup, like `**bold**`.
  hl("@markup.strong", { fg = M.syntax.markup_strong, bold = true })

  -- `@markup.italic` matches italic markup, like `*italic*`.
  hl("@markup.italic", { fg = M.syntax.markup_italic, italic = true })

  -- `@markup.strikethrough` matches struck-through markup, like `~~deleted~~`.
  hl(
    "@markup.strikethrough",
    { fg = M.syntax.markup_strikethrough, strikethrough = true }
  )

  -- `@markup.underline` matches underlined markup, like HTML `<u>` text.
  hl("@markup.underline", { fg = M.syntax.markup_underline, underline = true })

  -- `@markup.heading` matches headings and titles, like `# Title`.
  hl("@markup.heading", { fg = M.syntax.markup_heading, bold = true })

  -- `@markup.heading.1` matches top-level headings, like `# Title`.
  hl("@markup.heading.1", { fg = M.syntax.markup_heading_1, bold = true })

  -- `@markup.heading.2` matches second-level headings, like `## Section`.
  hl("@markup.heading.2", { fg = M.syntax.markup_heading_2, bold = true })

  -- `@markup.heading.3` matches third-level headings, like `### Subsection`.
  hl("@markup.heading.3", { fg = M.syntax.markup_heading_3, bold = true })

  -- `@markup.heading.4` matches fourth-level headings, like `#### Topic`.
  hl("@markup.heading.4", { fg = M.syntax.markup_heading_4, bold = true })

  -- `@markup.heading.5` matches fifth-level headings, like `##### Topic`.
  hl("@markup.heading.5", { fg = M.syntax.markup_heading_5, bold = true })

  -- `@markup.heading.6` matches sixth-level headings, like `###### Topic`.
  hl("@markup.heading.6", { fg = M.syntax.markup_heading_6, bold = true })

  -- `@markup.quote` matches block quotes, like `> quoted text`.
  hl("@markup.quote", { fg = M.syntax.markup_quote })

  -- `@markup.math` matches math environments, like `$a^2 + b^2$`.
  hl("@markup.math", { fg = M.syntax.markup_math })

  -- `@markup.link` matches references and citations, like `[label](url)`.
  hl("@markup.link", { fg = M.syntax.markup_link, underline = true })

  -- `@markup.link.label` matches link labels, like the `label` part in `[label](url)`.
  hl("@markup.link.label", { fg = M.syntax.markup_link_label })

  -- `@markup.link.url` matches URL-style links, like `https://example.com`.
  hl("@markup.link.url", { fg = M.syntax.markup_link_url, underline = true })

  -- `@markup.raw` matches inline raw text, like ``code`` or `printf`.
  hl("@markup.raw", { fg = M.syntax.markup_raw })

  -- `@markup.raw.block` matches raw block text, like fenced code blocks.
  hl("@markup.raw.block", { fg = M.syntax.markup_raw_block })

  -- `@markup.list` matches list markers, like `-` or `*`.
  hl("@markup.list", { fg = M.syntax.markup_list })

  -- `@markup.list.checked` matches checked list markers, like `[x]`.
  hl("@markup.list.checked", { fg = M.syntax.markup_list_checked })

  -- `@markup.list.unchecked` matches unchecked list markers, like `[ ]`.
  hl("@markup.list.unchecked", { fg = M.syntax.markup_list_unchecked })

  -- `@diff.plus` matches added text, like a line prefixed with `+`.
  hl("@diff.plus", { fg = M.syntax.diff_plus })

  -- `@diff.minus` matches deleted text, like a line prefixed with `-`.
  hl("@diff.minus", { fg = M.syntax.diff_minus })

  -- `@diff.delta` matches changed text, like a modified hunk header.
  hl("@diff.delta", { fg = M.syntax.diff_delta })

  -- `@tag` matches XML/HTML-style tag names, like `div` or `section`.
  hl("@tag", { fg = M.syntax.tag })

  -- `@tag.builtin` matches built-in tag names, like HTML `div` or `span`.
  hl("@tag.builtin", { fg = M.syntax.tag_builtin })

  -- `@tag.attribute` matches XML/HTML-style tag attributes, like `class` or `href`.
  hl("@tag.attribute", { fg = M.syntax.tag_attribute })

  -- `@tag.delimiter` matches XML/HTML-style tag delimiters, like `<`, `>`, or `</`.
  hl("@tag.delimiter", { fg = M.syntax.tag_delimiter })
end

return M
