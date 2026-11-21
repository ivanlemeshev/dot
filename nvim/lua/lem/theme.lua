--- *lem.theme* Shared color definitions for Neovim and plugins
---
--- MIT License Copyright (c) 2026 Ivan Lemeshev
local M = {}

local palette_state = vim.env.DOTFILES_PALETTE_STATE
  or vim.fn.expand("~/.local/state/dotfiles-palette")

local function minimal_highlighting()
  local mode = vim.env.DOTFILES_HIGHLIGHT_MODE
  if mode then
    return mode == "min"
  end
  local path = palette_state .. "/mode"
  return vim.fn.filereadable(path) == 1
    and vim.trim(vim.fn.readfile(path, "", 1)[1] or "") == "min"
end

local minimal = minimal_highlighting()

local ansi = {
  black = 0,
  red = 1,
  green = 2,
  yellow = 3,
  blue = 4,
  magenta = 5,
  cyan = 6,
  white = 7,
  bright_black = 8,
  bright_red = 9,
  bright_green = 10,
  bright_yellow = 11,
  bright_blue = 12,
  bright_magenta = 13,
  bright_cyan = 14,
  bright_white = 15,
}

local function selection_colors()
  local path = palette_state .. "/selection"
  if vim.fn.filereadable(path) == 1 then
    local name = vim.trim(vim.fn.readfile(path, "", 1)[1] or "")
    local source = vim.fn.resolve(debug.getinfo(1, "S").source:sub(2))
    local root = vim.fn.fnamemodify(source, ":h:h:h:h")
    local colors = root .. "/palettes/selection-colors.txt"
    if vim.fn.filereadable(colors) == 1 then
      for _, line in ipairs(vim.fn.readfile(colors)) do
        local palette, fg, bg = line:match("^(%S+) (%d+) (%d+)$")
        if palette == name then
          return tonumber(fg), tonumber(bg)
        end
      end
    end
  end
  return ansi.black, ansi.bright_black
end

local selection_fg, selection_bg = selection_colors()

-- UI
M.ui = {
  cursor = ansi.white,
  cursor_line_nr = ansi.yellow,
  directory_fg = ansi.blue,
  end_of_buffer_fg = ansi.bright_black,
  error_fg = ansi.bright_red,
  float_border_fg = ansi.bright_black,
  float_title_fg = ansi.white,
  fg = ansi.white,
  line_nr = ansi.bright_black,
  matchparen_bg = ansi.cyan,
  non_text = ansi.bright_black,
  more_fg = ansi.yellow,
  msg_separator_fg = ansi.bright_black,
  pmenu_thumb_bg = ansi.white,
  question_fg = ansi.blue,
  split_fg = ansi.bright_black,
  statusline_bg = ansi.black,
  statusline_fg = ansi.bright_white,
  statusline_nc_bg = ansi.black,
  statusline_nc_fg = ansi.bright_white,
  special_key = ansi.bright_black,
  tabline_bg = ansi.black,
  tabline_fill_bg = ansi.black,
  tabline_fg = ansi.bright_black,
  title_fg = ansi.yellow,
  warning_fg = ansi.bright_yellow,
  winbar_bg = ansi.black,
  winbar_fg = ansi.white,
  winbar_nc_bg = ansi.black,
  winbar_nc_fg = ansi.bright_black,
  whitespace = ansi.bright_black,
}

-- Syntax
M.syntax = {
  comment = ansi.bright_black,
  constant = ansi.magenta,
  constant_builtin = ansi.magenta,
  constant_macro = ansi.magenta,
  error = ansi.bright_red,
  delimiter = ansi.white,
  character = ansi.green,
  character_special = ansi.yellow,
  float = ansi.magenta,
  variable_builtin = ansi.magenta,
  variable_parameter = ansi.white,
  variable_parameter_builtin = ansi.magenta,
  variable_member = ansi.blue,
  identifier = ansi.white,
  namespace = ansi.blue,
  namespace_builtin = ansi.blue,
  field = ansi.blue,
  field_builtin = ansi.blue,
  parameter = ansi.white,
  parameter_builtin = ansi.white,
  boolean = ansi.magenta,
  module = ansi.blue,
  module_builtin = ansi.blue,
  label = ansi.yellow,
  statement = ansi.red,
  conditional = ansi.red,
  ["repeat"] = ansi.red,
  exception = ansi.red,
  attribute = ansi.magenta,
  attribute_builtin = ansi.magenta,
  property = ansi.blue,
  constructor = ansi.yellow,
  include = ansi.red,
  define = ansi.red,
  macro = ansi.magenta,
  precondit = ansi.red,
  text = ansi.white,
  text_strong = ansi.yellow,
  text_emphasis = ansi.white,
  text_strike = ansi.white,
  text_underline = ansi.blue,
  text_title = ansi.yellow,
  text_literal = ansi.cyan,
  text_quote = ansi.white,
  text_uri = ansi.blue,
  text_math = ansi.blue,
  text_todo = ansi.bright_yellow,
  text_note = ansi.blue,
  text_warning = ansi.yellow,
  text_reference = ansi.white,
  ["function"] = ansi.yellow,
  function_builtin = ansi.yellow,
  function_call = ansi.yellow,
  function_macro = ansi.yellow,
  function_method = ansi.yellow,
  function_method_call = ansi.yellow,
  keyword = ansi.red,
  keyword_coroutine = ansi.red,
  keyword_function = ansi.red,
  keyword_operator = ansi.red,
  keyword_import = ansi.red,
  keyword_type = ansi.red,
  keyword_modifier = ansi.red,
  keyword_repeat = ansi.red,
  keyword_return = ansi.red,
  keyword_debug = ansi.red,
  keyword_exception = ansi.red,
  keyword_conditional = ansi.red,
  keyword_conditional_ternary = ansi.red,
  keyword_directive = ansi.red,
  keyword_directive_define = ansi.red,
  number = ansi.magenta,
  number_float = ansi.magenta,
  operator = ansi.cyan,
  preproc = ansi.red,
  storageclass = ansi.yellow,
  structure = ansi.blue,
  typedef = ansi.blue,
  punctuation_delimiter = ansi.white,
  punctuation_bracket = ansi.white,
  punctuation_special = ansi.yellow,
  special = ansi.yellow,
  comment_special = ansi.bright_black,
  debug = ansi.white,
  underlined = ansi.blue,
  todo = ansi.bright_yellow,
  string = ansi.green,
  string_documentation = ansi.green,
  string_regexp = ansi.cyan,
  string_escape = ansi.cyan,
  string_special = ansi.yellow,
  string_special_symbol = ansi.yellow,
  string_special_path = ansi.blue,
  string_special_url = ansi.blue,
  type = ansi.blue,
  type_builtin = ansi.blue,
  type_definition = ansi.blue,
  variable = ansi.white,
  comment_documentation = ansi.bright_black,
  comment_error = ansi.bright_red,
  comment_warning = ansi.bright_yellow,
  comment_todo = ansi.bright_yellow,
  comment_note = ansi.blue,
  markup_strong = ansi.yellow,
  markup_italic = ansi.white,
  markup_strikethrough = ansi.white,
  markup_underline = ansi.blue,
  markup_heading = ansi.yellow,
  markup_heading_1 = ansi.yellow,
  markup_heading_2 = ansi.yellow,
  markup_heading_3 = ansi.yellow,
  markup_heading_4 = ansi.yellow,
  markup_heading_5 = ansi.yellow,
  markup_heading_6 = ansi.yellow,
  markup_quote = ansi.white,
  markup_math = ansi.blue,
  markup_link = ansi.blue,
  markup_link_label = ansi.blue,
  markup_link_url = ansi.blue,
  markup_raw = ansi.white,
  markup_raw_block = ansi.white,
  markup_list = ansi.white,
  markup_list_checked = ansi.green,
  markup_list_unchecked = ansi.white,
  diff_plus = ansi.green,
  diff_minus = ansi.red,
  diff_delta = ansi.yellow,
  tag = ansi.green,
  tag_builtin = ansi.green,
  tag_attribute = ansi.blue,
  tag_delimiter = ansi.green,
}

if minimal then
  local definitions = {
    ["function"] = true,
    function_method = true,
    constructor = true,
    structure = true,
    typedef = true,
    type_definition = true,
  }
  for role in pairs(M.syntax) do
    if definitions[role] then
      M.syntax[role] = ansi.yellow
    elseif role:match("^string") or role == "character" then
      M.syntax[role] = ansi.green
    elseif
      not role:match("^comment")
      and not role:match("^markup_")
      and not role:match("^text_")
      and not role:match("^diff_")
      and role ~= "todo"
      and role ~= "error"
    then
      M.syntax[role] = ansi.white
    end
  end
end

-- Fzf
M.fzf = {
  hl = ansi.yellow,
  info = ansi.bright_black,
  border = ansi.bright_black,
  ghost = ansi.bright_black,
  disabled = ansi.bright_black,
  prompt = not minimal and ansi.yellow or nil,
  pointer = ansi.blue,
  marker = ansi.blue,
  spinner = minimal and ansi.bright_black or ansi.yellow,
  header = ansi.bright_black,
  label = ansi.bright_black,
}

function M.fzf_colors()
  local colors = {
    "16",
    "fg:-1",
    "bg:-1",
    "query:-1",
    "gutter:-1",
    "fg+:" .. selection_fg .. ":strip",
    "bg+:" .. selection_bg,
    "hl+:" .. selection_fg .. ":strip:underline",
    "selected-fg:" .. selection_fg .. ":strip",
    "selected-bg:" .. selection_bg,
    "selected-hl:" .. selection_fg .. ":strip:underline",
    "prompt:" .. (M.fzf.prompt or -1),
  }
  local palette = M.fzf
  for _, role in ipairs({
    "hl",
    "ghost",
    "disabled",
    "info",
    "border",
    "pointer",
    "marker",
    "spinner",
    "header",
    "label",
  }) do
    colors[#colors + 1] = role .. ":" .. palette[role]
  end

  return table.concat(colors, ",")
end

-- FzfLua
M.fzf_lua = {
  border_fg = M.fzf.border,
  title_fg = M.fzf.hl,
  preview_border_fg = M.fzf.border,
  search_fg = ansi.black,
  search_bg = M.fzf.hl,
}

-- StatusLine
M.statusline = {
  insert_bg = ansi.black,
  insert_fg = ansi.green,
  visual_bg = ansi.black,
  visual_fg = ansi.magenta,
  replace_bg = ansi.black,
  replace_fg = ansi.red,
  command_bg = ansi.black,
  command_fg = ansi.cyan,
  terminal_bg = ansi.black,
  terminal_fg = ansi.blue,
  section_bg = ansi.black,
  section_fg = ansi.bright_white,
  inactive_bg = ansi.black,
  inactive_fg = ansi.bright_white,
}

-- Git
M.git = {
  clean = ansi.green,
  dirty = ansi.yellow,
  ahead = ansi.blue,
  behind = ansi.yellow,
  add = ansi.green,
  change = ansi.yellow,
  delete = ansi.red,
  rename = ansi.blue,
  ignored = ansi.bright_black,
  blame = ansi.bright_black,
}

-- Diagnostic
M.diagnostic = {
  error = ansi.bright_red,
  warn = ansi.bright_yellow,
  info = ansi.cyan,
  hint = ansi.blue,
  ok = ansi.green,
}

-- lualine theme
M.lualine_theme = {
  normal = {
    a = {
      bg = M.statusline.section_bg,
      fg = M.statusline.section_fg,
      gui = "underline",
    },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
  },
  insert = {
    a = { bg = M.statusline.insert_bg, fg = M.statusline.insert_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
  },
  visual = {
    a = { bg = M.statusline.visual_bg, fg = M.statusline.visual_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
  },
  replace = {
    a = { bg = M.statusline.replace_bg, fg = M.statusline.replace_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
  },
  command = {
    a = { bg = M.statusline.command_bg, fg = M.statusline.command_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
  },
  terminal = {
    a = { bg = M.statusline.terminal_bg, fg = M.statusline.terminal_fg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
  },
  inactive = {
    a = { bg = M.statusline.inactive_bg, fg = M.statusline.inactive_fg },
    b = { bg = M.statusline.inactive_bg, fg = M.statusline.inactive_fg },
    c = { bg = M.statusline.inactive_bg, fg = M.statusline.inactive_fg },
    z = { bg = M.statusline.inactive_bg, fg = M.statusline.inactive_fg },
  },
}

function M.icon_color(color)
  if minimal then
    return ansi.white
  end
  local red = tonumber(color:sub(2, 3), 16) / 255
  local green = tonumber(color:sub(4, 5), 16) / 255
  local blue = tonumber(color:sub(6, 7), 16) / 255
  local maximum = math.max(red, green, blue)
  local delta = maximum - math.min(red, green, blue)
  if delta < 0.15 then
    return ansi.white
  end

  -- NOTE: Hue preserves icon color families across terminal palettes.
  local hue
  if maximum == red then
    hue = ((green - blue) / delta) % 6
  elseif maximum == green then
    hue = (blue - red) / delta + 2
  else
    hue = (red - green) / delta + 4
  end
  local colors =
    { ansi.red, ansi.yellow, ansi.green, ansi.cyan, ansi.blue, ansi.magenta }
  return colors[math.floor(hue + 0.5) % 6 + 1]
end

function M.setup_inline_diagnostics()
  local prefix = "TinyInlineDiagnosticVirtualText"
  local inverse = "TinyInlineInvDiagnosticVirtualText"
  local severities = {
    Error = M.diagnostic.error,
    Warn = M.diagnostic.warn,
    Info = M.diagnostic.info,
    Hint = M.diagnostic.hint,
  }

  vim.api.nvim_set_hl(0, prefix .. "Bg", {})
  for _, suffix in ipairs({ "", "NoBg" }) do
    vim.api.nvim_set_hl(0, prefix .. "Arrow" .. suffix, {})
  end

  for name, color in pairs(severities) do
    for _, suffix in ipairs({ "", "CursorLine", "NoBg" }) do
      vim.api.nvim_set_hl(0, prefix .. name .. suffix, {
        ctermfg = color,
      })
      vim.api.nvim_set_hl(0, inverse .. name .. suffix, {})
    end
    for other in pairs(severities) do
      vim.api.nvim_set_hl(0, prefix .. name .. "Mix" .. other, {
        ctermfg = color,
      })
    end
  end
end

function M.setup()
  vim.opt.termguicolors = false
  M.setup_inline_diagnostics()

  local function hl(group, opts)
    opts.ctermfg = opts.fg
    opts.ctermbg = opts.bg
    opts.fg = nil
    opts.bg = nil
    opts.sp = nil
    -- NOTE: Some terminals use bright ANSI colors for bold text.
    opts.cterm = { bold = false }
    for _, attr in ipairs({
      "italic",
      "underline",
      "undercurl",
      "strikethrough",
      "reverse",
      "nocombine",
    }) do
      opts.cterm[attr] = opts[attr]
    end
    vim.api.nvim_set_hl(0, group, opts)
  end

  hl("DiffAdd", { fg = ansi.green })
  hl("DiffChange", { fg = ansi.yellow })
  hl("DiffDelete", { fg = ansi.red })
  hl("DiffText", { fg = ansi.black, bg = ansi.yellow })
  hl("DiffTextAdd", { fg = ansi.black, bg = ansi.green })

  hl("PmenuMatch", { fg = ansi.yellow, underline = true })
  hl(
    "PmenuMatchSel",
    { fg = selection_fg, bg = selection_bg, nocombine = true, underline = true }
  )
  hl("PmenuKind", { fg = ansi.bright_black })
  hl("PmenuExtra", { fg = ansi.bright_black })
  hl("PmenuKindSel", { fg = selection_fg, bg = selection_bg, nocombine = true })
  hl(
    "PmenuExtraSel",
    { fg = selection_fg, bg = selection_bg, nocombine = true }
  )
  hl("FloatFooter", { fg = ansi.bright_black })
  hl("Conceal", { fg = ansi.white })
  hl("CursorLineSign", {})
  hl("CursorLineFold", {})

  for _, name in ipairs({ "SpellBad", "SpellCap", "SpellLocal", "SpellRare" }) do
    hl(name, { undercurl = true })
  end

  hl("IblIndent", { fg = ansi.bright_black })
  hl("IblWhitespace", { fg = ansi.bright_black })
  hl("IblScope", { fg = ansi.blue })
  hl("MiniIndentscopeSymbol", { fg = ansi.blue })
  hl("MiniHipatternsFixme", { fg = ansi.black, bg = ansi.bright_red })
  hl("MiniHipatternsHack", { fg = ansi.black, bg = ansi.magenta })
  hl("MiniHipatternsTodo", { fg = ansi.black, bg = ansi.bright_yellow })
  hl("MiniHipatternsWarning", { fg = ansi.black, bg = ansi.bright_yellow })
  hl("MiniHipatternsNote", { fg = ansi.black, bg = ansi.blue })

  -- Neovim UI

  -- NOTE: Terminal defaults apply to normal text.
  hl("Normal", {})

  hl("NormalNC", {})

  hl("Cursor", { fg = ansi.black, bg = M.ui.cursor })

  hl("CursorLine", {})

  hl("CursorColumn", {})

  hl("CursorLineNr", { fg = M.ui.cursor_line_nr, bold = true })

  hl("ColorColumn", {})

  hl("LineNr", { fg = M.ui.line_nr })

  hl("SignColumn", {})

  hl("FoldColumn", { fg = M.ui.non_text })

  hl("Folded", {})

  hl("Search", { reverse = true })

  hl("CurSearch", { reverse = true, underline = true })

  hl("IncSearch", { reverse = true, underline = true })

  hl("LspReferenceText", { underline = true })
  hl("LspReferenceRead", { underline = true })
  hl("LspReferenceWrite", { underline = true })

  hl("Visual", { fg = selection_fg, bg = selection_bg, nocombine = true })

  hl("VisualNOS", { fg = selection_fg, bg = selection_bg, nocombine = true })

  hl("Pmenu", {})

  hl("PmenuBorder", { fg = M.ui.float_border_fg })

  hl("PmenuSel", { fg = selection_fg, bg = selection_bg, nocombine = true })

  hl("PmenuSbar", {})

  hl("PmenuThumb", { bg = M.ui.pmenu_thumb_bg })

  hl("NormalFloat", {})

  hl("FloatBorder", { fg = M.ui.float_border_fg })

  hl("FloatTitle", { fg = M.ui.float_title_fg, bold = true })

  hl("StatusLine", { fg = M.ui.statusline_fg, bg = M.ui.statusline_bg })

  hl("StatusLineNC", { fg = M.ui.statusline_nc_fg, bg = M.ui.statusline_nc_bg })

  hl("TabLine", { fg = M.ui.tabline_fg, bg = M.ui.tabline_bg })

  hl(
    "TabLineSel",
    { fg = M.ui.statusline_fg, bg = M.ui.tabline_fill_bg, underline = true }
  )

  hl("TabLineFill", { bg = M.ui.tabline_fill_bg })

  hl("VertSplit", { fg = M.ui.split_fg })

  hl("WinSeparator", { fg = M.ui.split_fg })

  hl("WinBar", { fg = M.ui.winbar_fg, bg = M.ui.winbar_bg })

  hl("WinBarNC", { fg = M.ui.winbar_nc_fg, bg = M.ui.winbar_nc_bg })

  hl("Directory", { fg = M.ui.directory_fg })

  hl("Title", { fg = M.ui.title_fg, bold = true })

  hl("Question", { fg = M.ui.question_fg, bold = true })

  hl("WarningMsg", { fg = M.ui.warning_fg, bold = true })

  hl("ErrorMsg", { fg = M.ui.error_fg, bold = true })

  hl("ModeMsg", {})

  hl("MoreMsg", { fg = M.ui.more_fg, bold = true })

  hl("MsgArea", {})

  hl("MsgSeparator", { fg = M.ui.msg_separator_fg })

  hl("MatchParen", { fg = ansi.black, bg = M.ui.matchparen_bg })

  hl("QuickFixLine", { fg = selection_fg, bg = selection_bg, nocombine = true })

  hl("EndOfBuffer", { fg = M.ui.end_of_buffer_fg })

  hl("NonText", { fg = M.ui.non_text })

  hl("SpecialKey", { fg = M.ui.special_key })

  hl("Whitespace", { fg = M.ui.whitespace })

  -- Mason

  hl("MasonBackdrop", {})

  hl("MasonNormal", {})

  hl("MasonHeader", { fg = M.ui.title_fg, bold = true })

  hl("MasonHeaderSecondary", { fg = M.ui.question_fg, bold = true })

  hl("MasonHighlight", { fg = M.ui.directory_fg })

  hl("MasonHighlightBlock", { fg = ansi.black, bg = M.ui.directory_fg })

  hl(
    "MasonHighlightBlockBold",
    { fg = ansi.black, bg = M.ui.directory_fg, bold = true }
  )

  hl("MasonHighlightSecondary", { fg = M.ui.title_fg })

  hl("MasonHighlightBlockSecondary", { fg = ansi.black, bg = M.ui.title_fg })

  hl(
    "MasonHighlightBlockBoldSecondary",
    { fg = ansi.black, bg = M.ui.title_fg, bold = true }
  )

  hl("MasonLink", { fg = M.ui.directory_fg, underline = true })

  hl("MasonMuted", { fg = M.ui.non_text })

  hl("MasonMutedBlock", { fg = ansi.black, bg = M.ui.non_text })

  hl(
    "MasonMutedBlockBold",
    { fg = ansi.black, bg = M.ui.non_text, bold = true }
  )

  hl("MasonError", { fg = M.ui.error_fg, bold = true })

  hl("MasonWarning", { fg = M.ui.warning_fg, bold = true })

  hl("MasonHeading", { fg = M.ui.title_fg, bold = true })

  -- NvimTree

  hl("NvimTreeNormal", {})

  hl("NvimTreeNormalFloat", {})

  hl("NvimTreeNormalFloatBorder", { fg = M.ui.float_border_fg })

  hl("NvimTreeNormalNC", {})

  hl("NvimTreeLineNr", { fg = M.ui.line_nr })

  hl("NvimTreeWinSeparator", { fg = M.ui.split_fg })

  hl("NvimTreeEndOfBuffer", { fg = M.ui.end_of_buffer_fg })

  hl("NvimTreePopup", {})

  hl("NvimTreeSignColumn", {})

  hl("NvimTreeCursorColumn", {})

  hl(
    "NvimTreeCursorLine",
    { fg = selection_fg, bg = selection_bg, nocombine = true }
  )

  hl("NvimTreeCursorLineNr", { fg = M.ui.cursor_line_nr })

  hl("NvimTreeStatusLine", { fg = M.ui.statusline_fg, bg = M.ui.statusline_bg })

  hl(
    "NvimTreeStatusLineNC",
    { fg = M.ui.statusline_nc_fg, bg = M.ui.statusline_nc_bg }
  )

  hl("NvimTreeExecFile", { fg = ansi.green })

  hl("NvimTreeImageFile", { fg = ansi.cyan })

  hl("NvimTreeSpecialFile", { fg = ansi.yellow })

  hl("NvimTreeSymlink", { fg = ansi.cyan, underline = true })

  hl("NvimTreeRootFolder", { fg = M.ui.title_fg, bold = true })

  hl("NvimTreeFolderName", { fg = M.ui.directory_fg })

  hl("NvimTreeEmptyFolderName", { fg = M.ui.directory_fg })

  hl("NvimTreeOpenedFolderName", { fg = M.ui.directory_fg })

  hl("NvimTreeSymlinkFolderName", { fg = M.ui.directory_fg, underline = true })

  hl("NvimTreeFileIcon", { fg = M.ui.non_text })

  hl("NvimTreeSymlinkIcon", { fg = M.ui.directory_fg })

  hl("NvimTreeFolderIcon", { fg = M.ui.directory_fg })

  hl("NvimTreeOpenedFolderIcon", { fg = M.ui.directory_fg })

  hl("NvimTreeClosedFolderIcon", { fg = M.ui.directory_fg })

  hl("NvimTreeFolderArrowClosed", { fg = M.ui.non_text })

  hl("NvimTreeFolderArrowOpen", { fg = M.ui.non_text })

  hl("NvimTreeIndentMarker", { fg = M.ui.non_text })

  hl(
    "NvimTreeWindowPicker",
    { fg = ansi.black, bg = M.ui.title_fg, bold = true }
  )

  hl("NvimTreeLiveFilterPrefix", { fg = M.ui.title_fg })

  hl("NvimTreeLiveFilterValue", {})

  hl("NvimTreeCutHL", { fg = M.ui.error_fg, bold = true })

  hl("NvimTreeCopiedHL", { fg = M.ui.question_fg, bold = true })

  hl("NvimTreeBookmarkIcon", { fg = M.ui.title_fg })

  hl("NvimTreeBookmarkHL", { fg = M.ui.title_fg, bold = true })

  hl("NvimTreeModifiedIcon", { fg = M.ui.warning_fg })

  hl("NvimTreeModifiedFileHL", { fg = M.ui.warning_fg, bold = true })

  hl("NvimTreeModifiedFolderHL", { fg = M.ui.warning_fg, bold = true })

  hl("NvimTreeHiddenIcon", { fg = M.ui.non_text })

  hl("NvimTreeHiddenFileHL", { fg = M.ui.non_text })

  hl("NvimTreeHiddenFolderHL", { fg = M.ui.non_text })

  hl("NvimTreeHiddenDisplay", { fg = M.ui.non_text })

  hl("NvimTreeOpenedHL", { fg = M.ui.special_key })

  hl("NvimTreeGitDeletedIcon", { fg = M.git.delete })

  hl("NvimTreeGitDirtyIcon", { fg = M.git.change })

  hl("NvimTreeGitIgnoredIcon", { fg = M.git.ignored })

  hl("NvimTreeGitMergeIcon", { fg = M.git.delete, bold = true })

  hl("NvimTreeGitNewIcon", { fg = M.git.add })

  hl("NvimTreeGitRenamedIcon", { fg = M.git.rename })

  hl("NvimTreeGitStagedIcon", { fg = M.git.add })

  hl("NvimTreeGitFileDeletedHL", { fg = M.git.delete })

  hl("NvimTreeGitFileDirtyHL", { fg = M.git.change })

  hl("NvimTreeGitFileIgnoredHL", { fg = M.git.ignored })

  hl("NvimTreeGitFileMergeHL", { fg = M.git.delete, bold = true })

  hl("NvimTreeGitFileNewHL", { fg = M.git.add })

  hl("NvimTreeGitFileRenamedHL", { fg = M.git.rename })

  hl("NvimTreeGitFileStagedHL", { fg = M.git.add })

  hl("NvimTreeGitFolderDeletedHL", { fg = M.git.delete })

  hl("NvimTreeGitFolderDirtyHL", { fg = M.git.change })

  hl("NvimTreeGitFolderIgnoredHL", { fg = M.git.ignored })

  hl("NvimTreeGitFolderMergeHL", { fg = M.git.delete, bold = true })

  hl("NvimTreeGitFolderNewHL", { fg = M.git.add })

  hl("NvimTreeGitFolderRenamedHL", { fg = M.git.rename })

  hl("NvimTreeGitFolderStagedHL", { fg = M.git.add })

  hl("NvimTreeDiagnosticErrorIcon", { fg = M.diagnostic.error })

  hl("NvimTreeDiagnosticWarnIcon", { fg = M.diagnostic.warn })

  hl("NvimTreeDiagnosticInfoIcon", { fg = M.diagnostic.info })

  hl("NvimTreeDiagnosticHintIcon", { fg = M.diagnostic.hint })

  hl(
    "NvimTreeDiagnosticErrorFileHL",
    { fg = M.diagnostic.error, undercurl = true }
  )

  hl(
    "NvimTreeDiagnosticWarnFileHL",
    { fg = M.diagnostic.warn, undercurl = true }
  )

  hl(
    "NvimTreeDiagnosticInfoFileHL",
    { fg = M.diagnostic.info, undercurl = true }
  )

  hl(
    "NvimTreeDiagnosticHintFileHL",
    { fg = M.diagnostic.hint, undercurl = true }
  )

  hl(
    "NvimTreeDiagnosticErrorFolderHL",
    { fg = M.diagnostic.error, undercurl = true }
  )

  hl(
    "NvimTreeDiagnosticWarnFolderHL",
    { fg = M.diagnostic.warn, undercurl = true }
  )

  hl(
    "NvimTreeDiagnosticInfoFolderHL",
    { fg = M.diagnostic.info, undercurl = true }
  )

  hl(
    "NvimTreeDiagnosticHintFolderHL",
    { fg = M.diagnostic.hint, undercurl = true }
  )

  -- FzfLua

  hl("fzf1", { fg = M.fzf.hl, bg = M.ui.statusline_bg })
  hl("fzf2", { fg = ansi.magenta, bg = M.ui.statusline_bg })
  hl("fzf3", { fg = ansi.bright_white, bg = M.ui.statusline_bg })

  hl("FzfLuaNormal", {})

  hl("FzfLuaBorder", { fg = M.fzf_lua.border_fg })

  hl("FzfLuaTitle", { fg = M.fzf_lua.title_fg, bold = true })

  hl("FzfLuaBackdrop", {})

  hl("FzfLuaPreviewNormal", {})

  hl("FzfLuaPreviewBorder", { fg = M.fzf_lua.preview_border_fg })

  hl("FzfLuaPreviewTitle", { fg = M.fzf_lua.title_fg, bold = true })

  hl(
    "FzfLuaCursorLine",
    { fg = selection_fg, bg = selection_bg, nocombine = true }
  )

  hl(
    "FzfLuaSearch",
    { fg = M.fzf_lua.search_fg, bg = M.fzf_lua.search_bg, bold = true }
  )

  hl("FzfLuaTitleFlags", { fg = M.fzf.header, bold = true })

  hl("FzfLuaCursor", { fg = ansi.black, bg = M.fzf.hl })

  hl("FzfLuaCursorLineNr", { fg = M.ui.cursor_line_nr })

  hl("FzfLuaScrollBorderEmpty", { fg = M.fzf.border })

  hl("FzfLuaScrollBorderFull", { fg = M.fzf.hl })

  hl("FzfLuaScrollFloatEmpty", { fg = M.fzf.border })

  hl("FzfLuaScrollFloatFull", { fg = M.fzf.hl })

  hl("FzfLuaHelpNormal", {})

  hl("FzfLuaHelpBorder", { fg = M.fzf.border })

  hl("FzfLuaHeaderBind", { fg = M.fzf.prompt, bold = true })

  hl("FzfLuaHeaderText", { fg = M.fzf.header })

  hl("FzfLuaPathColNr", { fg = M.fzf.info })

  hl("FzfLuaPathLineNr", { fg = M.fzf.info })

  hl("FzfLuaBufName", {})

  hl("FzfLuaBufId", { fg = M.fzf.prompt })

  hl("FzfLuaBufNr", { fg = M.fzf.border })

  hl("FzfLuaBufLineNr", { fg = M.fzf.border })

  hl("FzfLuaBufFlagCur", { fg = M.fzf.header, bold = true })

  hl("FzfLuaBufFlagAlt", { fg = M.fzf.info })

  hl("FzfLuaTabTitle", { fg = M.fzf.info, bold = true })

  hl("FzfLuaTabMarker", { fg = M.fzf.prompt })

  hl("FzfLuaDirIcon", { fg = M.ui.directory_fg })

  hl("FzfLuaDirPart", {})

  hl("FzfLuaFilePart", {})

  hl("FzfLuaLivePrompt", { fg = M.fzf.prompt, bold = true })

  hl("FzfLuaLiveSym", { fg = M.fzf.hl, bold = true })

  hl("FzfLuaCmdEx", { fg = M.fzf.prompt })

  hl("FzfLuaCmdBuf", { fg = M.fzf.info })

  hl("FzfLuaCmdGlobal", { fg = M.fzf.header })

  hl("FzfLuaFzfNormal", {})

  hl(
    "FzfLuaFzfCursorLine",
    { fg = selection_fg, bg = selection_bg, nocombine = true }
  )

  hl("FzfLuaFzfMatch", { fg = M.fzf.hl })

  hl("FzfLuaFzfBorder", { fg = M.fzf.border })

  hl("FzfLuaFzfScrollbar", { fg = M.fzf.border })

  hl("FzfLuaFzfSeparator", { fg = M.fzf.border })

  hl("FzfLuaFzfGutter", {})

  hl("FzfLuaFzfHeader", { fg = M.fzf.header, bold = true })

  hl("FzfLuaFzfInfo", { fg = M.fzf.info })

  hl("FzfLuaFzfPointer", { fg = M.fzf.pointer })

  hl("FzfLuaFzfMarker", { fg = M.fzf.marker })

  hl("FzfLuaFzfSpinner", { fg = M.fzf.spinner })

  -- Diagnostics

  hl("DiagnosticError", { fg = M.diagnostic.error })

  hl("DiagnosticWarn", { fg = M.diagnostic.warn })

  hl("DiagnosticInfo", { fg = M.diagnostic.info })

  hl("DiagnosticHint", { fg = M.diagnostic.hint })

  hl("DiagnosticOk", { fg = M.diagnostic.ok })

  hl("DiagnosticVirtualTextError", { fg = M.diagnostic.error })

  hl("DiagnosticVirtualTextWarn", { fg = M.diagnostic.warn })

  hl("DiagnosticVirtualTextInfo", { fg = M.diagnostic.info })

  hl("DiagnosticVirtualTextHint", { fg = M.diagnostic.hint })

  hl("DiagnosticVirtualTextOk", { fg = M.diagnostic.ok })

  hl("DiagnosticUnderlineError", { sp = M.diagnostic.error, undercurl = true })

  hl("DiagnosticUnderlineWarn", { sp = M.diagnostic.warn, undercurl = true })

  hl("DiagnosticUnderlineInfo", { sp = M.diagnostic.info, undercurl = true })

  hl("DiagnosticUnderlineHint", { sp = M.diagnostic.hint, undercurl = true })

  hl("DiagnosticUnderlineOk", { sp = M.diagnostic.ok, undercurl = true })

  hl("DiagnosticFloatingError", { fg = M.diagnostic.error })

  hl("DiagnosticFloatingWarn", { fg = M.diagnostic.warn })

  hl("DiagnosticFloatingInfo", { fg = M.diagnostic.info })

  hl("DiagnosticFloatingHint", { fg = M.diagnostic.hint })

  hl("DiagnosticFloatingOk", { fg = M.diagnostic.ok })

  hl("DiagnosticSignError", { fg = M.diagnostic.error })

  hl("DiagnosticSignWarn", { fg = M.diagnostic.warn })

  hl("DiagnosticSignInfo", { fg = M.diagnostic.info })

  hl("DiagnosticSignHint", { fg = M.diagnostic.hint })

  hl("DiagnosticSignOk", { fg = M.diagnostic.ok })

  -- Git

  hl("GitSignsAdd", { fg = M.git.add })

  hl("GitSignsAddNr", { fg = M.git.add })

  hl("GitSignsAddLn", { fg = M.git.add })

  hl("GitSignsAddCul", { fg = M.git.add })

  hl("GitSignsStagedAdd", { fg = M.git.add })

  hl("GitSignsStagedAddNr", { fg = M.git.add })

  hl("GitSignsStagedAddLn", { fg = M.git.add })

  hl("GitSignsStagedAddCul", { fg = M.git.add })

  hl("GitSignsChange", { fg = M.git.change })

  hl("GitSignsChangeNr", { fg = M.git.change })

  hl("GitSignsChangeLn", { fg = M.git.change })

  hl("GitSignsChangeCul", { fg = M.git.change })

  hl("GitSignsStagedChange", { fg = M.git.change })

  hl("GitSignsStagedChangeNr", { fg = M.git.change })

  hl("GitSignsStagedChangeLn", { fg = M.git.change })

  hl("GitSignsStagedChangeCul", { fg = M.git.change })

  hl("GitSignsDelete", { fg = M.git.delete })

  hl("GitSignsDeleteNr", { fg = M.git.delete })

  hl("GitSignsDeleteLn", { fg = M.git.delete })

  hl("GitSignsDeleteCul", { fg = M.git.delete })

  hl("GitSignsStagedDelete", { fg = M.git.delete })

  hl("GitSignsStagedDeleteNr", { fg = M.git.delete })

  hl("GitSignsStagedDeleteLn", { fg = M.git.delete })

  hl("GitSignsStagedDeleteCul", { fg = M.git.delete })

  hl("GitSignsStagedTopdelete", { fg = M.git.delete })

  hl("GitSignsStagedChangedelete", { fg = M.git.change })

  hl("GitSignsCurrentLineBlame", { fg = M.git.blame })

  hl("GitSignsAddPreview", { fg = M.git.add })

  hl("GitSignsDeletePreview", { fg = M.git.delete })

  hl("GitSignsNoEOLPreview", { fg = M.git.change })

  hl("GitSignsAddInline", { fg = M.git.add })

  hl("GitSignsChangeInline", { fg = M.git.change })

  hl("GitSignsDeleteInline", { fg = M.git.delete })

  hl("GitSignsAddLnInline", { fg = M.git.add })

  hl("GitSignsChangeLnInline", { fg = M.git.change })

  hl("GitSignsDeleteLnInline", { fg = M.git.delete })

  -- Completion

  hl("CmpItemAbbr", {})

  hl("CmpItemAbbrDeprecated", { fg = M.ui.non_text, strikethrough = true })

  hl("CmpItemAbbrMatch", { fg = M.ui.title_fg, bold = true })

  hl("CmpItemAbbrMatchFuzzy", { fg = M.ui.title_fg, bold = true })

  hl("CmpItemKind", { fg = M.syntax.special })

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

  -- Syntax

  hl("Comment", { fg = M.syntax.comment })

  hl("String", { fg = M.syntax.string })

  hl("Character", { fg = M.syntax.character })

  hl("Number", { fg = M.syntax.number })

  hl("Float", { fg = M.syntax.float })

  hl("Boolean", { fg = M.syntax.boolean })

  hl("Constant", { fg = M.syntax.constant })

  hl("Identifier", { fg = M.syntax.identifier })

  hl("Function", { fg = M.syntax["function"] })

  hl("Statement", { fg = M.syntax.statement })

  hl("Conditional", { fg = M.syntax.conditional })

  hl("Repeat", { fg = M.syntax["repeat"] })

  hl("Label", { fg = M.syntax.label })

  hl("Operator", { fg = M.syntax.operator })

  hl("Keyword", { fg = M.syntax.keyword })

  hl("Exception", { fg = M.syntax.exception })

  hl("PreProc", { fg = M.syntax.preproc })

  hl("Include", { fg = M.syntax.include })

  hl("Define", { fg = M.syntax.define })

  hl("Macro", { fg = M.syntax.macro })

  hl("PreCondit", { fg = M.syntax.precondit })

  hl("Type", { fg = M.syntax.type })

  hl("StorageClass", { fg = M.syntax.storageclass })

  hl("Structure", { fg = M.syntax.structure })

  hl("Typedef", { fg = M.syntax.typedef })

  hl("Special", { fg = M.syntax.special })

  hl("SpecialChar", { fg = M.syntax.character_special })

  hl("Tag", { fg = M.syntax.tag })

  hl("Delimiter", { fg = M.syntax.delimiter })

  hl("SpecialComment", { fg = M.syntax.comment_special })

  hl("Debug", { fg = M.syntax.debug })

  hl("Underlined", { fg = M.syntax.underlined, underline = true })

  hl("Error", { fg = M.syntax.error, bold = true })

  hl("Todo", { fg = M.syntax.todo, bold = true })

  -- Treesitter

  hl("@variable", { fg = M.syntax.variable })

  hl("@variable.builtin", { fg = M.syntax.variable_builtin })

  hl("@variable.parameter", { fg = M.syntax.variable_parameter })

  hl(
    "@variable.parameter.builtin",
    { fg = M.syntax.variable_parameter_builtin }
  )

  hl("@variable.member", { fg = M.syntax.variable_member })

  hl("@namespace", { fg = M.syntax.namespace })

  hl("@namespace.builtin", { fg = M.syntax.namespace_builtin })

  hl("@field", { fg = M.syntax.field })

  hl("@field.builtin", { fg = M.syntax.field_builtin })

  hl("@parameter", { fg = M.syntax.parameter })

  hl("@parameter.builtin", { fg = M.syntax.parameter_builtin })

  hl("@constant", { fg = M.syntax.constant })

  hl("@constant.builtin", { fg = M.syntax.constant_builtin })

  hl("@constant.macro", { fg = M.syntax.constant_macro })

  hl("@module", { fg = M.syntax.module })

  hl("@module.builtin", { fg = M.syntax.module_builtin })

  hl("@label", { fg = M.syntax.label })

  hl("@string", { fg = M.syntax.string })

  hl("@string.documentation", { fg = M.syntax.string_documentation })

  hl("@string.regexp", { fg = M.syntax.string_regexp })

  hl("@string.escape", { fg = M.syntax.string_escape })

  hl("@string.special", { fg = M.syntax.string_special })

  hl("@string.special.symbol", { fg = M.syntax.string_special_symbol })

  hl("@string.special.path", { fg = M.syntax.string_special_path })

  hl("@string.special.url", { fg = M.syntax.string_special_url })

  hl("@character", { fg = M.syntax.character })

  hl("@character.special", { fg = M.syntax.character_special })

  hl("@boolean", { fg = M.syntax.boolean })

  hl("@number", { fg = M.syntax.number })

  hl("@number.float", { fg = M.syntax.number_float })

  hl("@type", { fg = M.syntax.type })

  hl("@type.builtin", { fg = M.syntax.type_builtin })

  hl("@type.definition", { fg = M.syntax.type_definition })

  hl("@attribute", { fg = M.syntax.attribute })

  hl("@attribute.builtin", { fg = M.syntax.attribute_builtin })

  hl("@property", { fg = M.syntax.property })

  hl("@function", { fg = M.syntax["function"] })

  hl("@function.builtin", { fg = M.syntax.function_builtin })

  hl("@function.call", { fg = M.syntax.function_call })

  hl("@function.macro", { fg = M.syntax.function_macro })

  hl("@function.method", { fg = M.syntax.function_method })

  hl("@function.method.call", { fg = M.syntax.function_method_call })

  hl("@constructor", { fg = M.syntax.constructor })

  hl("@operator", { fg = M.syntax.operator })

  hl("@keyword", { fg = M.syntax.keyword })

  hl("@keyword.coroutine", { fg = M.syntax.keyword_coroutine })

  hl("@keyword.function", { fg = M.syntax.keyword_function })

  hl("@keyword.operator", { fg = M.syntax.keyword_operator })

  hl("@keyword.import", { fg = M.syntax.keyword_import })

  hl("@keyword.type", { fg = M.syntax.keyword_type })

  hl("@keyword.modifier", { fg = M.syntax.keyword_modifier })

  hl("@keyword.repeat", { fg = M.syntax.keyword_repeat })

  hl("@keyword.return", { fg = M.syntax.keyword_return })

  hl("@keyword.debug", { fg = M.syntax.keyword_debug })

  hl("@keyword.exception", { fg = M.syntax.keyword_exception })

  hl("@keyword.conditional", { fg = M.syntax.keyword_conditional })

  hl(
    "@keyword.conditional.ternary",
    { fg = M.syntax.keyword_conditional_ternary }
  )

  hl("@keyword.directive", { fg = M.syntax.keyword_directive })

  hl("@keyword.directive.define", { fg = M.syntax.keyword_directive_define })

  hl("@punctuation.delimiter", { fg = M.syntax.punctuation_delimiter })

  hl("@punctuation.bracket", { fg = M.syntax.punctuation_bracket })

  hl("@punctuation.special", { fg = M.syntax.punctuation_special })

  hl("@comment", { fg = M.syntax.comment })

  hl("@comment.documentation", { fg = M.syntax.comment_documentation })

  hl("@comment.error", { fg = M.syntax.comment_error })

  hl("@comment.warning", { fg = M.syntax.comment_warning })

  hl("@comment.todo", { fg = M.syntax.comment_todo, bold = true })

  hl("@comment.note", { fg = M.syntax.comment_note })

  hl("@text", { fg = M.syntax.text })

  hl("@text.strong", { fg = M.syntax.text_strong, bold = true })

  hl("@text.emphasis", { fg = M.syntax.text_emphasis, italic = true })

  hl("@text.strike", { fg = M.syntax.text_strike, strikethrough = true })

  hl("@text.underline", { fg = M.syntax.text_underline, underline = true })

  hl("@text.title", { fg = M.syntax.text_title, bold = true })

  hl("@text.literal", { fg = M.syntax.text_literal })

  hl("@text.quote", { fg = M.syntax.text_quote })

  hl("@text.uri", { fg = M.syntax.text_uri, underline = true })

  hl("@text.math", { fg = M.syntax.text_math })

  hl("@text.todo", { fg = M.syntax.text_todo, bold = true })

  hl("@text.note", { fg = M.syntax.text_note })

  hl("@text.warning", { fg = M.syntax.text_warning })

  hl("@text.reference", { fg = M.syntax.text_reference })

  hl("@markup.strong", { fg = M.syntax.markup_strong, bold = true })

  hl("@markup.italic", { fg = M.syntax.markup_italic, italic = true })

  hl(
    "@markup.strikethrough",
    { fg = M.syntax.markup_strikethrough, strikethrough = true }
  )

  hl("@markup.underline", { fg = M.syntax.markup_underline, underline = true })

  hl("@markup.heading", { fg = M.syntax.markup_heading, bold = true })

  hl("@markup.heading.1", { fg = M.syntax.markup_heading_1, bold = true })

  hl("@markup.heading.2", { fg = M.syntax.markup_heading_2, bold = true })

  hl("@markup.heading.3", { fg = M.syntax.markup_heading_3, bold = true })

  hl("@markup.heading.4", { fg = M.syntax.markup_heading_4, bold = true })

  hl("@markup.heading.5", { fg = M.syntax.markup_heading_5, bold = true })

  hl("@markup.heading.6", { fg = M.syntax.markup_heading_6, bold = true })

  hl("@markup.quote", { fg = M.syntax.markup_quote })

  hl("@markup.math", { fg = M.syntax.markup_math })

  hl("@markup.link", { fg = M.syntax.markup_link, underline = true })

  hl("@markup.link.label", { fg = M.syntax.markup_link_label })

  hl("@markup.link.url", { fg = M.syntax.markup_link_url, underline = true })

  hl("@markup.raw", { fg = M.syntax.markup_raw })

  hl("@markup.raw.block", { fg = M.syntax.markup_raw_block })

  hl("@markup.list", { fg = M.syntax.markup_list })

  hl("@markup.list.checked", { fg = M.syntax.markup_list_checked })

  hl("@markup.list.unchecked", { fg = M.syntax.markup_list_unchecked })

  hl("@diff.plus", { fg = M.syntax.diff_plus })

  hl("@diff.minus", { fg = M.syntax.diff_minus })

  hl("@diff.delta", { fg = M.syntax.diff_delta })

  hl("@tag", { fg = M.syntax.tag })

  hl("@tag.builtin", { fg = M.syntax.tag_builtin })

  hl("@tag.attribute", { fg = M.syntax.tag_attribute })

  hl("@tag.delimiter", { fg = M.syntax.tag_delimiter })
end

return M
