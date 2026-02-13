-- Gruvbox Dark Custom colorscheme (no external dependency)

local M = {}

-- Palette: dark / medium / material
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
  red = "#ea6962",
  orange = "#e78a4e",
  yellow = "#d8a657",
  green = "#a9b665",
  aqua = "#89b482",
  blue = "#7daea3",
  purple = "#d3869b",
  bg_red = "#ea6962",
  bg_green = "#a9b665",
  bg_yellow = "#d8a657",
  grey0 = "#7c6f64",
  grey1 = "#928374",
  grey2 = "#a89984",
}

function M.setup()
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "gruvbox-dark-custom"
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
  hl("Folded", { fg = p.grey1, bg = p.bg2 })
  hl("ToolbarLine", { fg = p.fg1, bg = p.bg3 })
  hl("SignColumn", { fg = p.fg0 })
  hl("FoldColumn", { fg = p.bg5 }) -- ui_contrast=low

  hl("IncSearch", { fg = p.bg0, bg = p.bg_red })
  hl("Search", { fg = p.bg0, bg = p.bg_green })
  link("CurSearch", "IncSearch")
  hl("ColorColumn", { bg = p.bg2 })
  hl("Conceal", { fg = p.bg5 }) -- ui_contrast=low

  hl("Cursor", { reverse = true })
  link("vCursor", "Cursor")
  link("iCursor", "Cursor")
  link("lCursor", "Cursor")
  link("CursorIM", "Cursor")

  hl("CursorLine", { bg = p.bg1 })
  hl("CursorColumn", { bg = p.bg1 })

  -- LineNr: ui_contrast=low, sign_column_background=none
  hl("LineNr", { fg = p.bg5 })
  hl("CursorLineNr", { fg = p.grey1 })

  hl("DiffAdd", { bg = p.bg_diff_green })
  hl("DiffChange", { bg = p.bg_diff_blue })
  hl("DiffDelete", { bg = p.bg_diff_red })
  hl("DiffText", { fg = p.bg0, bg = p.blue })

  hl("Directory", { fg = p.green })
  hl("ErrorMsg", { fg = p.red, bold = true, underline = true })
  hl("WarningMsg", { fg = p.yellow, bold = true })
  hl("ModeMsg", { fg = p.fg0, bold = true })
  hl("MoreMsg", { fg = p.yellow, bold = true })
  hl("MatchParen", { bg = p.bg4 })
  hl("NonText", { fg = p.bg5 })
  hl("Whitespace", { fg = p.bg5 })
  hl("SpecialKey", { fg = p.orange })

  -- Pmenu: menu_selection_background=grey
  hl("Pmenu", { fg = p.fg1, bg = p.bg3 })
  hl("PmenuSbar", { bg = p.bg3 })
  hl("PmenuSel", { fg = p.bg3, bg = p.grey2 })
  hl("PmenuKind", { fg = p.green, bg = p.bg3 })
  hl("PmenuExtra", { fg = p.grey2, bg = p.bg3 })
  link("WildMenu", "PmenuSel")
  hl("PmenuThumb", { bg = p.grey0 })

  -- Float: editor bg with visible border
  hl("NormalFloat", { fg = p.fg1, bg = p.bg0 })
  hl("FloatBorder", { fg = p.grey2, bg = p.bg0 })
  hl("FloatTitle", { fg = p.orange, bg = p.bg0, bold = true })

  hl("Question", { fg = p.yellow })

  -- Spell
  hl("SpellBad", { undercurl = true, sp = p.red })
  hl("SpellCap", { undercurl = true, sp = p.blue })
  hl("SpellLocal", { undercurl = true, sp = p.aqua })
  hl("SpellRare", { undercurl = true, sp = p.purple })

  -- StatusLine: default style, transparent_background=0
  hl("StatusLine", { fg = p.fg1, bg = p.bg_statusline1 })
  hl("StatusLineTerm", { fg = p.fg1, bg = p.bg_statusline1 })
  hl("StatusLineNC", { fg = p.grey1, bg = p.bg_statusline1 })
  hl("StatusLineTermNC", { fg = p.grey1, bg = p.bg_statusline1 })
  hl("TabLine", { fg = p.fg1, bg = p.bg_statusline3 })
  hl("TabLineFill", { fg = p.fg1, bg = p.bg_statusline1 })
  hl("TabLineSel", { fg = p.bg0, bg = p.grey2 })
  hl("WinBar", { fg = p.fg1, bg = p.bg_statusline1, bold = true })
  hl("WinBarNC", { fg = p.grey1, bg = p.bg_statusline1 })

  -- VertSplit / WinSeparator
  hl("VertSplit", { fg = p.grey0 })
  link("WinSeparator", "VertSplit")

  -- Visual: grey background
  hl("Visual", { bg = p.bg3 })
  hl("VisualNOS", { bg = p.bg3 })

  hl("QuickFixLine", { fg = p.purple, bold = true })
  hl("Debug", { fg = p.orange })
  hl("debugPC", { fg = p.bg0, bg = p.green })
  hl("debugBreakpoint", { fg = p.bg0, bg = p.red })
  hl("ToolbarButton", { fg = p.bg0, bg = p.grey2 })
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
  link("DiagnosticSignError", "RedSign")
  link("DiagnosticSignWarn", "YellowSign")
  link("DiagnosticSignInfo", "BlueSign")
  link("DiagnosticSignHint", "PurpleSign")
  link("DiagnosticSignOk", "GreenSign")

  -- Legacy LSP diagnostic links
  link("LspDiagnosticsFloatingError", "DiagnosticFloatingError")
  link("LspDiagnosticsFloatingWarning", "DiagnosticFloatingWarn")
  link("LspDiagnosticsFloatingInformation", "DiagnosticFloatingInfo")
  link("LspDiagnosticsFloatingHint", "DiagnosticFloatingHint")
  link("LspDiagnosticsDefaultError", "DiagnosticError")
  link("LspDiagnosticsDefaultWarning", "DiagnosticWarn")
  link("LspDiagnosticsDefaultInformation", "DiagnosticInfo")
  link("LspDiagnosticsDefaultHint", "DiagnosticHint")
  link("LspDiagnosticsVirtualTextError", "DiagnosticVirtualTextError")
  link("LspDiagnosticsVirtualTextWarning", "DiagnosticVirtualTextWarn")
  link("LspDiagnosticsVirtualTextInformation", "DiagnosticVirtualTextInfo")
  link("LspDiagnosticsVirtualTextHint", "DiagnosticVirtualTextHint")
  link("LspDiagnosticsUnderlineError", "DiagnosticUnderlineError")
  link("LspDiagnosticsUnderlineWarning", "DiagnosticUnderlineWarn")
  link("LspDiagnosticsUnderlineInformation", "DiagnosticUnderlineInfo")
  link("LspDiagnosticsUnderlineHint", "DiagnosticUnderlineHint")
  link("LspDiagnosticsSignError", "DiagnosticSignError")
  link("LspDiagnosticsSignWarning", "DiagnosticSignWarn")
  link("LspDiagnosticsSignInformation", "DiagnosticSignInfo")
  link("LspDiagnosticsSignHint", "DiagnosticSignHint")
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

  -- italic enabled
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

  -- bold enabled
  hl("Function", { fg = p.green, bold = true })

  hl("String", { fg = p.green })
  hl("Character", { fg = p.green })
  hl("Constant", { fg = p.aqua })
  hl("Macro", { fg = p.aqua })
  hl("Identifier", { fg = p.blue })

  hl("Todo", { fg = p.bg0, bg = p.blue, bold = true })

  -- italic comments (disable_italic_comment=false)
  hl("Comment", { fg = p.grey1, italic = true })
  hl("SpecialComment", { fg = p.grey1, italic = true })

  hl("Delimiter", { fg = p.fg0 })
  hl("Ignore", { fg = p.grey1 })
  hl("Underlined", { underline = true })

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
  hl("CurrentWord", { bg = p.bg_current_word })

  -- InlayHints: inlay_hints_background=none
  link("InlayHints", "LineNr")

  -- ==========================================================================
  -- Terminal colors
  -- ==========================================================================
  vim.g.terminal_color_0 = p.bg5
  vim.g.terminal_color_1 = p.red
  vim.g.terminal_color_2 = p.green
  vim.g.terminal_color_3 = p.yellow
  vim.g.terminal_color_4 = p.blue
  vim.g.terminal_color_5 = p.purple
  vim.g.terminal_color_6 = p.aqua
  vim.g.terminal_color_7 = p.fg0
  vim.g.terminal_color_8 = p.bg5
  vim.g.terminal_color_9 = p.red
  vim.g.terminal_color_10 = p.green
  vim.g.terminal_color_11 = p.yellow
  vim.g.terminal_color_12 = p.blue
  vim.g.terminal_color_13 = p.purple
  vim.g.terminal_color_14 = p.aqua
  vim.g.terminal_color_15 = p.fg0

  -- ==========================================================================
  -- Treesitter highlights
  -- ==========================================================================
  hl("TSStrong", { bold = true })
  hl("TSEmphasis", { italic = true })
  hl("TSUnderline", { underline = true })
  hl("TSNote", { fg = p.bg0, bg = p.green, bold = true })
  hl("TSWarning", { fg = p.bg0, bg = p.yellow, bold = true })
  hl("TSDanger", { fg = p.bg0, bg = p.red, bold = true })

  -- Legacy TS* links
  link("TSAnnotation", "Purple")
  link("TSAttribute", "Purple")
  link("TSBoolean", "Purple")
  link("TSCharacter", "Aqua")
  link("TSCharacterSpecial", "SpecialChar")
  link("TSComment", "Comment")
  link("TSConditional", "Red")
  link("TSConstBuiltin", "PurpleItalic")
  link("TSConstMacro", "PurpleItalic")
  link("TSConstant", "Fg")
  link("TSConstructor", "GreenBold")
  link("TSDebug", "Debug")
  link("TSDefine", "Define")
  link("TSEnvironment", "Macro")
  link("TSEnvironmentName", "Type")
  link("TSError", "Error")
  link("TSException", "Red")
  link("TSField", "Blue")
  link("TSFloat", "Purple")
  link("TSFuncBuiltin", "GreenBold")
  link("TSFuncMacro", "GreenBold")
  link("TSFunction", "GreenBold")
  link("TSFunctionCall", "GreenBold")
  link("TSInclude", "Red")
  link("TSKeyword", "Red")
  link("TSKeywordFunction", "Red")
  link("TSKeywordOperator", "Orange")
  link("TSKeywordReturn", "Red")
  link("TSLabel", "Orange")
  link("TSLiteral", "String")
  link("TSMath", "Blue")
  link("TSMethod", "GreenBold")
  link("TSMethodCall", "GreenBold")
  link("TSNamespace", "YellowItalic")
  link("TSNone", "Fg")
  link("TSNumber", "Purple")
  link("TSOperator", "Orange")
  link("TSParameter", "Fg")
  link("TSParameterReference", "Fg")
  link("TSPreProc", "PreProc")
  link("TSProperty", "Blue")
  link("TSPunctBracket", "Fg")
  link("TSPunctDelimiter", "Grey")
  link("TSPunctSpecial", "Blue")
  link("TSRepeat", "Red")
  link("TSStorageClass", "Orange")
  link("TSStorageClassLifetime", "Orange")
  link("TSStrike", "Grey")
  link("TSString", "Aqua")
  link("TSStringEscape", "Green")
  link("TSStringRegex", "Green")
  link("TSStringSpecial", "SpecialChar")
  link("TSSymbol", "Fg")
  link("TSTag", "Orange")
  link("TSTagAttribute", "Green")
  link("TSTagDelimiter", "Green")
  link("TSText", "Green")
  link("TSTextReference", "Constant")
  link("TSTitle", "Title")
  link("TSTodo", "Todo")
  link("TSType", "YellowItalic")
  link("TSTypeBuiltin", "YellowItalic")
  link("TSTypeDefinition", "YellowItalic")
  link("TSTypeQualifier", "Orange")
  hl("TSURI", { fg = p.blue, underline = true })
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

  hl("DiagnosticUnnecessary", { fg = p.grey1 })
  hl("DiagnosticDeprecated", { strikethrough = true, sp = p.fg0 })

  link("TSModuleInfoGood", "Green")
  link("TSModuleInfoBad", "Red")

  -- ==========================================================================
  -- Plugin highlights
  -- ==========================================================================

  -- nvim-treesitter-context
  hl("TreesitterContext", { fg = p.fg1, bg = p.bg3 })

  -- github/copilot.vim
  link("CopilotSuggestion", "Grey")

  -- hrsh7th/nvim-cmp
  hl("CmpItemAbbrMatch", { fg = p.green, bold = true })
  hl("CmpItemAbbrMatchFuzzy", { fg = p.green, bold = true })
  link("CmpItemAbbr", "Fg")
  link("CmpItemAbbrDeprecated", "Grey")
  link("CmpItemMenu", "Fg")
  link("CmpItemKind", "Yellow")
  -- CmpItemKind* links
  link("CmpItemKindArray", "Aqua")
  link("CmpItemKindBoolean", "Aqua")
  link("CmpItemKindClass", "Red")
  link("CmpItemKindColor", "Aqua")
  link("CmpItemKindConstant", "Blue")
  link("CmpItemKindConstructor", "Green")
  link("CmpItemKindDefault", "Aqua")
  link("CmpItemKindEnum", "Yellow")
  link("CmpItemKindEnumMember", "Purple")
  link("CmpItemKindEvent", "Orange")
  link("CmpItemKindField", "Green")
  link("CmpItemKindFile", "Green")
  link("CmpItemKindFolder", "Aqua")
  link("CmpItemKindFunction", "Green")
  link("CmpItemKindInterface", "Yellow")
  link("CmpItemKindKey", "Red")
  link("CmpItemKindKeyword", "Red")
  link("CmpItemKindMethod", "Green")
  link("CmpItemKindModule", "Purple")
  link("CmpItemKindNamespace", "Purple")
  link("CmpItemKindNull", "Aqua")
  link("CmpItemKindNumber", "Aqua")
  link("CmpItemKindObject", "Aqua")
  link("CmpItemKindOperator", "Orange")
  link("CmpItemKindPackage", "Purple")
  link("CmpItemKindProperty", "Blue")
  link("CmpItemKindReference", "Aqua")
  link("CmpItemKindSnippet", "Aqua")
  link("CmpItemKindString", "Aqua")
  link("CmpItemKindStruct", "Yellow")
  link("CmpItemKindText", "Fg")
  link("CmpItemKindTypeParameter", "Yellow")
  link("CmpItemKindUnit", "Purple")
  link("CmpItemKindValue", "Purple")
  link("CmpItemKindVariable", "Blue")

  -- Saghen/blink.cmp
  hl("BlinkCmpLabelMatch", { fg = p.green, bold = true })
  link("BlinkCmpKindArray", "Aqua")
  link("BlinkCmpKindBoolean", "Aqua")
  link("BlinkCmpKindClass", "Red")
  link("BlinkCmpKindColor", "Aqua")
  link("BlinkCmpKindConstant", "Blue")
  link("BlinkCmpKindConstructor", "Green")
  link("BlinkCmpKindDefault", "Aqua")
  link("BlinkCmpKindEnum", "Yellow")
  link("BlinkCmpKindEnumMember", "Purple")
  link("BlinkCmpKindEvent", "Orange")
  link("BlinkCmpKindField", "Green")
  link("BlinkCmpKindFile", "Green")
  link("BlinkCmpKindFolder", "Aqua")
  link("BlinkCmpKindFunction", "Green")
  link("BlinkCmpKindInterface", "Yellow")
  link("BlinkCmpKindKey", "Red")
  link("BlinkCmpKindKeyword", "Red")
  link("BlinkCmpKindMethod", "Green")
  link("BlinkCmpKindModule", "Purple")
  link("BlinkCmpKindNamespace", "Purple")
  link("BlinkCmpKindNull", "Aqua")
  link("BlinkCmpKindNumber", "Aqua")
  link("BlinkCmpKindObject", "Aqua")
  link("BlinkCmpKindOperator", "Orange")
  link("BlinkCmpKindPackage", "Purple")
  link("BlinkCmpKindProperty", "Blue")
  link("BlinkCmpKindReference", "Aqua")
  link("BlinkCmpKindSnippet", "Aqua")
  link("BlinkCmpKindString", "Aqua")
  link("BlinkCmpKindStruct", "Yellow")
  link("BlinkCmpKindText", "Fg")
  link("BlinkCmpKindTypeParameter", "Yellow")
  link("BlinkCmpKindUnit", "Purple")
  link("BlinkCmpKindValue", "Purple")
  link("BlinkCmpKindVariable", "Blue")

  -- SmiteshP/nvim-navic
  link("NavicText", "Fg")
  link("NavicSeparator", "Grey")
  link("NavicIconsArray", "Aqua")
  link("NavicIconsBoolean", "Aqua")
  link("NavicIconsClass", "Red")
  link("NavicIconsColor", "Aqua")
  link("NavicIconsConstant", "Blue")
  link("NavicIconsConstructor", "Green")
  link("NavicIconsDefault", "Aqua")
  link("NavicIconsEnum", "Yellow")
  link("NavicIconsEnumMember", "Purple")
  link("NavicIconsEvent", "Orange")
  link("NavicIconsField", "Green")
  link("NavicIconsFile", "Green")
  link("NavicIconsFolder", "Aqua")
  link("NavicIconsFunction", "Green")
  link("NavicIconsInterface", "Yellow")
  link("NavicIconsKey", "Red")
  link("NavicIconsKeyword", "Red")
  link("NavicIconsMethod", "Green")
  link("NavicIconsModule", "Purple")
  link("NavicIconsNamespace", "Purple")
  link("NavicIconsNull", "Aqua")
  link("NavicIconsNumber", "Aqua")
  link("NavicIconsObject", "Aqua")
  link("NavicIconsOperator", "Orange")
  link("NavicIconsPackage", "Purple")
  link("NavicIconsProperty", "Blue")
  link("NavicIconsReference", "Aqua")
  link("NavicIconsSnippet", "Aqua")
  link("NavicIconsString", "Aqua")
  link("NavicIconsStruct", "Yellow")
  link("NavicIconsText", "Fg")
  link("NavicIconsTypeParameter", "Yellow")
  link("NavicIconsUnit", "Purple")
  link("NavicIconsValue", "Purple")
  link("NavicIconsVariable", "Blue")

  -- folke/trouble.nvim
  link("TroubleText", "Fg")
  link("TroubleSource", "Grey")
  link("TroubleCode", "Grey")
  link("TroubleNormal", "Normal")
  link("TroubleNormalNC", "Normal")

  -- nvim-telescope/telescope.nvim
  hl("TelescopeMatching", { fg = p.green, bold = true })
  link("TelescopeBorder", "Grey")
  link("TelescopePromptPrefix", "Orange")
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

  -- lukas-reineke/indent-blankline.nvim
  hl("IblScope", { fg = p.grey1, nocombine = true })
  hl("IblIndent", { fg = p.bg5, nocombine = true })
  link("IndentBlanklineContextChar", "IblScope")
  link("IndentBlanklineChar", "IblIndent")
  link("IndentBlanklineSpaceChar", "IndentBlanklineChar")
  link("IndentBlanklineSpaceCharBlankline", "IndentBlanklineChar")

  -- nvim-neotest/neotest
  link("NeotestPassed", "GreenSign")
  link("NeotestFailed", "RedSign")
  link("NeotestRunning", "YellowSign")
  link("NeotestSkipped", "BlueSign")

  -- folke/which-key.nvim
  link("WhichKey", "Red")
  link("WhichKeySeperator", "Green")
  link("WhichKeyGroup", "Yellow")
  link("WhichKeyDesc", "Blue")

  -- nvim-tree/nvim-tree.lua
  link("NvimTreeNormal", "Normal")
  link("NvimTreeNormalNC", "Normal")
  link("NvimTreeEndOfBuffer", "Normal")
  hl("NvimTreeWinSeparator", { fg = p.grey0, bg = p.bg0 })
  link("NvimTreeSymlink", "Fg")
  link("NvimTreeFolderName", "Green")
  link("NvimTreeRootFolder", "Grey")
  link("NvimTreeFolderIcon", "Orange")
  link("NvimTreeEmptyFolderName", "Green")
  link("NvimTreeOpenedFolderName", "Green")
  link("NvimTreeExecFile", "Fg")
  link("NvimTreeOpenedHL", "Fg")
  link("NvimTreeSpecialFile", "Fg")
  link("NvimTreeImageFile", "Fg")
  link("NvimTreeIndentMarker", "Grey")
  link("NvimTreeGitDirtyIcon", "Yellow")
  link("NvimTreeGitStagedIcon", "Blue")
  link("NvimTreeGitMergeIcon", "Orange")
  link("NvimTreeGitRenamedIcon", "Purple")
  link("NvimTreeGitNewIcon", "Aqua")
  link("NvimTreeGitDeletedIcon", "Red")
  link("NvimTreeLspDiagnosticsError", "RedSign")
  link("NvimTreeLspDiagnosticsWarning", "YellowSign")
  link("NvimTreeLspDiagnosticsInformation", "BlueSign")
  link("NvimTreeLspDiagnosticsHint", "PurpleSign")

  -- HiPhish/rainbow-delimiters.nvim
  link("RainbowDelimiterRed", "Red")
  link("RainbowDelimiterOrange", "Orange")
  link("RainbowDelimiterYellow", "Yellow")
  link("RainbowDelimiterGreen", "Green")
  link("RainbowDelimiterCyan", "Aqua")
  link("RainbowDelimiterBlue", "Blue")
  link("RainbowDelimiterViolet", "Purple")

  -- diff
  link("diffAdded", "Green")
  link("diffRemoved", "Red")
  link("diffChanged", "Blue")
  link("diffFile", "Aqua")
  link("diffOldFile", "Orange")
  link("diffNewFile", "Yellow")
  link("diffIndexLine", "Purple")
  link("diffLine", "Grey")

  -- ==========================================================================
  -- Filetype-specific highlights
  -- ==========================================================================

  -- markdown
  hl("markdownH1", { fg = p.red, bold = true })
  hl("markdownH2", { fg = p.orange, bold = true })
  hl("markdownH3", { fg = p.yellow, bold = true })
  hl("markdownH4", { fg = p.green, bold = true })
  hl("markdownH5", { fg = p.blue, bold = true })
  hl("markdownH6", { fg = p.purple, bold = true })
  hl("markdownItalic", { italic = true })
  hl("markdownBold", { bold = true })
  hl("markdownItalicDelimiter", { fg = p.grey1, italic = true })
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
  link("luaFunc", "GreenBold")
  link("luaFunction", "Aqua")
  link("luaTable", "Fg")
  link("luaIn", "RedItalic")
  link("luaFuncCall", "GreenBold")
  link("luaLocal", "Orange")
  link("luaSpecialValue", "GreenBold")
  link("luaBraces", "Fg")
  link("luaBuiltIn", "Purple")
  link("luaNoise", "Grey")
  link("luaLabel", "Purple")
  link("luaFuncTable", "Yellow")
  link("luaFuncArgName", "Blue")
  link("luaEllipsis", "Orange")
  link("luaDocTag", "Green")
  link("luaTSConstructor", "luaBraces")
  link("@constructor.lua", "luaTSConstructor")

  -- go
  link("goPackage", "Define")
  link("goImport", "Include")
  link("goVar", "OrangeItalic")
  link("goConst", "goVar")
  link("goType", "Yellow")
  link("goSignedInts", "goType")
  link("goUnsignedInts", "goType")
  link("goFloats", "goType")
  link("goComplexes", "goType")
  link("goVarDefs", "Aqua")
  link("goDeclType", "OrangeItalic")
  link("goFunctionCall", "Function")
  link("goPredefinedIdentifiers", "Aqua")
  link("goBuiltins", "GreenBold")
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

  -- neotest (summary panel)
  link("NeotestNamespace", "Purple")
  link("NeotestFile", "Blue")
  link("NeotestDir", "Directory")
  link("NeotestIndent", "NonText")
  hl("NeotestExpandMarker", { fg = p.bg5 })
  link("NeotestAdapterName", "Red")
  link("NeotestMarked", "Orange")
  link("NeotestTarget", "Red")

  -- lazy.nvim
  link("LazyNormal", "Normal")
  hl("LazyH1", { fg = p.bg0, bg = p.red, bold = true })
  hl("LazyH2", { fg = p.orange, bold = true })
  hl("LazyButton", { fg = p.fg1, bg = p.bg_statusline3 })
  hl("LazyButtonActive", { fg = p.bg0, bg = p.grey2, bold = true })

  -- mason
  hl("MasonHeader", { fg = p.bg0, bg = p.red, bold = true })
  hl("MasonHeaderSecondary", { fg = p.bg0, bg = p.orange, bold = true })
  link("MasonHighlight", "Green")
  link("MasonHighlightSecondary", "Yellow")
  hl("MasonHighlightBlock", { fg = p.bg0, bg = p.orange })
  hl("MasonHighlightBlockBold", { fg = p.bg0, bg = p.orange, bold = true })
  hl("MasonHighlightBlockSecondary", { fg = p.bg0, bg = p.red })
  hl(
    "MasonHighlightBlockBoldSecondary",
    { fg = p.bg0, bg = p.red, bold = true }
  )
  hl("MasonMuted", { fg = p.grey0 })
  hl("MasonMutedBlock", { fg = p.bg0, bg = p.grey0 })
end

return M
