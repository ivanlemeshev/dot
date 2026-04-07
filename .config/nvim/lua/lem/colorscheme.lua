-- Custom colorscheme (no external dependency)

local M = {}

-- Palette (matches color/schemes/tomorrow-night.yaml)
M.palette = {
  base00 = "#1d1f21",
  base01 = "#282a2e",
  base02 = "#373b41",
  base03 = "#969896",
  base04 = "#b4b7b4",
  base05 = "#c5c8c6",
  base06 = "#e0e0e0",
  base07 = "#ffffff",
  base08 = "#cc6666",
  base09 = "#de935f",
  base0A = "#f0c674",
  base0B = "#b5bd68",
  base0C = "#8abeb7",
  base0D = "#81a2be",
  base0E = "#b294bb",
  base0F = "#a3685a",
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
      bg = M.palette.base07,
      fg = best_contrast_fg(M.palette.base07, M.palette.base00, M.palette.base05),
    },
    b = { bg = M.palette.base02, fg = M.palette.base05 },
    c = { bg = M.palette.base02, fg = M.palette.base05 },
  },
  insert = {
    a = {
      bg = M.palette.base0B,
      fg = best_contrast_fg(M.palette.base0B, M.palette.base00, M.palette.base05),
    },
    b = { bg = M.palette.base02, fg = M.palette.base05 },
    c = { bg = M.palette.base02, fg = M.palette.base05 },
  },
  visual = {
    a = {
      bg = M.palette.base0A,
      fg = best_contrast_fg(M.palette.base0A, M.palette.base00, M.palette.base05),
    },
    b = { bg = M.palette.base02, fg = M.palette.base05 },
    c = { bg = M.palette.base02, fg = M.palette.base05 },
  },
  replace = {
    a = {
      bg = M.palette.base08,
      fg = best_contrast_fg(M.palette.base08, M.palette.base00, M.palette.base05),
    },
    b = { bg = M.palette.base02, fg = M.palette.base05 },
    c = { bg = M.palette.base02, fg = M.palette.base05 },
  },
  command = {
    a = {
      bg = M.palette.base0D,
      fg = best_contrast_fg(M.palette.base0D, M.palette.base00, M.palette.base05),
    },
    b = { bg = M.palette.base02, fg = M.palette.base05 },
    c = { bg = M.palette.base02, fg = M.palette.base05 },
  },
  terminal = {
    a = {
      bg = M.palette.base0E,
      fg = best_contrast_fg(M.palette.base0E, M.palette.base00, M.palette.base05),
    },
    b = { bg = M.palette.base02, fg = M.palette.base05 },
    c = { bg = M.palette.base02, fg = M.palette.base05 },
  },
  inactive = {
    a = { bg = M.palette.base02, fg = M.palette.base03 },
    b = { bg = M.palette.base02, fg = M.palette.base05 },
    c = { bg = M.palette.base02, fg = M.palette.base05 },
  },
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
  hl("Normal", { fg = p.base05, bg = p.base00 })
  hl("NormalNC", { fg = p.base05, bg = p.base00 })
  hl("Terminal", { fg = p.base05, bg = p.base00 })
  hl("EndOfBuffer", { fg = p.base00, bg = p.base00 })
  hl("Folded", { fg = p.base03, bg = p.base01 })
  hl("ToolbarLine", { fg = p.base05, bg = p.base01 })
  hl("SignColumn", { fg = p.base05 })
  hl("FoldColumn", { fg = p.base03 })

  hl("IncSearch", { fg = p.base00, bg = p.base09 })
  hl("Search", { fg = p.base00, bg = p.base0A })
  link("CurSearch", "IncSearch")
  hl("ColorColumn", { bg = p.base01 })
  hl("Conceal", { fg = p.base01 })

  hl("Cursor", { reverse = true })
  link("vCursor", "Cursor")
  link("iCursor", "Cursor")
  link("lCursor", "Cursor")
  link("CursorIM", "Cursor")

  hl("CursorLine", { bg = p.base01 })
  hl("CursorColumn", { bg = p.base01 })

  -- LineNr: ui_contrast=low, sign_column_background=none
  hl("LineNr", { fg = p.base03 })
  hl("CursorLineNr", { fg = p.base07 })

  hl("DiffAdd", { fg = p.base0B, bg = p.base01 })
  hl("DiffChange", { fg = p.base05, bg = p.base01 })
  hl("DiffDelete", { fg = p.base08, bg = p.base01 })
  hl("DiffText", { fg = p.base00, bg = p.base02 })

  hl("Directory", { fg = p.base0B })
  hl("ErrorMsg", { fg = p.base08, underline = true })
  hl("WarningMsg", { fg = p.base0A })
  hl("ModeMsg", { fg = p.base05 })
  hl("MoreMsg", { fg = p.base0A })
  hl("MatchParen", { bg = p.base02 })
  hl("NonText", { fg = p.base01 })
  hl("Whitespace", { fg = p.base01 })
  hl("SpecialKey", { fg = p.base01 })

  -- Pmenu: menu_selection_background=grey
  hl("Pmenu", { fg = p.base05, bg = p.base00 })
  hl("PmenuSbar", { bg = p.base00 })
  hl("PmenuSel", { fg = p.base05, bg = p.base02 })
  hl("PmenuKind", { fg = p.base0B, bg = p.base00 })
  hl("PmenuExtra", { fg = p.base06, bg = p.base00 })
  link("WildMenu", "PmenuSel")
  hl("PmenuThumb", { bg = p.base03 })

  -- Float: match the main editor background with a visible border
  hl("NormalFloat", { fg = p.base05, bg = p.base00 })
  hl("FloatBorder", { fg = p.base03, bg = p.base00 })
  hl("FloatTitle", { fg = p.base09, bg = p.base00 })

  hl("Question", { fg = p.base0A })

  -- Spell
  hl("SpellBad", { undercurl = true, sp = p.base08 })
  hl("SpellCap", { undercurl = true, sp = p.base0D })
  hl("SpellLocal", { undercurl = true, sp = p.base0C })
  hl("SpellRare", { undercurl = true, sp = p.base0E })

  -- StatusLine: default style, transparent_background=0
  hl("StatusLine", { fg = p.base07, bg = p.base01 })
  hl("StatusLineTerm", { fg = p.base07, bg = p.base01 })
  hl("StatusLineNC", { fg = p.base04, bg = p.base01 })
  hl("StatusLineTermNC", { fg = p.base04, bg = p.base01 })
  hl("LualineSeparator", { fg = p.base05, bg = p.base02 })
  hl("TabLine", { fg = p.base04, bg = p.base01 })
  hl("TabLineFill", { fg = p.base04, bg = p.base01 })
  hl("TabLineSel", { fg = p.base05, bg = p.base02 })
  hl("WinBar", { fg = p.base05, bg = p.base00 })
  hl("WinBarNC", { fg = p.base04, bg = p.base00 })

  -- VertSplit / WinSeparator: match tmux separator color.
  hl("VertSplit", { fg = p.base03 })
  link("WinSeparator", "VertSplit")

  -- Visual: grey background
  hl("Visual", { fg = p.base05, bg = p.base02 })
  hl("VisualNOS", { fg = p.base05, bg = p.base02 })

  hl("QuickFixLine", { fg = p.base0E })
  hl("Debug", { fg = p.base09 })
  hl("debugPC", { fg = p.base00, bg = p.base0B })
  hl("debugBreakpoint", { fg = p.base00, bg = p.base08 })
  hl("ToolbarButton", { fg = p.base05, bg = p.base02 })
  hl("Substitute", { fg = p.base00, bg = p.base0A })

  -- Diagnostics: diagnostic_text_highlight=0
  hl("DiagnosticError", { fg = p.base08 })
  hl("DiagnosticWarn", { fg = p.base0A })
  hl("DiagnosticInfo", { fg = p.base0D })
  hl("DiagnosticHint", { fg = p.base0E })
  hl("DiagnosticOk", { fg = p.base0B })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = p.base08 })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = p.base0A })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = p.base0D })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = p.base0E })
  hl("DiagnosticUnderlineOk", { undercurl = true, sp = p.base0B })

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
  hl("Boolean", { fg = p.base09 })
  hl("Number", { fg = p.base09 })
  hl("Float", { fg = p.base09 })

  -- italic enabled
  hl("PreProc", { fg = p.base0E, italic = true })
  hl("PreCondit", { fg = p.base0E, italic = true })
  hl("Include", { fg = p.base0E, italic = true })
  hl("Define", { fg = p.base0E, italic = true })
  hl("Conditional", { fg = p.base0E, italic = true })
  hl("Repeat", { fg = p.base0E, italic = true })
  hl("Keyword", { fg = p.base0E, italic = true })
  hl("Typedef", { fg = p.base0E, italic = true })
  hl("Exception", { fg = p.base0E, italic = true })
  hl("Statement", { fg = p.base0E, italic = true })

  hl("Error", { fg = p.base08 })
  hl("StorageClass", { fg = p.base0A })
  hl("Tag", { fg = p.base0A })
  hl("Label", { fg = p.base0A })
  hl("Structure", { fg = p.base0A })
  hl("Operator", { fg = p.base0A })
  hl("Title", { fg = p.base0D })
  hl("Special", { fg = p.base0A })
  hl("SpecialChar", { fg = p.base0C })
  hl("Type", { fg = p.base0A })

  -- bold enabled
  hl("Function", { fg = p.base0D })

  hl("String", { fg = p.base0B })
  hl("Character", { fg = p.base0B })
  hl("Constant", { fg = p.base09 })
  hl("Macro", { fg = p.base0E })
  hl("Identifier", { fg = p.base08 })

  hl("Todo", { fg = p.base00, bg = p.base0D })

  -- italic comments (disable_italic_comment=false)
  hl("Comment", { fg = p.base03, italic = true })
  hl("SpecialComment", { fg = p.base03, italic = true })

  hl("Delimiter", { fg = p.base05 })
  hl("Ignore", { fg = p.base03 })
  hl("Underlined", { underline = true })

  -- ==========================================================================
  -- Predefined highlight groups
  -- ==========================================================================
  hl("Fg", { fg = p.base05 })
  hl("Grey", { fg = p.base03 })
  hl("Red", { fg = p.base08 })
  hl("Yellow", { fg = p.base0A })
  hl("Green", { fg = p.base0B })
  hl("Aqua", { fg = p.base0C })
  hl("Blue", { fg = p.base0D })
  hl("Purple", { fg = p.base0E })

  -- Italic variants (italic enabled)
  hl("RedItalic", { fg = p.base08, italic = true })
  hl("YellowItalic", { fg = p.base0A, italic = true })
  hl("GreenItalic", { fg = p.base0B, italic = true })
  hl("AquaItalic", { fg = p.base0C, italic = true })
  hl("BlueItalic", { fg = p.base0D, italic = true })
  hl("PurpleItalic", { fg = p.base0E, italic = true })

  -- Bold variants (bold enabled)
  hl("RedBold", { fg = p.base08, bold = true })
  hl("YellowBold", { fg = p.base0A, bold = true })
  hl("GreenBold", { fg = p.base0B, bold = true })
  hl("AquaBold", { fg = p.base0C, bold = true })
  hl("BlueBold", { fg = p.base0D, bold = true })
  hl("PurpleBold", { fg = p.base0E, bold = true })

  -- Sign variants (sign_column_background=none)
  hl("RedSign", { fg = p.base08 })
  hl("YellowSign", { fg = p.base0A })
  hl("GreenSign", { fg = p.base0B })
  hl("AquaSign", { fg = p.base0C })
  hl("BlueSign", { fg = p.base0D })
  hl("PurpleSign", { fg = p.base0E })

  link("Added", "Green")
  link("Removed", "Red")
  link("Changed", "Blue")

  -- ==========================================================================
  -- Error/Warning/Info/Hint text and lines
  -- ==========================================================================
  -- diagnostic_text_highlight=0
  hl("ErrorText", { undercurl = true, sp = p.base08 })
  hl("WarningText", { undercurl = true, sp = p.base0A })
  hl("InfoText", { undercurl = true, sp = p.base0D })
  hl("HintText", { undercurl = true, sp = p.base0E })

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

  hl("ErrorFloat", { fg = p.base08 })
  hl("WarningFloat", { fg = p.base0A })
  hl("InfoFloat", { fg = p.base0D })
  hl("HintFloat", { fg = p.base0E })
  hl("OkFloat", { fg = p.base0B })

  -- CurrentWord: current_word default = "grey background"
  hl("CurrentWord", { fg = p.base05, bg = p.base02 })

  -- InlayHints: inlay_hints_background=none
  link("InlayHints", "LineNr")

  -- ==========================================================================
  -- Terminal colors
  -- ==========================================================================
  vim.g.terminal_color_0 = p.base01
  vim.g.terminal_color_1 = p.base08
  vim.g.terminal_color_2 = p.base0B
  vim.g.terminal_color_3 = p.base0A
  vim.g.terminal_color_4 = p.base0D
  vim.g.terminal_color_5 = p.base0E
  vim.g.terminal_color_6 = p.base0C
  vim.g.terminal_color_7 = p.base06
  vim.g.terminal_color_8 = p.base03
  vim.g.terminal_color_9 = p.base08
  vim.g.terminal_color_10 = p.base0B
  vim.g.terminal_color_11 = p.base0A
  vim.g.terminal_color_12 = p.base0D
  vim.g.terminal_color_13 = p.base0E
  vim.g.terminal_color_14 = p.base0C
  vim.g.terminal_color_15 = p.base07

  -- ==========================================================================
  -- Treesitter highlights
  -- ==========================================================================
  hl("TSStrong", {})
  hl("TSEmphasis", { italic = true })
  hl("TSUnderline", { underline = true })
  hl("TSNote", { fg = p.base07, bg = p.base0E })
  hl("TSWarning", { fg = p.base00, bg = p.base0A })
  hl("TSDanger", { fg = p.base00, bg = p.base08 })

  -- Legacy TS* links
  link("TSAnnotation", "Orange")
  link("TSAttribute", "Aqua")
  link("TSBoolean", "Orange")
  link("TSCharacter", "Green")
  link("TSCharacterSpecial", "SpecialChar")
  link("TSComment", "Comment")
  link("TSConditional", "PurpleItalic")
  link("TSConstBuiltin", "Orange")
  link("TSConstMacro", "PurpleItalic")
  link("TSConstant", "Orange")
  link("TSConstructor", "Blue")
  link("TSDebug", "Debug")
  link("TSDefine", "Define")
  link("TSEnvironment", "Macro")
  link("TSEnvironmentName", "Type")
  link("TSError", "Error")
  link("TSException", "PurpleItalic")
  link("TSField", "Blue")
  link("TSFloat", "Orange")
  link("TSFuncBuiltin", "Blue")
  link("TSFuncMacro", "Purple")
  link("TSFunction", "Blue")
  link("TSFunctionCall", "Blue")
  link("TSInclude", "PurpleItalic")
  link("TSKeyword", "PurpleItalic")
  link("TSKeywordFunction", "PurpleItalic")
  link("TSKeywordOperator", "Yellow")
  link("TSKeywordReturn", "PurpleItalic")
  link("TSLabel", "Yellow")
  link("TSLiteral", "String")
  link("TSMath", "Blue")
  link("TSMethod", "Blue")
  link("TSMethodCall", "Blue")
  link("TSNamespace", "YellowItalic")
  link("TSNone", "Fg")
  link("TSNumber", "Orange")
  link("TSOperator", "Yellow")
  link("TSParameter", "Fg")
  link("TSParameterReference", "Fg")
  link("TSPreProc", "PreProc")
  link("TSProperty", "Blue")
  link("TSPunctBracket", "Fg")
  link("TSPunctDelimiter", "Grey")
  link("TSPunctSpecial", "Blue")
  link("TSRepeat", "PurpleItalic")
  link("TSStorageClass", "Yellow")
  link("TSStorageClassLifetime", "Yellow")
  link("TSStrike", "Grey")
  link("TSString", "Green")
  link("TSStringEscape", "Aqua")
  link("TSStringRegex", "Aqua")
  link("TSStringSpecial", "SpecialChar")
  link("TSSymbol", "Fg")
  link("TSTag", "Red")
  link("TSTagAttribute", "Yellow")
  link("TSTagDelimiter", "Red")
  link("TSText", "Green")
  link("TSTextReference", "Constant")
  link("TSTitle", "Title")
  link("TSTodo", "Todo")
  link("TSType", "YellowItalic")
  link("TSTypeBuiltin", "YellowItalic")
  link("TSTypeDefinition", "YellowItalic")
  link("TSTypeQualifier", "Yellow")
  hl("TSURI", { fg = p.base0D, underline = true })
  link("TSVariable", "Fg")
  link("TSVariableBuiltin", "PurpleItalic")

  -- Modern @* treesitter captures
  link("@annotation", "TSAnnotation")
  link("@attribute", "TSAttribute")
  link("@boolean", "TSBoolean")
  link("@character", "TSCharacter")
  link("@character.special", "TSCharacterSpecial")
  link("@comment", "TSComment")
  link("@comment.error", "TSDanger")
  link("@comment.note", "TSNote")
  link("@comment.todo", "TSTodo")
  link("@comment.warning", "TSWarning")
  link("@conceal", "Grey")
  link("@conditional", "TSConditional")
  link("@constant", "TSConstant")
  link("@constant.builtin", "TSConstBuiltin")
  link("@constant.macro", "TSConstMacro")
  link("@constructor", "TSConstructor")
  link("@debug", "TSDebug")
  link("@define", "TSDefine")
  link("@diff.delta", "diffChanged")
  link("@diff.minus", "diffRemoved")
  link("@diff.plus", "diffAdded")
  link("@error", "TSError")
  link("@exception", "TSException")
  link("@field", "TSField")
  link("@float", "TSFloat")
  link("@function", "TSFunction")
  link("@function.builtin", "TSFuncBuiltin")
  link("@function.call", "TSFunctionCall")
  link("@function.macro", "TSFuncMacro")
  link("@function.method", "TSMethod")
  link("@function.method.call", "TSMethodCall")
  link("@include", "TSInclude")
  link("@keyword", "TSKeyword")
  link("@keyword.conditional", "TSConditional")
  link("@keyword.debug", "TSDebug")
  link("@keyword.directive", "TSPreProc")
  link("@keyword.directive.define", "TSDefine")
  link("@keyword.exception", "TSException")
  link("@keyword.function", "TSKeywordFunction")
  link("@keyword.import", "TSInclude")
  link("@keyword.operator", "TSKeywordOperator")
  link("@keyword.repeat", "TSRepeat")
  link("@keyword.return", "TSKeywordReturn")
  link("@keyword.storage", "TSStorageClass")
  link("@label", "TSLabel")
  link("@markup.emphasis", "TSEmphasis")
  link("@markup.environment", "TSEnvironment")
  link("@markup.environment.name", "TSEnvironmentName")
  link("@markup.heading", "TSTitle")
  link("@markup.link", "TSTextReference")
  link("@markup.link.label", "TSStringSpecial")
  link("@markup.link.url", "TSURI")
  link("@markup.list", "TSPunctSpecial")
  link("@markup.list.checked", "Green")
  link("@markup.list.unchecked", "Ignore")
  link("@markup.math", "TSMath")
  link("@markup.note", "TSNote")
  link("@markup.quote", "Grey")
  link("@markup.raw", "TSLiteral")
  link("@markup.strike", "TSStrike")
  link("@markup.strong", "TSStrong")
  link("@markup.underline", "TSUnderline")
  link("@math", "TSMath")
  link("@method", "TSMethod")
  link("@method.call", "TSMethodCall")
  link("@module", "TSNamespace")
  link("@namespace", "TSNamespace")
  link("@none", "TSNone")
  link("@number", "TSNumber")
  link("@number.float", "TSFloat")
  link("@operator", "TSOperator")
  link("@parameter", "TSParameter")
  link("@parameter.reference", "TSParameterReference")
  link("@preproc", "TSPreProc")
  link("@property", "TSProperty")
  link("@punctuation.bracket", "TSPunctBracket")
  link("@punctuation.delimiter", "TSPunctDelimiter")
  link("@punctuation.special", "TSPunctSpecial")
  link("@repeat", "TSRepeat")
  link("@storageclass", "TSStorageClass")
  link("@storageclass.lifetime", "TSStorageClassLifetime")
  link("@strike", "TSStrike")
  link("@string", "TSString")
  link("@string.escape", "TSStringEscape")
  link("@string.regex", "TSStringRegex")
  link("@string.regexp", "TSStringRegex")
  link("@string.special", "TSStringSpecial")
  link("@string.special.symbol", "TSSymbol")
  link("@string.special.uri", "TSURI")
  link("@symbol", "TSSymbol")
  link("@tag", "TSTag")
  link("@tag.attribute", "TSTagAttribute")
  link("@tag.delimiter", "TSTagDelimiter")
  link("@text", "TSText")
  link("@text.danger", "TSDanger")
  link("@text.diff.add", "diffAdded")
  link("@text.diff.delete", "diffRemoved")
  link("@text.emphasis", "TSEmphasis")
  link("@text.environment", "TSEnvironment")
  link("@text.environment.name", "TSEnvironmentName")
  link("@text.literal", "TSLiteral")
  link("@text.math", "TSMath")
  link("@text.note", "TSNote")
  link("@text.reference", "TSTextReference")
  link("@text.strike", "TSStrike")
  link("@text.strong", "TSStrong")
  link("@text.title", "TSTitle")
  link("@text.todo", "TSTodo")
  link("@text.todo.checked", "Green")
  link("@text.todo.unchecked", "Ignore")
  link("@text.underline", "TSUnderline")
  link("@text.uri", "TSURI")
  link("@text.warning", "TSWarning")
  link("@todo", "TSTodo")
  link("@type", "TSType")
  link("@type.builtin", "TSTypeBuiltin")
  link("@type.definition", "TSTypeDefinition")
  link("@type.qualifier", "TSTypeQualifier")
  link("@uri", "TSURI")
  link("@variable", "TSVariable")
  link("@variable.builtin", "TSVariableBuiltin")
  link("@variable.member", "TSField")
  link("@variable.parameter", "TSParameter")

  -- @lsp.type.* semantic tokens
  link("@lsp.type.class", "TSType")
  link("@lsp.type.comment", "TSComment")
  link("@lsp.type.decorator", "TSFunction")
  link("@lsp.type.enum", "TSType")
  link("@lsp.type.enumMember", "TSProperty")
  link("@lsp.type.events", "TSLabel")
  link("@lsp.type.function", "TSFunction")
  link("@lsp.type.interface", "TSType")
  link("@lsp.type.keyword", "TSKeyword")
  link("@lsp.type.macro", "TSConstMacro")
  link("@lsp.type.method", "TSMethod")
  link("@lsp.type.modifier", "TSTypeQualifier")
  link("@lsp.type.namespace", "TSNamespace")
  link("@lsp.type.number", "TSNumber")
  link("@lsp.type.operator", "TSOperator")
  link("@lsp.type.parameter", "TSParameter")
  link("@lsp.type.property", "TSProperty")
  link("@lsp.type.regexp", "TSStringRegex")
  link("@lsp.type.string", "TSString")
  link("@lsp.type.struct", "TSType")
  link("@lsp.type.type", "TSType")
  link("@lsp.type.typeParameter", "TSTypeDefinition")
  link("@lsp.type.variable", "TSVariable")

  hl("DiagnosticUnnecessary", { fg = p.base03 })
  hl("DiagnosticDeprecated", { strikethrough = true, sp = p.base05 })

  link("TSModuleInfoGood", "Green")
  link("TSModuleInfoBad", "Red")

  -- ==========================================================================
  -- Plugin highlights
  -- ==========================================================================

  -- nvim-treesitter-context
  hl("TreesitterContext", { fg = p.base05, bg = p.base00 })

  -- github/copilot.vim
  link("CopilotSuggestion", "Grey")

  -- hrsh7th/nvim-cmp
  hl("CmpItemAbbrMatch", { fg = p.base0B })
  hl("CmpItemAbbrMatchFuzzy", { fg = p.base0B })
  link("CmpItemAbbr", "Fg")
  link("CmpItemAbbrDeprecated", "Grey")
  link("CmpItemMenu", "Fg")
  link("CmpItemKind", "Yellow")
  -- CmpItemKind* links
  link("CmpItemKindArray", "Aqua")
  link("CmpItemKindBoolean", "Orange")
  link("CmpItemKindClass", "Red")
  link("CmpItemKindColor", "Aqua")
  link("CmpItemKindConstant", "Orange")
  link("CmpItemKindConstructor", "Blue")
  link("CmpItemKindDefault", "Aqua")
  link("CmpItemKindEnum", "Yellow")
  link("CmpItemKindEnumMember", "Purple")
  link("CmpItemKindEvent", "Yellow")
  link("CmpItemKindField", "Green")
  link("CmpItemKindFile", "Green")
  link("CmpItemKindFolder", "Aqua")
  link("CmpItemKindFunction", "Blue")
  link("CmpItemKindInterface", "Yellow")
  link("CmpItemKindKey", "Red")
  link("CmpItemKindKeyword", "Purple")
  link("CmpItemKindMethod", "Blue")
  link("CmpItemKindModule", "Purple")
  link("CmpItemKindNamespace", "Purple")
  link("CmpItemKindNull", "Aqua")
  link("CmpItemKindNumber", "Orange")
  link("CmpItemKindObject", "Aqua")
  link("CmpItemKindOperator", "Yellow")
  link("CmpItemKindPackage", "Purple")
  link("CmpItemKindProperty", "Blue")
  link("CmpItemKindReference", "Aqua")
  link("CmpItemKindSnippet", "Aqua")
  link("CmpItemKindString", "Green")
  link("CmpItemKindStruct", "Yellow")
  link("CmpItemKindText", "Fg")
  link("CmpItemKindTypeParameter", "Yellow")
  link("CmpItemKindUnit", "Purple")
  link("CmpItemKindValue", "Purple")
  link("CmpItemKindVariable", "Blue")

  -- folke/trouble.nvim
  link("TroubleText", "Fg")
  link("TroubleSource", "Grey")
  link("TroubleCode", "Grey")
  link("TroubleNormal", "Normal")
  link("TroubleNormalNC", "Normal")

  -- nvim-telescope/telescope.nvim
  hl("TelescopeMatching", { fg = p.base0B })
  hl("TelescopeBorder", { fg = p.base03 })
  hl("TelescopePromptCounter", { fg = p.base04 })
  link("TelescopePromptPrefix", "Yellow")
  link("TelescopeSelection", "DiffAdd")

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

  -- sindrets/diffview.nvim
  link("DiffviewDiffAdd", "DiffAdd")
  link("DiffviewDiffDelete", "DiffDelete")
  hl("DiffviewDiffChange", { fg = p.base05, bg = p.base01 })
  hl("DiffviewDiffText", { fg = p.base00, bg = p.base02 })
  link("DiffviewStatusModified", "Green")
  link("DiffviewStatusRenamed", "Green")
  link("DiffviewStatusCopied", "Green")
  link("DiffviewStatusTypeChange", "Green")
  link("DiffviewStatusUnmerged", "Green")

  -- lukas-reineke/indent-blankline.nvim
  hl("IblScope", { fg = p.base03, nocombine = true })
  hl("IblIndent", { fg = p.base01, nocombine = true })
  link("IndentBlanklineContextChar", "IblScope")
  link("IndentBlanklineChar", "IblIndent")
  link("IndentBlanklineSpaceChar", "IndentBlanklineChar")
  link("IndentBlanklineSpaceCharBlankline", "IndentBlanklineChar")

  -- folke/which-key.nvim
  link("WhichKey", "Red")
  link("WhichKeySeparator", "Green")
  link("WhichKeyGroup", "Yellow")
  link("WhichKeyDesc", "Blue")

  -- lem.terminal backdrop
  hl("TerminalBackdrop", { bg = p.base00 })

  -- nvim-tree/nvim-tree.lua
  link("NvimTreeNormal", "Normal")
  link("NvimTreeNormalNC", "Normal")
  link("NvimTreeEndOfBuffer", "Normal")
  hl("NvimTreeWinSeparator", { fg = p.base03, bg = p.base00 })
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
  hl("CsvViewHeaderLine", { bg = p.base01 })
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

  -- pwntester/octo.nvim
  hl("OctoGreen", { fg = p.base0B })
  hl("OctoBlue", { fg = p.base0D })
  hl("OctoYellow", { fg = p.base0A })
  hl("OctoRed", { fg = p.base08 })
  hl("OctoPurple", { fg = p.base0E })
  hl("OctoGrey", { fg = p.base03 })
  hl("OctoViewer", { fg = p.base06 })
  hl("OctoBubble", { fg = p.base05, bg = p.base00 })
  hl("OctoBubbleGreen", { fg = p.base0B, bg = p.base03 })
  hl("OctoBubbleRed", { fg = p.base08, bg = p.base03 })
  hl("OctoBubblePurple", { fg = p.base0E, bg = p.base03 })
  hl("OctoBubbleYellow", { fg = p.base0A, bg = p.base03 })
  hl("OctoBubbleBlue", { fg = p.base0D, bg = p.base03 })
  hl("OctoGreenFloat", { fg = p.base0B, bg = p.base00 })
  hl("OctoRedFloat", { fg = p.base08, bg = p.base00 })
  hl("OctoPurpleFloat", { fg = p.base0E, bg = p.base00 })
  hl("OctoGreyFloat", { fg = p.base03, bg = p.base00 })

  link("OctoNormal", "Normal")
  link("OctoCursorLine", "CursorLine")
  link("OctoWinSeparator", "WinSeparator")
  link("OctoSignColumn", "Normal")
  link("OctoStatusColumn", "SignColumn")
  link("OctoStatusLine", "StatusLine")
  link("OctoStatusLineNC", "StatusLineNC")
  link("OctoEndOfBuffer", "EndOfBuffer")
  link("OctoFilePanelFileName", "NormalFloat")
  link("OctoFilePanelSelectedFile", "Type")
  link("OctoFilePanelPath", "Comment")
  link("OctoStatusAdded", "OctoGreen")
  link("OctoStatusUntracked", "OctoGreen")
  link("OctoStatusModified", "OctoGreen")
  link("OctoStatusRenamed", "OctoGreen")
  link("OctoStatusCopied", "OctoGreen")
  link("OctoStatusTypeChange", "OctoGreen")
  link("OctoStatusUnmerged", "OctoGreen")
  link("OctoStatusUnknown", "OctoYellow")
  link("OctoStatusDeleted", "OctoRed")
  link("OctoStatusBroken", "OctoRed")
  link("OctoDirty", "OctoRed")
  link("OctoIssueId", "NormalFloat")
  link("OctoIssueTitle", "PreProc")
  link("OctoFloat", "NormalFloat")
  link("OctoTimelineItemHeading", "Comment")
  link("OctoTimelineMarker", "Identifier")
  link("OctoSymbol", "Comment")
  link("OctoDate", "Comment")
  link("OctoDetailsLabel", "Title")
  link("OctoDetailsValue", "Identifier")
  link("OctoMissingDetails", "Comment")
  link("OctoEmpty", "NormalFloat")
  link("OctoBubble", "OctoBubble")
  link("OctoUser", "OctoBubble")
  link("OctoUserViewer", "OctoViewer")
  link("OctoReaction", "OctoBubble")
  link("OctoReactionViewer", "OctoViewer")
  link("OctoPassingTest", "OctoGreen")
  link("OctoFailingTest", "OctoRed")
  link("OctoPullAdditions", "OctoGreen")
  link("OctoPullDeletions", "OctoRed")
  link("OctoPullModifications", "OctoGrey")
  link("OctoStateOpen", "OctoGreen")
  link("OctoStateClosed", "OctoRed")
  link("OctoStateCompleted", "OctoPurple")
  link("OctoStateNotPlanned", "OctoGrey")
  link("OctoStateDraft", "OctoGrey")
  link("OctoStateMerge", "OctoPurple")
  link("OctoStatePending", "OctoYellow")
  link("OctoStateApproved", "OctoGreen")
  link("OctoStateChangesRequested", "OctoRed")
  link("OctoStateDismissed", "OctoRed")
  link("OctoStateCommented", "OctoBlue")
  link("OctoStateSubmitted", "OctoGreen")
  link("OctoStateOpenBubble", "OctoBubbleGreen")
  link("OctoStateClosedBubble", "OctoBubbleRed")
  link("OctoStateMergedBubble", "OctoBubblePurple")
  link("OctoStatePendingBubble", "OctoBubbleYellow")
  link("OctoStateApprovedBubble", "OctoBubbleGreen")
  link("OctoStateChangesRequestedBubble", "OctoBubbleRed")
  link("OctoStateDismissedBubble", "OctoBubbleRed")
  link("OctoStateCommentedBubble", "OctoBubbleBlue")
  link("OctoStateSubmittedBubble", "OctoBubbleGreen")
  link("OctoStateOpenFloat", "OctoGreenFloat")
  link("OctoStateClosedFloat", "OctoRedFloat")
  link("OctoStateMergedFloat", "OctoPurpleFloat")
  link("OctoStateDraftFloat", "OctoGreyFloat")
  -- diff
  link("diffAdded", "Green")
  link("diffRemoved", "Red")
  link("diffChanged", "Green")
  link("diffFile", "Aqua")
  link("diffOldFile", "Yellow")
  link("diffNewFile", "Yellow")
  link("diffIndexLine", "Purple")
  link("diffLine", "Grey")

  -- ==========================================================================
  -- Filetype-specific highlights
  -- ==========================================================================

  -- markdown
  hl("markdownH1", { fg = p.base08 })
  hl("markdownH2", { fg = p.base09 })
  hl("markdownH3", { fg = p.base0A })
  hl("markdownH4", { fg = p.base0B })
  hl("markdownH5", { fg = p.base0D })
  hl("markdownH6", { fg = p.base0E })
  hl("markdownItalic", { italic = true })
  hl("markdownBold", { bold = true })
  hl("markdownItalicDelimiter", { fg = p.base03, italic = true })
  link("markdownUrl", "TSURI")
  link("markdownCode", "Green")
  link("markdownCodeBlock", "Aqua")
  link("markdownCodeDelimiter", "Aqua")
  link("markdownBlockquote", "Grey")
  link("markdownListMarker", "Red")
  link("markdownOrderedListMarker", "Red")
  link("markdownRule", "Purple")
  link("markdownHeadingRule", "Grey")
  link("markdownUrlDelimiter", "Grey")
  link("markdownLinkDelimiter", "Grey")
  link("markdownLinkTextDelimiter", "Grey")
  link("markdownHeadingDelimiter", "Grey")
  link("markdownLinkText", "Purple")
  link("markdownUrlTitleDelimiter", "Green")
  link("markdownIdDeclaration", "markdownLinkText")
  link("markdownBoldDelimiter", "Grey")
  link("markdownId", "Yellow")
  -- treesitter markdown headings
  link("@markup.heading.1.markdown", "markdownH1")
  link("@markup.heading.2.markdown", "markdownH2")
  link("@markup.heading.3.markdown", "markdownH3")
  link("@markup.heading.4.markdown", "markdownH4")
  link("@markup.heading.5.markdown", "markdownH5")
  link("@markup.heading.6.markdown", "markdownH6")
  link("@markup.heading.1.marker.markdown", "@conceal")
  link("@markup.heading.2.marker.markdown", "@conceal")
  link("@markup.heading.3.marker.markdown", "@conceal")
  link("@markup.heading.4.marker.markdown", "@conceal")
  link("@markup.heading.5.marker.markdown", "@conceal")
  link("@markup.heading.6.marker.markdown", "@conceal")

  -- lua
  link("luaFunc", "Green")
  link("luaFunction", "Aqua")
  link("luaTable", "Fg")
  link("luaIn", "RedItalic")
  link("luaFuncCall", "Green")
  link("luaLocal", "Yellow")
  link("luaSpecialValue", "Green")
  link("luaBraces", "Fg")
  link("luaBuiltIn", "Purple")
  link("luaNoise", "Grey")
  link("luaLabel", "Purple")
  link("luaFuncTable", "Yellow")
  link("luaFuncArgName", "Blue")
  link("luaEllipsis", "Yellow")
  link("luaDocTag", "Green")
  link("luaTSConstructor", "luaBraces")
  link("@constructor.lua", "luaTSConstructor")

  -- go
  link("goPackage", "Define")
  link("goImport", "Include")
  link("goVar", "YellowItalic")
  link("goConst", "goVar")
  link("goType", "Yellow")
  link("goSignedInts", "goType")
  link("goUnsignedInts", "goType")
  link("goFloats", "goType")
  link("goComplexes", "goType")
  link("goVarDefs", "Aqua")
  link("goDeclType", "YellowItalic")
  link("goFunctionCall", "Function")
  link("goPredefinedIdentifiers", "Aqua")
  link("goBuiltins", "Green")
  link("goVarArgs", "Grey")
  -- go treesitter overrides
  link("goTSInclude", "Purple")
  link("goTSNamespace", "Fg")
  link("goTSConstBuiltin", "AquaItalic")
  link("@include.go", "goTSInclude")
  link("@namespace.go", "goTSNamespace")
  link("@module.go", "goTSNamespace")
  link("@constant.builtin.go", "goTSConstBuiltin")
  link("@lsp.typemod.variable.defaultLibrary.go", "goTSConstBuiltin")
  link("@lsp.type.namespace.go", "goTSNamespace")

  -- lazy.nvim
  link("LazyNormal", "Normal")
  hl("LazyH1", { fg = p.base00, bg = p.base08 })
  hl("LazyH2", { fg = p.base0A })
  hl("LazyButton", { fg = p.base05, bg = p.base00 })
  hl("LazyButtonActive", { fg = p.base00, bg = p.base06 })
  hl("LazyProp", { fg = p.base03 })
  hl("LazyCommit", { fg = p.base0C })

  -- mason
  hl("MasonHeader", { fg = p.base00, bg = p.base08 })
  hl("MasonHeaderSecondary", { fg = p.base00, bg = p.base0A })
  link("MasonHighlight", "Green")
  link("MasonHighlightSecondary", "Yellow")
  hl("MasonHighlightBlock", { fg = p.base00, bg = p.base0A })
  hl("MasonHighlightBlockBold", { fg = p.base00, bg = p.base0A, bold = true })
  hl("MasonHighlightBlockSecondary", { fg = p.base00, bg = p.base08 })
  hl(
    "MasonHighlightBlockBoldSecondary",
    { fg = p.base00, bg = p.base08, bold = true }
  )
  hl("MasonMuted", { fg = p.base03 })
  hl("MasonMutedBlock", { fg = p.base00, bg = p.base03 })
end

return M
