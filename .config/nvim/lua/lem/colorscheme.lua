-- Custom colorscheme (no external dependency)

local M = {}

-- Palette (matches color/schemes/gruvbox-dark-material.yaml)
M.palette = {
  bg_dim = "#1b1b1b",
  bg0 = "#282828",
  bg1 = "#32302f",
  bg2 = "#32302f",
  bg3 = "#45403d",
  bg4 = "#45403d",
  bg5 = "#5a524c",
  bg_statusline1 = "#32302f",
  bg_statusline2 = "#3a3735",
  bg_statusline3 = "#504945",
  bg_visual = "#45403d",
  bg_visual_red = "#4c3432",
  bg_visual_yellow = "#4f422e",
  bg_visual_green = "#3b4439",
  bg_visual_blue = "#374141",
  bg_visual_purple = "#443840",
  bg_diff_red = "#402120",
  bg_diff_green = "#34381b",
  bg_diff_blue = "#0e363e",
  bg_current_word = "#3c3836",
  fg0 = "#d4be98",
  fg1 = "#ddc7a1",
  grey0 = "#7c6f64",
  grey1 = "#928374",
  grey2 = "#a89984",
  red = "#ea6962",
  orange = "#e78a4e",
  yellow = "#d8a657",
  green = "#a9b665",
  aqua = "#89b482",
  blue = "#7daea3",
  purple = "#d3869b",
}

M.fzf_roles = {
  foreground = "#d4be98",
  background = "#282828",
  selected_background = "#32302f",
  muted = "#928374",
  match = "#a9b665",
  selected_match = "#89b482",
  info = "#89b482",
  marker = "#d8a657",
  prompt = "#e78a4e",
  spinner = "#d8a657",
  pointer = "#7daea3",
  border = "#928374",
  header = "#928374",
  label = "#d4be98",
  query = "#d4be98",
  gutter = "#282828",
}

M.ui = {
  bg = "#282828",
  bg_alt = "#32302f",
  bg_dim = "#1b1b1b",
  fg = "#d4be98",
  fg_alt = "#ddc7a1",
  fg_dim = "#928374",
  muted = "#928374",
  border = "#928374",
  border_active = "#a89984",
  selection = "#45403d",
  visual = "#45403d",
  cursorline = "#32302f",
  search_bg = "#d8a657",
  search_fg = "#282828",
  inc_search_bg = "#e78a4e",
  inc_search_fg = "#282828",
  popup_bg = "#282828",
  popup_sel = "#45403d",
  status_bg = "#32302f",
  status_fg = "#ddc7a1",
  status_inactive_fg = "#928374",
}

M.syntax = {
  comment = "#928374",
  string = "#a9b665",
  escape = "#d8a657",
  number = "#d3869b",
  constant = "#89b482",
  keyword = "#ea6962",
  operator = "#e78a4e",
  type = "#d8a657",
  ["function"] = "#a9b665",
  variable = "#7daea3",
  property = "#7daea3",
  builtin = "#ea6962",
  preproc = "#d3869b",
  special = "#d8a657",
  delimiter = "#d4be98",
}

M.diagnostic = {
  error = "#ea6962",
  warn = "#d8a657",
  info = "#7daea3",
  hint = "#d3869b",
  ok = "#a9b665",
}

M.diff = {
  add = "#a9b665",
  change = "#7daea3",
  delete = "#ea6962",
  text = "#7daea3",
  add_bg = "#34381b",
  change_bg = "#0e363e",
  delete_bg = "#402120",
  text_bg = "#374141",
}

M.tool = {
  prompt = "#d8a657",
  prompt_alt = "#e78a4e",
  path = "#7daea3",
  root = "#ea6962",
  duration = "#d8a657",
  git_clean = "#a9b665",
  git_dirty = "#d8a657",
  git_ahead = "#7daea3",
  git_behind = "#ea6962",
  directory = "#7daea3",
  executable = "#a9b665",
  symlink = "#89b482",
  archive = "#d8a657",
  media = "#89b482",
  document = "#d8a657",
  backup = "#7c6f64",
}

local function hex_to_rgb(hex)
  local clean = hex:gsub("#", "")
  return tonumber(clean:sub(1, 2), 16),
    tonumber(clean:sub(3, 4), 16),
    tonumber(clean:sub(5, 6), 16)
end

local function relative_luminance(hex)
  local function channel(c)
    c = c / 255
    if c <= 0.03928 then
      return c / 12.92
    end
    return ((c + 0.055) / 1.055) ^ 2.4
  end

  local r, g, b = hex_to_rgb(hex)
  return 0.2126 * channel(r) + 0.7152 * channel(g) + 0.0722 * channel(b)
end

local function contrast_ratio(a, b)
  local l1 = relative_luminance(a)
  local l2 = relative_luminance(b)
  local lighter = math.max(l1, l2)
  local darker = math.min(l1, l2)
  return (lighter + 0.05) / (darker + 0.05)
end

local function best_contrast_fg(bg, a, b)
  if contrast_ratio(bg, a) >= contrast_ratio(bg, b) then
    return a
  end
  return b
end

M.lualine_theme = {
  normal = {
    a = {
      bg = M.palette.grey2,
      fg = best_contrast_fg(
        M.palette.grey2,
        M.palette.bg0,
        M.palette.fg0
      ),
    },
    b = { bg = M.palette.bg3, fg = M.palette.fg0 },
    c = { bg = M.palette.bg3, fg = M.palette.fg0 },
  },
  insert = {
    a = {
      bg = M.palette.green,
      fg = best_contrast_fg(
        M.palette.green,
        M.palette.bg0,
        M.palette.fg0
      ),
    },
    b = { bg = M.palette.bg3, fg = M.palette.fg0 },
    c = { bg = M.palette.bg3, fg = M.palette.fg0 },
  },
  visual = {
    a = {
      bg = M.palette.yellow,
      fg = best_contrast_fg(
        M.palette.yellow,
        M.palette.bg0,
        M.palette.fg0
      ),
    },
    b = { bg = M.palette.bg3, fg = M.palette.fg0 },
    c = { bg = M.palette.bg3, fg = M.palette.fg0 },
  },
  replace = {
    a = {
      bg = M.palette.red,
      fg = best_contrast_fg(
        M.palette.red,
        M.palette.bg0,
        M.palette.fg0
      ),
    },
    b = { bg = M.palette.bg3, fg = M.palette.fg0 },
    c = { bg = M.palette.bg3, fg = M.palette.fg0 },
  },
  command = {
    a = {
      bg = M.palette.blue,
      fg = best_contrast_fg(
        M.palette.blue,
        M.palette.bg0,
        M.palette.fg0
      ),
    },
    b = { bg = M.palette.bg3, fg = M.palette.fg0 },
    c = { bg = M.palette.bg3, fg = M.palette.fg0 },
  },
  terminal = {
    a = {
      bg = M.palette.purple,
      fg = best_contrast_fg(
        M.palette.purple,
        M.palette.bg0,
        M.palette.fg0
      ),
    },
    b = { bg = M.palette.bg3, fg = M.palette.fg0 },
    c = { bg = M.palette.bg3, fg = M.palette.fg0 },
  },
  inactive = {
    a = { bg = M.palette.bg3, fg = M.palette.grey1 },
    b = { bg = M.palette.bg3, fg = M.palette.fg0 },
    c = { bg = M.palette.bg3, fg = M.palette.fg0 },
  },
}

M.fzf_lua_colors = {
  ["fg"] = M.fzf_roles.foreground,
  ["bg"] = M.fzf_roles.background,
  ["hl"] = M.fzf_roles.match,
  ["fg+"] = M.fzf_roles.foreground,
  ["bg+"] = M.fzf_roles.selected_background,
  ["hl+"] = M.fzf_roles.selected_match,
  ["info"] = M.fzf_roles.info,
  ["border"] = M.fzf_roles.border,
  ["gutter"] = M.fzf_roles.gutter,
  ["query"] = M.fzf_roles.query,
  ["prompt"] = M.fzf_roles.prompt,
  ["pointer"] = M.fzf_roles.pointer,
  ["marker"] = M.fzf_roles.marker,
  ["header"] = M.fzf_roles.header,
}

function M.setup()
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "custom-dark"
  vim.o.background = "dark"

  local p = M.palette
  local ui = M.ui
  local s = M.syntax
  local d = M.diagnostic
  local diff = M.diff
  local t = M.tool

  local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  local link = function(group, target)
    vim.api.nvim_set_hl(0, group, { link = target })
  end

  -- ==========================================================================
  -- UI highlights
  -- ==========================================================================
  hl("Normal", { fg = ui.fg, bg = ui.bg })
  hl("NormalNC", { fg = ui.fg, bg = ui.bg })
  hl("Terminal", { fg = ui.fg, bg = ui.bg })
  hl("EndOfBuffer", { fg = ui.bg, bg = ui.bg })
  hl("Folded", { fg = ui.fg_dim, bg = ui.bg_alt })
  hl("ToolbarLine", { fg = ui.fg, bg = ui.bg_alt })
  hl("SignColumn", { fg = ui.fg_dim })
  hl("FoldColumn", { fg = ui.fg_dim })

  hl("IncSearch", { fg = ui.inc_search_fg, bg = ui.inc_search_bg })
  hl("Search", { fg = ui.search_fg, bg = ui.search_bg })
  hl("CurSearch", { fg = ui.search_fg, bg = ui.search_bg })
  hl("ColorColumn", { bg = ui.bg_alt })
  hl("Conceal", { fg = ui.bg_alt })

  hl("Cursor", { reverse = true })
  link("vCursor", "Cursor")
  link("iCursor", "Cursor")
  link("lCursor", "Cursor")
  link("CursorIM", "Cursor")

  hl("CursorLine", { bg = ui.cursorline })
  hl("CursorColumn", { bg = ui.cursorline })

  -- LineNr: ui_contrast=low, sign_column_background=none
  hl("LineNr", { fg = ui.fg_dim })
  link("LineNrAbove", "LineNr")
  link("LineNrBelow", "LineNr")
  hl("CursorLineNr", { fg = ui.fg_alt })
  link("CursorLineFold", "FoldColumn")
  link("CursorLineSign", "SignColumn")

  hl("DiffAdd", { fg = diff.add, bg = diff.add_bg })
  hl("DiffChange", { fg = diff.change, bg = diff.change_bg })
  hl("DiffDelete", { fg = diff.delete, bg = diff.delete_bg })
  hl("DiffText", { fg = diff.text, bg = diff.text_bg })

  hl("Directory", { fg = t.directory })
  hl("ErrorMsg", { fg = d.error, underline = true })
  hl("WarningMsg", { fg = d.warn })
  hl("ModeMsg", { fg = ui.fg })
  hl("MoreMsg", { fg = d.warn })
  hl("MatchParen", { bg = ui.bg_alt })
  hl("NonText", { fg = ui.bg_alt })
  hl("Whitespace", { fg = ui.bg_alt })
  hl("SpecialKey", { fg = ui.bg_alt })

  -- Pmenu: menu_selection_background=grey
  hl("Pmenu", { fg = ui.fg, bg = ui.popup_bg })
  hl("PmenuSbar", { bg = ui.popup_bg })
  hl("PmenuSel", { fg = ui.fg, bg = ui.popup_sel })
  hl("PmenuMatch", { fg = s.type, bold = true })
  hl("PmenuMatchSel", { fg = s.type, bg = ui.popup_sel, bold = true })
  hl("PmenuKind", { fg = s["function"], bg = ui.popup_bg })
  hl("PmenuExtra", { fg = ui.fg_alt, bg = ui.popup_bg })
  link("WildMenu", "PmenuSel")
  hl("PmenuThumb", { bg = ui.fg_dim })

  -- Float: match the main editor background with a visible border
  hl("NormalFloat", { fg = ui.fg, bg = ui.popup_bg })
  hl("FloatBorder", { fg = ui.border, bg = ui.popup_bg })
  hl("FloatTitle", { fg = s["function"], bg = ui.popup_bg })
  link("FloatFooter", "FloatTitle")
  hl("FloatShadow", { bg = ui.popup_bg, blend = 30 })
  hl("FloatShadowThrough", { bg = ui.popup_bg, blend = 100 })

  hl("Question", { fg = d.info })
  hl("MsgArea", { fg = ui.fg, bg = ui.bg })
  hl("MsgSeparator", { fg = ui.fg_dim, bg = ui.bg })

  -- Spell
  hl("SpellBad", { undercurl = true, sp = d.error })
  hl("SpellCap", { undercurl = true, sp = d.info })
  hl("SpellLocal", { undercurl = true, sp = d.ok })
  hl("SpellRare", { undercurl = true, sp = d.hint })

  -- StatusLine: default style, transparent_background=0
  hl("StatusLine", { fg = ui.status_fg, bg = ui.status_bg })
  hl("StatusLineTerm", { fg = ui.status_fg, bg = ui.status_bg })
  hl("StatusLineNC", { fg = ui.status_inactive_fg, bg = ui.status_bg })
  hl("StatusLineTermNC", { fg = ui.status_inactive_fg, bg = ui.status_bg })
  hl("LualineSeparator", { fg = ui.fg, bg = ui.bg_alt })
  hl("TabLine", { fg = ui.status_inactive_fg, bg = ui.status_bg })
  hl("TabLineFill", { fg = ui.status_inactive_fg, bg = ui.status_bg })
  hl("TabLineSel", { fg = ui.fg, bg = ui.bg_alt })
  hl("WinBar", { fg = ui.fg, bg = ui.bg })
  hl("WinBarNC", { fg = ui.status_inactive_fg, bg = ui.bg })

  -- VertSplit / WinSeparator: match tmux separator color.
  hl("VertSplit", { fg = ui.border })
  link("WinSeparator", "VertSplit")

  -- Visual: grey background
  hl("Visual", { fg = ui.fg, bg = ui.visual })
  hl("VisualNOS", { fg = ui.fg, bg = ui.visual })

  hl("QuickFixLine", { fg = s.number })
  hl("Debug", { fg = t.prompt_alt })
  hl("debugPC", { fg = ui.bg, bg = t.git_clean })
  hl("debugBreakpoint", { fg = ui.bg, bg = d.error })
  hl("ToolbarButton", { fg = ui.fg, bg = ui.bg_alt })
  hl("Substitute", { fg = ui.bg, bg = s.type })

  -- Diagnostics: diagnostic_text_highlight=0
  hl("DiagnosticError", { fg = d.error })
  hl("DiagnosticWarn", { fg = d.warn })
  hl("DiagnosticInfo", { fg = d.info })
  hl("DiagnosticHint", { fg = d.hint })
  hl("DiagnosticOk", { fg = d.ok })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = d.error })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = d.warn })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = d.info })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = d.hint })
  hl("DiagnosticUnderlineOk", { undercurl = true, sp = d.ok })

  link("DiagnosticFloatingError", "ErrorFloat")
  link("DiagnosticFloatingWarn", "WarningFloat")
  link("DiagnosticFloatingInfo", "InfoFloat")
  link("DiagnosticFloatingHint", "HintFloat")
  link("DiagnosticFloatingOk", "OkFloat")
  link("DiagnosticVirtualTextError", "VirtualTextError")
  link("DiagnosticVirtualTextWarn", "VirtualTextWarning")
  link("DiagnosticVirtualTextInfo", "VirtualTextInfo")
  link("DiagnosticVirtualTextHint", "VirtualTextHint")
  link("DiagnosticVirtualTextOk", "VirtualTextOk")
  link("DiagnosticVirtualLinesError", "VirtualTextError")
  link("DiagnosticVirtualLinesWarn", "VirtualTextWarning")
  link("DiagnosticVirtualLinesInfo", "VirtualTextInfo")
  link("DiagnosticVirtualLinesHint", "VirtualTextHint")
  link("DiagnosticVirtualLinesOk", "VirtualTextOk")
  link("DiagnosticSignError", "RedSign")
  link("DiagnosticSignWarn", "YellowSign")
  link("DiagnosticSignInfo", "BlueSign")
  link("DiagnosticSignHint", "PurpleSign")
  link("DiagnosticSignOk", "GreenSign")

  link("LspReferenceText", "CurrentWord")
  link("LspReferenceRead", "CurrentWord")
  link("LspReferenceWrite", "CurrentWord")
  link("LspInlayHint", "InlayHints")
  link("LspCodeLens", "VirtualTextInfo")
  link("LspCodeLensSeparator", "VirtualTextHint")
  link("LspSignatureActiveParameter", "Search")
  link("TermCursor", "Cursor")
  link("healthError", "Red")
  link("healthSuccess", "Green")
  link("healthWarning", "Yellow")

  -- ==========================================================================
  -- Syntax highlights
  -- ==========================================================================
  hl("Boolean", { fg = s.constant })
  hl("Number", { fg = s.number })
  hl("Float", { fg = s.number })
  hl("PreProc", { fg = s.preproc, italic = true })
  hl("PreCondit", { fg = s.preproc, italic = true })
  hl("Include", { fg = s.preproc, italic = true })
  hl("Define", { fg = s.preproc, italic = true })
  hl("Conditional", { fg = s.keyword, italic = true })
  hl("Repeat", { fg = s.keyword, italic = true })
  hl("Keyword", { fg = s.keyword, italic = true })
  hl("Typedef", { fg = s.type, italic = true })
  hl("Exception", { fg = s.special, italic = true })
  hl("Statement", { fg = s.keyword, italic = true })
  hl("Error", { fg = d.error })
  hl("StorageClass", { fg = s.type })
  hl("Tag", { fg = s.keyword })
  hl("Label", { fg = s.property })
  hl("Structure", { fg = s.type })
  hl("Operator", { fg = s.operator })
  hl("Title", { fg = s["function"], bold = true })
  hl("Special", { fg = s.special })
  hl("SpecialChar", { fg = s.escape })
  hl("Type", { fg = s.type })
  hl("Function", { fg = s["function"] })
  hl("String", { fg = s.string })
  hl("Character", { fg = s.string })
  hl("Constant", { fg = s.constant })
  hl("Macro", { fg = s.preproc })
  hl("Identifier", { fg = s.variable })
  hl("Todo", { fg = ui.bg, bg = d.info, bold = true })
  hl("Comment", { fg = s.comment, italic = true })
  hl("SpecialComment", { fg = s.comment, italic = true })
  hl("Delimiter", { fg = s.delimiter })
  hl("Ignore", { fg = ui.muted })
  hl("Underlined", { fg = s.property, underline = true })

  hl("TSCharacter", { fg = s.string })
  hl("TSMarkupLinkUrl", { fg = s["function"], italic = true, underline = true })
  hl("TSMarkupListUnchecked", { fg = ui.muted })
  hl("TSStringEscape", { fg = s.escape })
  hl("TSStringRegexp", { fg = s.escape })
  hl("TSStringSpecialUrl", { fg = s["function"] })

  -- ==========================================================================
  -- Predefined highlight groups
  -- ==========================================================================
  hl("Fg", { fg = ui.fg })
  hl("Grey", { fg = ui.fg_dim })
  hl("Red", { fg = d.error })
  hl("Orange", { fg = s.operator })
  hl("Yellow", { fg = s.type })
  hl("Green", { fg = s["function"] })
  hl("Aqua", { fg = s.constant })
  hl("Blue", { fg = s.variable })
  hl("Purple", { fg = s.number })

  -- Italic variants (italic enabled)
  hl("RedItalic", { fg = d.error, italic = true })
  hl("OrangeItalic", { fg = s.operator, italic = true })
  hl("YellowItalic", { fg = s.type, italic = true })
  hl("GreenItalic", { fg = s["function"], italic = true })
  hl("AquaItalic", { fg = s.constant, italic = true })
  hl("BlueItalic", { fg = s.variable, italic = true })
  hl("PurpleItalic", { fg = s.number, italic = true })

  -- Bold variants (bold enabled)
  hl("RedBold", { fg = d.error, bold = true })
  hl("OrangeBold", { fg = s.operator, bold = true })
  hl("YellowBold", { fg = s.type, bold = true })
  hl("GreenBold", { fg = s["function"], bold = true })
  hl("AquaBold", { fg = s.constant, bold = true })
  hl("BlueBold", { fg = s.variable, bold = true })
  hl("PurpleBold", { fg = s.number, bold = true })

  -- Sign variants (sign_column_background=none)
  hl("RedSign", { fg = d.error })
  hl("OrangeSign", { fg = s.operator })
  hl("YellowSign", { fg = s.type })
  hl("GreenSign", { fg = s["function"] })
  hl("AquaSign", { fg = s.constant })
  hl("BlueSign", { fg = s.variable })
  hl("PurpleSign", { fg = s.number })

  link("Added", "Green")
  link("Removed", "Red")
  link("Changed", "Blue")

  -- ==========================================================================
  -- Error/Warning/Info/Hint text and lines
  -- ==========================================================================
  -- diagnostic_text_highlight=0
  hl("ErrorText", { undercurl = true, sp = d.error })
  hl("WarningText", { undercurl = true, sp = d.warn })
  hl("InfoText", { undercurl = true, sp = d.info })
  hl("HintText", { undercurl = true, sp = d.hint })

  -- diagnostic_line_highlight=0
  vim.cmd("highlight clear ErrorLine")
  vim.cmd("highlight clear WarningLine")
  vim.cmd("highlight clear InfoLine")
  vim.cmd("highlight clear HintLine")

  -- diagnostic_virtual_text=grey
  link("VirtualTextWarning", "Grey")
  link("VirtualTextError", "Grey")
  link("VirtualTextInfo", "Grey")
  link("VirtualTextHint", "Grey")
  link("VirtualTextOk", "Grey")

  hl("ErrorFloat", { fg = d.error })
  hl("WarningFloat", { fg = d.warn })
  hl("InfoFloat", { fg = d.info })
  hl("HintFloat", { fg = d.hint })
  hl("OkFloat", { fg = d.ok })

  -- CurrentWord: current_word default = "grey background"
  hl("CurrentWord", { fg = ui.fg, bg = ui.selection })

  -- InlayHints: inlay_hints_background=none
  link("InlayHints", "LineNr")
  hl("SnippetTabstop", { bg = ui.bg_alt })
  hl("SnippetTabstopActive", { bg = ui.selection })

  -- ==========================================================================
  -- Terminal colors
  -- ==========================================================================
  vim.g.terminal_color_0 = ui.bg_alt
  vim.g.terminal_color_1 = d.error
  vim.g.terminal_color_2 = s["function"]
  vim.g.terminal_color_3 = s.type
  vim.g.terminal_color_4 = s.variable
  vim.g.terminal_color_5 = s.number
  vim.g.terminal_color_6 = s.constant
  vim.g.terminal_color_7 = ui.fg_alt
  vim.g.terminal_color_8 = ui.fg_dim
  vim.g.terminal_color_9 = d.error
  vim.g.terminal_color_10 = s["function"]
  vim.g.terminal_color_11 = s.type
  vim.g.terminal_color_12 = s.variable
  vim.g.terminal_color_13 = s.number
  vim.g.terminal_color_14 = s.constant
  vim.g.terminal_color_15 = ui.fg_alt

  -- ==========================================================================
  -- Treesitter highlights
  -- ==========================================================================
  hl("@comment.error", { fg = ui.bg, bg = d.error })
  hl("@comment.note", { fg = ui.fg_alt, bg = d.hint })
  hl("@comment.warning", { fg = ui.bg, bg = d.warn })
  hl("@comment.hint", { fg = ui.bg, bg = d.info })
  hl("@markup.italic", { italic = true })
  link("@markup.link.url", "TSMarkupLinkUrl")
  hl("@markup.strong", { bold = true })
  hl("@markup.underline", { underline = true })

  -- Neovim 0.12 treesitter captures
  link("@annotation", "PreProc")
  link("@attribute", "Identifier")
  link("@attribute.builtin", "@attribute")
  link("@boolean", "Boolean")
  link("@character", "Character")
  link("@character.special", "SpecialChar")
  link("@comment", "Comment")
  link("@comment.todo", "Todo")
  link("@conceal", "Grey")
  link("@conditional", "Conditional")
  link("@constant", "Constant")
  link("@constant.builtin", "Constant")
  link("@constant.macro", "Macro")
  link("@constructor", "Function")
  link("@diff.delta", "diffChanged")
  link("@diff.minus", "diffRemoved")
  link("@diff.plus", "diffAdded")
  link("@error", "Error")
  link("@exception", "Exception")
  link("@field", "Identifier")
  link("@float", "Float")
  link("@function", "Function")
  link("@function.builtin", "Function")
  link("@function.call", "Function")
  link("@function.macro", "Macro")
  link("@function.method", "Function")
  link("@function.method.call", "Function")
  link("@include", "Include")
  link("@keyword", "Keyword")
  link("@keyword.conditional", "Conditional")
  link("@keyword.debug", "Debug")
  link("@keyword.directive", "PreProc")
  link("@keyword.directive.define", "Define")
  link("@keyword.exception", "Exception")
  link("@keyword.function", "Keyword")
  link("@keyword.import", "Include")
  link("@keyword.operator", "Operator")
  link("@keyword.repeat", "Repeat")
  link("@keyword.return", "Keyword")
  link("@keyword.storage", "StorageClass")
  link("@label", "Label")
  link("@markup.environment", "Macro")
  link("@markup.environment.name", "Type")
  link("@markup.heading", "Title")
  link("@markup.link", "Identifier")
  link("@markup.link.label", "SpecialChar")
  link("@markup.list", "Special")
  link("@markup.list.checked", "Green")
  link("@markup.list.unchecked", "Ignore")
  link("@markup.math", "Special")
  link("@markup.note", "@comment.note")
  link("@markup.quote", "Grey")
  link("@markup.raw", "String")
  link("@markup.strike", "Grey")
  link("@math", "Special")
  link("@method", "Function")
  link("@method.call", "Function")
  link("@module", "Include")
  link("@namespace", "Include")
  link("@none", "Fg")
  link("@number", "Number")
  link("@number.float", "Float")
  link("@operator", "Operator")
  link("@parameter", "Identifier")
  link("@parameter.reference", "Identifier")
  link("@preproc", "PreProc")
  link("@property", "Identifier")
  link("@punctuation.bracket", "Delimiter")
  link("@punctuation.delimiter", "Delimiter")
  link("@punctuation.special", "SpecialChar")
  link("@repeat", "Repeat")
  link("@storageclass", "StorageClass")
  link("@storageclass.lifetime", "StorageClass")
  link("@strike", "Grey")
  link("@string", "String")
  link("@string.escape", "SpecialChar")
  link("@string.regex", "SpecialChar")
  link("@string.regexp", "SpecialChar")
  link("@string.special", "SpecialChar")
  link("@string.special.symbol", "Constant")
  link("@string.special.url", "@markup.link.url")
  link("@string.special.uri", "@markup.link.url")
  link("@symbol", "Constant")
  link("@tag", "Tag")
  link("@tag.attribute", "Identifier")
  link("@tag.builtin", "@tag")
  link("@tag.delimiter", "Delimiter")
  link("@text", "Fg")
  link("@text.diff.add", "diffAdded")
  link("@text.diff.delete", "diffRemoved")
  link("@text.environment", "Macro")
  link("@text.environment.name", "Type")
  link("@text.literal", "String")
  link("@text.math", "Special")
  link("@text.reference", "Identifier")
  link("@text.strike", "Grey")
  link("@text.title", "Title")
  link("@text.todo", "Todo")
  link("@text.todo.checked", "Green")
  link("@text.todo.unchecked", "Ignore")
  link("@type", "Type")
  link("@type.builtin", "Type")
  link("@type.definition", "Typedef")
  link("@type.qualifier", "Typedef")
  link("@variable", "Identifier")
  link("@variable.builtin", "Identifier")
  link("@variable.member", "Identifier")
  link("@variable.parameter", "Identifier")

  hl("DiagnosticUnnecessary", { fg = ui.fg_dim })
  hl("DiagnosticDeprecated", { strikethrough = true, sp = ui.fg })
  link("@lsp.mod.deprecated", "DiagnosticDeprecated")

  -- ==========================================================================
  -- Plugin highlights
  -- ==========================================================================

  -- copilot.lua
  link("CopilotSuggestion", "Grey")

  -- hrsh7th/nvim-cmp
  hl("CmpItemAbbrMatch", { fg = s["function"], bold = true })
  hl("CmpItemAbbrMatchFuzzy", { fg = s["function"], bold = true })
  link("CmpItemAbbr", "Fg")
  link("CmpItemAbbrDeprecated", "Grey")
  link("CmpItemMenu", "Fg")
  link("CmpItemKind", "Yellow")
  for group, target in pairs({
    CmpItemKindArray = "Aqua",
    CmpItemKindBoolean = "Orange",
    CmpItemKindClass = "Red",
    CmpItemKindColor = "Aqua",
    CmpItemKindConstant = "Orange",
    CmpItemKindConstructor = "Blue",
    CmpItemKindDefault = "Aqua",
    CmpItemKindEnum = "Yellow",
    CmpItemKindEnumMember = "Purple",
    CmpItemKindEvent = "Yellow",
    CmpItemKindField = "Green",
    CmpItemKindFile = "Green",
    CmpItemKindFolder = "Aqua",
    CmpItemKindFunction = "Blue",
    CmpItemKindInterface = "Yellow",
    CmpItemKindKey = "Red",
    CmpItemKindKeyword = "Purple",
    CmpItemKindMethod = "Blue",
    CmpItemKindModule = "Purple",
    CmpItemKindNamespace = "Purple",
    CmpItemKindNull = "Aqua",
    CmpItemKindNumber = "Orange",
    CmpItemKindObject = "Aqua",
    CmpItemKindOperator = "Yellow",
    CmpItemKindPackage = "Purple",
    CmpItemKindProperty = "Blue",
    CmpItemKindReference = "Aqua",
    CmpItemKindSnippet = "Aqua",
    CmpItemKindString = "Green",
    CmpItemKindStruct = "Yellow",
    CmpItemKindText = "Fg",
    CmpItemKindTypeParameter = "Yellow",
    CmpItemKindUnit = "Purple",
    CmpItemKindValue = "Purple",
    CmpItemKindVariable = "Blue",
  }) do
    link(group, target)
  end

  -- ibhagwan/fzf-lua
  for group, target in pairs({
    FzfLuaBorder = "FloatBorder",
    FzfLuaCursorLine = "DiffAdd",
    FzfLuaCursorLineNr = "DiffAdd",
    FzfLuaFzfBorder = "FloatBorder",
    FzfLuaFzfCursorLine = "DiffAdd",
    FzfLuaFzfHeader = "Orange",
    FzfLuaFzfInfo = "Grey",
    FzfLuaFzfMarker = "Yellow",
    FzfLuaFzfMatch = "Green",
    FzfLuaFzfNormal = "NormalFloat",
    FzfLuaFzfGutter = "NormalFloat",
    FzfLuaFzfPointer = "Yellow",
    FzfLuaFzfQuery = "NormalFloat",
    FzfLuaFzfPrompt = "Yellow",
    FzfLuaFzfScrollbar = "FloatBorder",
    FzfLuaFzfSeparator = "FloatBorder",
    FzfLuaFzfSpinner = "Comment",
    FzfLuaNormal = "NormalFloat",
    FzfLuaPreviewBorder = "FloatBorder",
    FzfLuaPreviewNormal = "NormalFloat",
    FzfLuaPreviewTitle = "Title",
    FzfLuaSearch = "Green",
    FzfLuaTitle = "Title",
    FzfLuaTitleFlags = "Comment",
    FzfLuaBackdrop = "Normal",
    FzfLuaCursor = "Cursor",
    FzfLuaHelpNormal = "NormalFloat",
    FzfLuaHelpBorder = "FloatBorder",
    FzfLuaHeaderBind = "Yellow",
    FzfLuaHeaderText = "Orange",
    FzfLuaLivePrompt = "Orange",
    FzfLuaLiveSym = "Orange",
    FzfLuaPathColNr = "Blue",
    FzfLuaPathLineNr = "Green",
    FzfLuaBufName = "Purple",
    FzfLuaBufId = "TabLine",
    FzfLuaBufNr = "Yellow",
    FzfLuaBufLineNr = "LineNr",
    FzfLuaBufFlagCur = "Orange",
    FzfLuaBufFlagAlt = "Blue",
    FzfLuaTabTitle = "Blue",
    FzfLuaTabMarker = "Yellow",
    FzfLuaDirIcon = "Directory",
    FzfLuaDirPart = "NonText",
    FzfLuaFilePart = "NormalFloat",
    FzfLuaCmdEx = "Statement",
    FzfLuaCmdBuf = "Added",
    FzfLuaCmdGlobal = "Directory",
    FzfLuaScrollBorderEmpty = "FloatBorder",
    FzfLuaScrollBorderFull = "FloatBorder",
    FzfLuaScrollFloatEmpty = "PmenuSbar",
    FzfLuaScrollFloatFull = "PmenuThumb",
  }) do
    link(group, target)
  end

  -- lewis6991/gitsigns.nvim
  link("GitSignsAdd", "GreenSign")
  link("GitSignsChange", "BlueSign")
  link("GitSignsDelete", "RedSign")
  link("GitSignsAddNr", "Green")
  link("GitSignsChangeNr", "Blue")
  link("GitSignsDeleteNr", "Red")
  link("GitSignsAddLn", "DiffAdd")
  link("GitSignsChangeLn", "DiffChange")
  link("GitSignsDeleteLn", "DiffDelete")
  link("GitSignsCurrentLineBlame", "Grey")

  -- folke/which-key.nvim
  link("WhichKey", "Red")
  link("WhichKeySeparator", "Green")
  link("WhichKeyGroup", "Yellow")
  link("WhichKeyDesc", "Blue")

  -- lem.terminal backdrop
  hl("TerminalBackdrop", { bg = ui.bg })

  -- nvim-tree/nvim-tree.lua
  link("NvimTreeNormal", "Normal")
  link("NvimTreeNormalNC", "Normal")
  link("NvimTreeEndOfBuffer", "Normal")
  hl("NvimTreeWinSeparator", { fg = ui.border, bg = ui.bg })
  link("NvimTreeSymlink", "Fg")
  link("NvimTreeFolderName", "Green")
  link("NvimTreeRootFolder", "Grey")
  link("NvimTreeFolderIcon", "Yellow")
  link("NvimTreeEmptyFolderName", "Green")
  link("NvimTreeOpenedFolderName", "Green")
  link("NvimTreeExecFile", "Fg")
  link("NvimTreeOpenedHL", "Fg")
  link("NvimTreeSpecialFile", "Fg")
  link("NvimTreeImageFile", "Fg")
  link("NvimTreeOpenedFile", "Fg")
  hl("NvimTreeStatuslineNc", { fg = ui.bg_alt, bg = ui.bg_alt })
  link("NvimTreeIndentMarker", "Grey")
  link("NvimTreeGitDirtyIcon", "Yellow")
  link("NvimTreeGitStagedIcon", "Blue")
  link("NvimTreeGitMergeIcon", "Yellow")
  link("NvimTreeGitRenamedIcon", "Purple")
  link("NvimTreeGitNewIcon", "Aqua")
  link("NvimTreeGitDeletedIcon", "Red")
  link("NvimTreeLspDiagnosticsError", "RedSign")
  link("NvimTreeLspDiagnosticsWarning", "YellowSign")
  link("NvimTreeLspDiagnosticsInformation", "BlueSign")
  link("NvimTreeLspDiagnosticsHint", "PurpleSign")

  -- hat0uma/csvview.nvim
  link("CsvViewDelimiter", "Delimiter")
  link("CsvViewComment", "Comment")
  hl("CsvViewHeaderLine", { bg = ui.bg_alt })
  link("CsvViewStickyHeaderSeparator", "CsvViewDelimiter")
  link("CsvViewInfoTitle", "Title")
  link("CsvViewInfoSection", "Statement")
  link("CsvViewInfoLabel", "Identifier")
  link("CsvViewInfoText", "String")
  link("CsvViewInfoNumber", "Number")
  link("CsvViewInfoHint", "Conceal")
  link("CsvViewInfoTableHeader", "TabLineSel")
  link("CsvViewInfoTableBorder", "Comment")
  link("CsvViewInfoPositive", "DiagnosticOk")
  link("CsvViewInfoNegative", "DiagnosticError")
  link("CsvViewInfoNeutral", "Comment")
  link("CsvViewInfoScoreBar", "Special")

  -- diff
  link("diffAdded", "Green")
  link("diffRemoved", "Red")
  link("diffChanged", "Blue")
  link("diffFile", "Blue")
  link("diffOldFile", "Yellow")
  link("diffNewFile", "Orange")
  link("diffIndexLine", "Aqua")
  link("diffLine", "Grey")

  -- mason
  hl("MasonHeader", { fg = ui.bg, bg = s.variable, bold = true })
  hl("MasonHeaderSecondary", { fg = ui.bg, bg = s.number, bold = true })
  link("MasonHighlight", "Green")
  link("MasonHighlightSecondary", "Purple")
  hl("MasonHighlightBlock", { fg = ui.bg, bg = s["function"] })
  hl("MasonHighlightBlockBold", { fg = ui.bg, bg = s["function"], bold = true })
  hl("MasonHighlightBlockSecondary", { fg = ui.bg, bg = s.variable })
  hl(
    "MasonHighlightBlockBoldSecondary",
    { fg = ui.bg, bg = s.number, bold = true }
  )
  hl("MasonMuted", { fg = ui.fg_dim })
  hl("MasonMutedBlock", { fg = ui.bg, bg = ui.fg_dim })
end

return M
