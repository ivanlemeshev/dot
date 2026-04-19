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

  local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  local link = function(group, target)
    vim.api.nvim_set_hl(0, group, { link = target })
  end

  -- ==========================================================================
  -- UI highlights
  -- ==========================================================================
  hl("Normal", { fg = p.fg0, bg = p.bg0 })
  hl("NormalNC", { fg = p.fg0, bg = p.bg0 })
  hl("Terminal", { fg = p.fg0, bg = p.bg0 })
  hl("EndOfBuffer", { fg = p.bg0, bg = p.bg0 })
  hl("Folded", { fg = p.blue, bg = p.bg1 })
  hl("ToolbarLine", { fg = p.fg0, bg = p.bg1 })
  hl("SignColumn", { fg = p.grey1 })
  hl("FoldColumn", { fg = p.grey1 })

  hl("IncSearch", { fg = p.bg0, bg = p.orange })
  hl("Search", { fg = p.bg0, bg = p.yellow })
  hl("CurSearch", { fg = p.bg0, bg = p.yellow })
  hl("ColorColumn", { bg = p.bg1 })
  hl("Conceal", { fg = p.bg1 })

  hl("Cursor", { reverse = true })
  link("vCursor", "Cursor")
  link("iCursor", "Cursor")
  link("lCursor", "Cursor")
  link("CursorIM", "Cursor")

  hl("CursorLine", { bg = p.bg1 })
  hl("CursorColumn", { bg = p.bg1 })

  -- LineNr: ui_contrast=low, sign_column_background=none
  hl("LineNr", { fg = p.grey1 })
  link("LineNrAbove", "LineNr")
  link("LineNrBelow", "LineNr")
  hl("CursorLineNr", { fg = p.grey2 })
  link("CursorLineFold", "FoldColumn")
  link("CursorLineSign", "SignColumn")

  hl("DiffAdd", { fg = p.green, bg = p.bg_diff_green })
  hl("DiffChange", { fg = p.fg0, bg = p.bg_diff_blue })
  hl("DiffDelete", { fg = p.red, bg = p.bg_diff_red })
  hl("DiffText", { fg = p.fg0, bg = p.bg_visual_blue })

  hl("Directory", { fg = p.green })
  hl("ErrorMsg", { fg = p.red, underline = true })
  hl("WarningMsg", { fg = p.yellow })
  hl("ModeMsg", { fg = p.fg0 })
  hl("MoreMsg", { fg = p.yellow })
  hl("MatchParen", { bg = p.bg3 })
  hl("NonText", { fg = p.bg1 })
  hl("Whitespace", { fg = p.bg1 })
  hl("SpecialKey", { fg = p.bg1 })

  -- Pmenu: menu_selection_background=grey
  hl("Pmenu", { fg = p.fg0, bg = p.bg0 })
  hl("PmenuSbar", { bg = p.bg0 })
  hl("PmenuSel", { fg = p.fg0, bg = p.bg3 })
  hl("PmenuMatch", { fg = p.yellow, bold = true })
  hl("PmenuMatchSel", { fg = p.yellow, bg = p.bg3, bold = true })
  hl("PmenuKind", { fg = p.green, bg = p.bg0 })
  hl("PmenuExtra", { fg = p.fg1, bg = p.bg0 })
  link("WildMenu", "PmenuSel")
  hl("PmenuThumb", { bg = p.grey1 })

  -- Float: match the main editor background with a visible border
  hl("NormalFloat", { fg = p.fg0, bg = p.bg0 })
  hl("FloatBorder", { fg = p.grey1, bg = p.bg0 })
  hl("FloatTitle", { fg = p.orange, bg = p.bg0 })
  link("FloatFooter", "FloatTitle")
  hl("FloatShadow", { bg = p.bg0, blend = 30 })
  hl("FloatShadowThrough", { bg = p.bg0, blend = 100 })

  hl("Question", { fg = p.yellow })
  hl("MsgArea", { fg = p.fg0, bg = p.bg0 })
  hl("MsgSeparator", { fg = p.grey1, bg = p.bg0 })

  -- Spell
  hl("SpellBad", { undercurl = true, sp = p.red })
  hl("SpellCap", { undercurl = true, sp = p.blue })
  hl("SpellLocal", { undercurl = true, sp = p.aqua })
  hl("SpellRare", { undercurl = true, sp = p.purple })

  -- StatusLine: default style, transparent_background=0
  hl("StatusLine", { fg = p.grey2, bg = p.bg1 })
  hl("StatusLineTerm", { fg = p.grey2, bg = p.bg1 })
  hl("StatusLineNC", { fg = p.grey1, bg = p.bg1 })
  hl("StatusLineTermNC", { fg = p.grey1, bg = p.bg1 })
  hl("LualineSeparator", { fg = p.fg0, bg = p.bg3 })
  hl("TabLine", { fg = p.grey1, bg = p.bg1 })
  hl("TabLineFill", { fg = p.grey1, bg = p.bg1 })
  hl("TabLineSel", { fg = p.fg0, bg = p.bg3 })
  hl("WinBar", { fg = p.fg0, bg = p.bg0 })
  hl("WinBarNC", { fg = p.grey1, bg = p.bg0 })

  -- VertSplit / WinSeparator: match tmux separator color.
  hl("VertSplit", { fg = p.grey1 })
  link("WinSeparator", "VertSplit")

  -- Visual: grey background
  hl("Visual", { fg = p.fg0, bg = p.bg_visual })
  hl("VisualNOS", { fg = p.fg0, bg = p.bg_visual })

  hl("QuickFixLine", { fg = p.purple })
  hl("Debug", { fg = p.orange })
  hl("debugPC", { fg = p.bg0, bg = p.green })
  hl("debugBreakpoint", { fg = p.bg0, bg = p.red })
  hl("ToolbarButton", { fg = p.fg0, bg = p.bg3 })
  hl("Substitute", { fg = p.bg0, bg = p.yellow })

  -- Diagnostics: diagnostic_text_highlight=0
  hl("DiagnosticError", { fg = p.red })
  hl("DiagnosticWarn", { fg = p.yellow })
  hl("DiagnosticInfo", { fg = p.blue })
  hl("DiagnosticHint", { fg = p.purple })
  hl("DiagnosticOk", { fg = p.green })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = p.red })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = p.yellow })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = p.blue })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = p.purple })
  hl("DiagnosticUnderlineOk", { undercurl = true, sp = p.green })

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
  hl("Boolean", { fg = p.purple })
  hl("Number", { fg = p.purple })
  hl("Float", { fg = p.purple })
  hl("PreProc", { fg = p.purple, italic = true })
  hl("PreCondit", { fg = p.purple, italic = true })
  hl("Include", { fg = p.purple, italic = true })
  hl("Define", { fg = p.purple, italic = true })
  hl("Conditional", { fg = p.red, italic = true })
  hl("Repeat", { fg = p.red, italic = true })
  hl("Keyword", { fg = p.red, italic = true })
  hl("Typedef", { fg = p.red, italic = true })
  hl("Exception", { fg = p.red, italic = true })
  hl("Statement", { fg = p.red, italic = true })
  hl("Error", { fg = p.red })
  hl("StorageClass", { fg = p.orange })
  hl("Tag", { fg = p.orange })
  hl("Label", { fg = p.orange })
  hl("Structure", { fg = p.orange })
  hl("Operator", { fg = p.orange })
  hl("Title", { fg = p.orange, bold = true })
  hl("Special", { fg = p.yellow })
  hl("SpecialChar", { fg = p.yellow })
  hl("Type", { fg = p.yellow })
  hl("Function", { fg = p.green })
  hl("String", { fg = p.green })
  hl("Character", { fg = p.green })
  hl("Constant", { fg = p.aqua })
  hl("Macro", { fg = p.aqua })
  hl("Identifier", { fg = p.blue })
  hl("Todo", { fg = p.bg0, bg = p.blue, bold = true })
  hl("Comment", { fg = p.grey1, italic = true })
  hl("SpecialComment", { fg = p.grey1, italic = true })
  hl("Delimiter", { fg = p.fg0 })
  hl("Ignore", { fg = p.grey1 })
  hl("Underlined", { fg = p.blue, underline = true })

  hl("TSCharacter", { fg = p.aqua })
  hl("TSMarkupLinkUrl", { fg = p.blue, italic = true, underline = true })
  hl("TSMarkupListUnchecked", { fg = p.grey1 })
  hl("TSStringEscape", { fg = p.purple })
  hl("TSStringRegexp", { fg = p.purple })
  hl("TSStringSpecialUrl", { fg = p.blue })

  -- ==========================================================================
  -- Predefined highlight groups
  -- ==========================================================================
  hl("Fg", { fg = p.fg0 })
  hl("Grey", { fg = p.grey1 })
  hl("Red", { fg = p.red })
  hl("Orange", { fg = p.orange })
  hl("Yellow", { fg = p.yellow })
  hl("Green", { fg = p.green })
  hl("Aqua", { fg = p.aqua })
  hl("Blue", { fg = p.blue })
  hl("Purple", { fg = p.purple })

  -- Italic variants (italic enabled)
  hl("RedItalic", { fg = p.red, italic = true })
  hl("OrangeItalic", { fg = p.orange, italic = true })
  hl("YellowItalic", { fg = p.yellow, italic = true })
  hl("GreenItalic", { fg = p.green, italic = true })
  hl("AquaItalic", { fg = p.aqua, italic = true })
  hl("BlueItalic", { fg = p.blue, italic = true })
  hl("PurpleItalic", { fg = p.purple, italic = true })

  -- Bold variants (bold enabled)
  hl("RedBold", { fg = p.red, bold = true })
  hl("OrangeBold", { fg = p.orange, bold = true })
  hl("YellowBold", { fg = p.yellow, bold = true })
  hl("GreenBold", { fg = p.green, bold = true })
  hl("AquaBold", { fg = p.aqua, bold = true })
  hl("BlueBold", { fg = p.blue, bold = true })
  hl("PurpleBold", { fg = p.purple, bold = true })

  -- Sign variants (sign_column_background=none)
  hl("RedSign", { fg = p.red })
  hl("OrangeSign", { fg = p.orange })
  hl("YellowSign", { fg = p.yellow })
  hl("GreenSign", { fg = p.green })
  hl("AquaSign", { fg = p.aqua })
  hl("BlueSign", { fg = p.blue })
  hl("PurpleSign", { fg = p.purple })

  link("Added", "Green")
  link("Removed", "Red")
  link("Changed", "Blue")

  -- ==========================================================================
  -- Error/Warning/Info/Hint text and lines
  -- ==========================================================================
  -- diagnostic_text_highlight=0
  hl("ErrorText", { undercurl = true, sp = p.red })
  hl("WarningText", { undercurl = true, sp = p.yellow })
  hl("InfoText", { undercurl = true, sp = p.blue })
  hl("HintText", { undercurl = true, sp = p.purple })

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

  hl("ErrorFloat", { fg = p.red })
  hl("WarningFloat", { fg = p.yellow })
  hl("InfoFloat", { fg = p.blue })
  hl("HintFloat", { fg = p.purple })
  hl("OkFloat", { fg = p.green })

  -- CurrentWord: current_word default = "grey background"
  hl("CurrentWord", { fg = p.fg0, bg = p.bg_current_word })

  -- InlayHints: inlay_hints_background=none
  link("InlayHints", "LineNr")
  hl("SnippetTabstop", { bg = p.bg1 })
  hl("SnippetTabstopActive", { bg = p.bg3 })

  -- ==========================================================================
  -- Terminal colors
  -- ==========================================================================
  vim.g.terminal_color_0 = p.bg1
  vim.g.terminal_color_1 = p.red
  vim.g.terminal_color_2 = p.green
  vim.g.terminal_color_3 = p.yellow
  vim.g.terminal_color_4 = p.blue
  vim.g.terminal_color_5 = p.purple
  vim.g.terminal_color_6 = p.aqua
  vim.g.terminal_color_7 = p.fg1
  vim.g.terminal_color_8 = p.grey1
  vim.g.terminal_color_9 = p.red
  vim.g.terminal_color_10 = p.green
  vim.g.terminal_color_11 = p.yellow
  vim.g.terminal_color_12 = p.blue
  vim.g.terminal_color_13 = p.purple
  vim.g.terminal_color_14 = p.aqua
  vim.g.terminal_color_15 = p.grey2

  -- ==========================================================================
  -- Treesitter highlights
  -- ==========================================================================
  hl("@comment.error", { fg = p.bg0, bg = p.red })
  hl("@comment.note", { fg = p.grey2, bg = p.purple })
  hl("@comment.warning", { fg = p.bg0, bg = p.yellow })
  hl("@comment.hint", { fg = p.bg0, bg = p.blue })
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

  hl("DiagnosticUnnecessary", { fg = p.grey1 })
  hl("DiagnosticDeprecated", { strikethrough = true, sp = p.fg0 })
  link("@lsp.mod.deprecated", "DiagnosticDeprecated")

  -- ==========================================================================
  -- Plugin highlights
  -- ==========================================================================

  -- copilot.lua
  link("CopilotSuggestion", "Grey")

  -- hrsh7th/nvim-cmp
  hl("CmpItemAbbrMatch", { fg = p.green, bold = true })
  hl("CmpItemAbbrMatchFuzzy", { fg = p.green, bold = true })
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
  hl("TerminalBackdrop", { bg = p.bg0 })

  -- nvim-tree/nvim-tree.lua
  link("NvimTreeNormal", "Normal")
  link("NvimTreeNormalNC", "Normal")
  link("NvimTreeEndOfBuffer", "Normal")
  hl("NvimTreeWinSeparator", { fg = p.grey1, bg = p.bg0 })
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
  hl("NvimTreeStatuslineNc", { fg = p.bg1, bg = p.bg1 })
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
  hl("CsvViewHeaderLine", { bg = p.bg1 })
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
  link("diffChanged", "Green")
  link("diffFile", "Blue")
  link("diffOldFile", "Yellow")
  link("diffNewFile", "Orange")
  link("diffIndexLine", "Aqua")
  link("diffLine", "Grey")

  -- mason
  hl("MasonHeader", { fg = p.bg0, bg = p.blue, bold = true })
  hl("MasonHeaderSecondary", { fg = p.bg0, bg = p.purple, bold = true })
  link("MasonHighlight", "Green")
  link("MasonHighlightSecondary", "Purple")
  hl("MasonHighlightBlock", { fg = p.bg0, bg = p.green })
  hl("MasonHighlightBlockBold", { fg = p.bg0, bg = p.green, bold = true })
  hl("MasonHighlightBlockSecondary", { fg = p.bg0, bg = p.blue })
  hl(
    "MasonHighlightBlockBoldSecondary",
    { fg = p.bg0, bg = p.purple, bold = true }
  )
  hl("MasonMuted", { fg = p.grey1 })
  hl("MasonMutedBlock", { fg = p.bg0, bg = p.grey1 })
end

return M
