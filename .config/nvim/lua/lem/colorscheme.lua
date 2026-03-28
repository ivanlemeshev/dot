-- Custom colorscheme (no external dependency)

local M = {}

-- Palette (matches color/schemes/base16-default-dark.yaml)
M.palette = {
  bg = "#181818",
  fg = "#d8d8d8",
  black = "#282828",
  red = "#ab4642",
  green = "#a1b56c",
  yellow = "#f7ca88",
  blue = "#7cafc2",
  magenta = "#ba8baf",
  cyan = "#86c1b9",
  white = "#e8e8e8",
  bright_black = "#585858",
  bright_red = "#ab4642",
  bright_green = "#a1b56c",
  bright_yellow = "#f7ca88",
  bright_blue = "#7cafc2",
  bright_magenta = "#ba8baf",
  bright_cyan = "#86c1b9",
  bright_white = "#f8f8f8",
}

M.lualine_theme = {
  normal = {
    a = { bg = M.palette.bright_white, fg = M.palette.bg },
    b = { bg = M.palette.black, fg = M.palette.fg },
    c = { bg = M.palette.black, fg = M.palette.fg },
  },
  insert = {
    a = { bg = M.palette.green, fg = M.palette.bg },
    b = { bg = M.palette.black, fg = M.palette.fg },
    c = { bg = M.palette.black, fg = M.palette.fg },
  },
  visual = {
    a = { bg = M.palette.bright_yellow, fg = M.palette.bg },
    b = { bg = M.palette.black, fg = M.palette.fg },
    c = { bg = M.palette.black, fg = M.palette.fg },
  },
  replace = {
    a = { bg = M.palette.red, fg = M.palette.bg },
    b = { bg = M.palette.black, fg = M.palette.fg },
    c = { bg = M.palette.black, fg = M.palette.fg },
  },
  command = {
    a = { bg = M.palette.blue, fg = M.palette.bg },
    b = { bg = M.palette.black, fg = M.palette.fg },
    c = { bg = M.palette.black, fg = M.palette.fg },
  },
  terminal = {
    a = { bg = M.palette.magenta, fg = M.palette.bg },
    b = { bg = M.palette.black, fg = M.palette.fg },
    c = { bg = M.palette.black, fg = M.palette.fg },
  },
  inactive = {
    a = { bg = M.palette.black, fg = M.palette.bright_black },
    b = { bg = M.palette.black, fg = M.palette.fg },
    c = { bg = M.palette.black, fg = M.palette.fg },
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
  hl("Normal", { fg = p.fg, bg = p.bg })
  hl("NormalNC", { fg = p.fg, bg = p.bg })
  hl("Terminal", { fg = p.fg, bg = p.bg })
  hl("EndOfBuffer", { fg = p.bg, bg = p.bg })
  hl("Folded", { fg = p.white, bg = p.black })
  hl("ToolbarLine", { fg = p.fg, bg = p.black })
  hl("SignColumn", { fg = p.fg })
  hl("FoldColumn", { fg = p.bright_black })

  hl("IncSearch", { fg = p.bg, bg = p.bright_red })
  hl("Search", { fg = p.bg, bg = p.bright_green })
  link("CurSearch", "IncSearch")
  hl("ColorColumn", { bg = p.black })
  hl("Conceal", { fg = p.black })

  hl("Cursor", { reverse = true })
  link("vCursor", "Cursor")
  link("iCursor", "Cursor")
  link("lCursor", "Cursor")
  link("CursorIM", "Cursor")

  hl("CursorLine", { bg = p.black })
  hl("CursorColumn", { bg = p.black })

  -- LineNr: ui_contrast=low, sign_column_background=none
  hl("LineNr", { fg = p.bright_black })
  hl("CursorLineNr", { fg = p.bright_white })

  hl("DiffAdd", { fg = p.green, bg = p.black })
  hl("DiffChange", { fg = p.white, bg = p.black })
  hl("DiffDelete", { fg = p.red, bg = p.black })
  hl("DiffText", { fg = p.bg, bg = p.white })

  hl("Directory", { fg = p.green })
  hl("ErrorMsg", { fg = p.bright_red, underline = true })
  hl("WarningMsg", { fg = p.bright_yellow })
  hl("ModeMsg", { fg = p.fg })
  hl("MoreMsg", { fg = p.bright_yellow })
  hl("MatchParen", { bg = p.bright_black })
  hl("NonText", { fg = p.black })
  hl("Whitespace", { fg = p.black })
  hl("SpecialKey", { fg = p.black })

  -- Pmenu: menu_selection_background=grey
  hl("Pmenu", { fg = p.fg, bg = p.bg })
  hl("PmenuSbar", { bg = p.bg })
  hl("PmenuSel", { fg = p.bg, bg = p.white })
  hl("PmenuKind", { fg = p.green, bg = p.bg })
  hl("PmenuExtra", { fg = p.white, bg = p.bg })
  link("WildMenu", "PmenuSel")
  hl("PmenuThumb", { bg = p.bright_black })

  -- Float: match the main editor background with a visible border
  hl("NormalFloat", { fg = p.fg, bg = p.bg })
  hl("FloatBorder", { fg = p.bright_black, bg = p.bg })
  hl("FloatTitle", { fg = p.bright_yellow, bg = p.bg })

  hl("Question", { fg = p.bright_yellow })

  -- Spell
  hl("SpellBad", { undercurl = true, sp = p.bright_red })
  hl("SpellCap", { undercurl = true, sp = p.bright_blue })
  hl("SpellLocal", { undercurl = true, sp = p.bright_cyan })
  hl("SpellRare", { undercurl = true, sp = p.bright_magenta })

  -- StatusLine: default style, transparent_background=0
  hl("StatusLine", { fg = p.bright_white, bg = p.black })
  hl("StatusLineTerm", { fg = p.bright_white, bg = p.black })
  hl("StatusLineNC", { fg = p.white, bg = p.black })
  hl("StatusLineTermNC", { fg = p.white, bg = p.black })
  hl("LualineSeparator", { fg = p.fg, bg = p.black })
  hl("TabLine", { fg = p.white, bg = p.black })
  hl("TabLineFill", { fg = p.white, bg = p.black })
  hl("TabLineSel", { fg = p.bg, bg = p.bright_white })
  hl("WinBar", { fg = p.fg, bg = p.bg })
  hl("WinBarNC", { fg = p.white, bg = p.bg })

  -- VertSplit / WinSeparator: match tmux separator color.
  hl("VertSplit", { fg = p.bright_black })
  link("WinSeparator", "VertSplit")

  -- Visual: grey background
  hl("Visual", { fg = p.bg, bg = p.white })
  hl("VisualNOS", { fg = p.bg, bg = p.white })

  hl("QuickFixLine", { fg = p.bright_magenta })
  hl("Debug", { fg = p.bright_yellow })
  hl("debugPC", { fg = p.bg, bg = p.green })
  hl("debugBreakpoint", { fg = p.bg, bg = p.red })
  hl("ToolbarButton", { fg = p.bg, bg = p.white })
  hl("Substitute", { fg = p.bg, bg = p.yellow })

  -- Diagnostics: diagnostic_text_highlight=0
  hl("DiagnosticError", { fg = p.bright_red })
  hl("DiagnosticWarn", { fg = p.bright_yellow })
  hl("DiagnosticInfo", { fg = p.bright_blue })
  hl("DiagnosticHint", { fg = p.bright_magenta })
  hl("DiagnosticOk", { fg = p.green })
  hl("DiagnosticUnderlineError", { undercurl = true, sp = p.bright_red })
  hl("DiagnosticUnderlineWarn", { undercurl = true, sp = p.bright_yellow })
  hl("DiagnosticUnderlineInfo", { undercurl = true, sp = p.bright_blue })
  hl("DiagnosticUnderlineHint", { undercurl = true, sp = p.bright_magenta })
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
  hl("Boolean", { fg = p.bright_magenta })
  hl("Number", { fg = p.bright_magenta })
  hl("Float", { fg = p.bright_magenta })

  -- italic enabled
  hl("PreProc", { fg = p.magenta, italic = true })
  hl("PreCondit", { fg = p.magenta, italic = true })
  hl("Include", { fg = p.magenta, italic = true })
  hl("Define", { fg = p.magenta, italic = true })
  hl("Conditional", { fg = p.red, italic = true })
  hl("Repeat", { fg = p.red, italic = true })
  hl("Keyword", { fg = p.red, italic = true })
  hl("Typedef", { fg = p.red, italic = true })
  hl("Exception", { fg = p.red, italic = true })
  hl("Statement", { fg = p.red, italic = true })

  hl("Error", { fg = p.red })
  hl("StorageClass", { fg = p.yellow })
  hl("Tag", { fg = p.yellow })
  hl("Label", { fg = p.yellow })
  hl("Structure", { fg = p.yellow })
  hl("Operator", { fg = p.yellow })
  hl("Title", { fg = p.bright_yellow })
  hl("Special", { fg = p.yellow })
  hl("SpecialChar", { fg = p.bright_cyan })
  hl("Type", { fg = p.yellow })

  -- bold enabled
  hl("Function", { fg = p.bright_green })

  hl("String", { fg = p.green })
  hl("Character", { fg = p.green })
  hl("Constant", { fg = p.bright_cyan })
  hl("Macro", { fg = p.bright_cyan })
  hl("Identifier", { fg = p.blue })

  hl("Todo", { fg = p.bg, bg = p.bright_blue })

  -- italic comments (disable_italic_comment=false)
  hl("Comment", { fg = p.bright_black, italic = true })
  hl("SpecialComment", { fg = p.bright_black, italic = true })

  hl("Delimiter", { fg = p.fg })
  hl("Ignore", { fg = p.bright_black })
  hl("Underlined", { underline = true })

  -- ==========================================================================
  -- Predefined highlight groups
  -- ==========================================================================
  hl("Fg", { fg = p.fg })
  hl("Grey", { fg = p.bright_black })
  hl("Red", { fg = p.red })
  hl("Yellow", { fg = p.yellow })
  hl("Green", { fg = p.green })
  hl("Aqua", { fg = p.cyan })
  hl("Blue", { fg = p.blue })
  hl("Purple", { fg = p.magenta })

  -- Italic variants (italic enabled)
  hl("RedItalic", { fg = p.red, italic = true })
  hl("YellowItalic", { fg = p.yellow, italic = true })
  hl("GreenItalic", { fg = p.green, italic = true })
  hl("AquaItalic", { fg = p.cyan, italic = true })
  hl("BlueItalic", { fg = p.blue, italic = true })
  hl("PurpleItalic", { fg = p.magenta, italic = true })

  -- Bold variants (bold enabled)
  hl("RedBold", { fg = p.red, bold = true })
  hl("YellowBold", { fg = p.yellow, bold = true })
  hl("GreenBold", { fg = p.green, bold = true })
  hl("AquaBold", { fg = p.cyan, bold = true })
  hl("BlueBold", { fg = p.blue, bold = true })
  hl("PurpleBold", { fg = p.magenta, bold = true })

  -- Sign variants (sign_column_background=none)
  hl("RedSign", { fg = p.red })
  hl("YellowSign", { fg = p.yellow })
  hl("GreenSign", { fg = p.green })
  hl("AquaSign", { fg = p.cyan })
  hl("BlueSign", { fg = p.blue })
  hl("PurpleSign", { fg = p.magenta })

  link("Added", "Green")
  link("Removed", "Red")
  link("Changed", "Blue")

  -- ==========================================================================
  -- Error/Warning/Info/Hint text and lines
  -- ==========================================================================
  -- diagnostic_text_highlight=0
  hl("ErrorText", { undercurl = true, sp = p.bright_red })
  hl("WarningText", { undercurl = true, sp = p.bright_yellow })
  hl("InfoText", { undercurl = true, sp = p.bright_blue })
  hl("HintText", { undercurl = true, sp = p.bright_magenta })

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

  hl("ErrorFloat", { fg = p.bright_red })
  hl("WarningFloat", { fg = p.bright_yellow })
  hl("InfoFloat", { fg = p.bright_blue })
  hl("HintFloat", { fg = p.bright_magenta })
  hl("OkFloat", { fg = p.green })

  -- CurrentWord: current_word default = "grey background"
  hl("CurrentWord", { fg = p.bg, bg = p.white })

  -- InlayHints: inlay_hints_background=none
  link("InlayHints", "LineNr")

  -- ==========================================================================
  -- Terminal colors
  -- ==========================================================================
  vim.g.terminal_color_0 = p.black
  vim.g.terminal_color_1 = p.red
  vim.g.terminal_color_2 = p.green
  vim.g.terminal_color_3 = p.yellow
  vim.g.terminal_color_4 = p.blue
  vim.g.terminal_color_5 = p.magenta
  vim.g.terminal_color_6 = p.cyan
  vim.g.terminal_color_7 = p.white
  vim.g.terminal_color_8 = p.bright_black
  vim.g.terminal_color_9 = p.bright_red
  vim.g.terminal_color_10 = p.bright_green
  vim.g.terminal_color_11 = p.bright_yellow
  vim.g.terminal_color_12 = p.bright_blue
  vim.g.terminal_color_13 = p.bright_magenta
  vim.g.terminal_color_14 = p.bright_cyan
  vim.g.terminal_color_15 = p.bright_white

  -- ==========================================================================
  -- Treesitter highlights
  -- ==========================================================================
  hl("TSStrong", {})
  hl("TSEmphasis", { italic = true })
  hl("TSUnderline", { underline = true })
  hl("TSNote", { fg = p.bright_white, bg = p.magenta })
  hl("TSWarning", { fg = p.bg, bg = p.yellow })
  hl("TSDanger", { fg = p.bg, bg = p.red })

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
  link("TSConstructor", "Green")
  link("TSDebug", "Debug")
  link("TSDefine", "Define")
  link("TSEnvironment", "Macro")
  link("TSEnvironmentName", "Type")
  link("TSError", "Error")
  link("TSException", "Red")
  link("TSField", "Blue")
  link("TSFloat", "Purple")
  link("TSFuncBuiltin", "Green")
  link("TSFuncMacro", "Green")
  link("TSFunction", "Green")
  link("TSFunctionCall", "Green")
  link("TSInclude", "Red")
  link("TSKeyword", "Red")
  link("TSKeywordFunction", "Red")
  link("TSKeywordOperator", "Yellow")
  link("TSKeywordReturn", "Red")
  link("TSLabel", "Yellow")
  link("TSLiteral", "String")
  link("TSMath", "Blue")
  link("TSMethod", "Green")
  link("TSMethodCall", "Green")
  link("TSNamespace", "YellowItalic")
  link("TSNone", "Fg")
  link("TSNumber", "Purple")
  link("TSOperator", "Yellow")
  link("TSParameter", "Fg")
  link("TSParameterReference", "Fg")
  link("TSPreProc", "PreProc")
  link("TSProperty", "Blue")
  link("TSPunctBracket", "Fg")
  link("TSPunctDelimiter", "Grey")
  link("TSPunctSpecial", "Blue")
  link("TSRepeat", "Red")
  link("TSStorageClass", "Yellow")
  link("TSStorageClassLifetime", "Yellow")
  link("TSStrike", "Grey")
  link("TSString", "Aqua")
  link("TSStringEscape", "Green")
  link("TSStringRegex", "Green")
  link("TSStringSpecial", "SpecialChar")
  link("TSSymbol", "Fg")
  link("TSTag", "Yellow")
  link("TSTagAttribute", "Green")
  link("TSTagDelimiter", "Green")
  link("TSText", "Green")
  link("TSTextReference", "Constant")
  link("TSTitle", "Title")
  link("TSTodo", "Todo")
  link("TSType", "YellowItalic")
  link("TSTypeBuiltin", "YellowItalic")
  link("TSTypeDefinition", "YellowItalic")
  link("TSTypeQualifier", "Yellow")
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

  hl("DiagnosticUnnecessary", { fg = p.bright_black })
  hl("DiagnosticDeprecated", { strikethrough = true, sp = p.fg })

  link("TSModuleInfoGood", "Green")
  link("TSModuleInfoBad", "Red")

  -- ==========================================================================
  -- Plugin highlights
  -- ==========================================================================

  -- nvim-treesitter-context
  hl("TreesitterContext", { fg = p.fg, bg = p.bg })

  -- github/copilot.vim
  link("CopilotSuggestion", "Grey")

  -- hrsh7th/nvim-cmp
  hl("CmpItemAbbrMatch", { fg = p.green })
  hl("CmpItemAbbrMatchFuzzy", { fg = p.green })
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
  link("CmpItemKindEvent", "Yellow")
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
  link("CmpItemKindOperator", "Yellow")
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

  -- folke/trouble.nvim
  link("TroubleText", "Fg")
  link("TroubleSource", "Grey")
  link("TroubleCode", "Grey")
  link("TroubleNormal", "Normal")
  link("TroubleNormalNC", "Normal")

  -- nvim-telescope/telescope.nvim
  hl("TelescopeMatching", { fg = p.green })
  hl("TelescopeBorder", { fg = p.bright_black })
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
  hl("DiffviewDiffChange", { fg = p.white, bg = p.black })
  hl("DiffviewDiffText", { fg = p.bg, bg = p.white })
  link("DiffviewStatusModified", "Green")
  link("DiffviewStatusRenamed", "Green")
  link("DiffviewStatusCopied", "Green")
  link("DiffviewStatusTypeChange", "Green")
  link("DiffviewStatusUnmerged", "Green")

  -- lukas-reineke/indent-blankline.nvim
  hl("IblScope", { fg = p.bright_black, nocombine = true })
  hl("IblIndent", { fg = p.black, nocombine = true })
  link("IndentBlanklineContextChar", "IblScope")
  link("IndentBlanklineChar", "IblIndent")
  link("IndentBlanklineSpaceChar", "IndentBlanklineChar")
  link("IndentBlanklineSpaceCharBlankline", "IndentBlanklineChar")

  -- folke/which-key.nvim
  link("WhichKey", "Red")
  link("WhichKeySeperator", "Green")
  link("WhichKeyGroup", "Yellow")
  link("WhichKeyDesc", "Blue")

  -- lem.terminal backdrop
  hl("TerminalBackdrop", { bg = p.bg })

  -- nvim-tree/nvim-tree.lua
  link("NvimTreeNormal", "Normal")
  link("NvimTreeNormalNC", "Normal")
  link("NvimTreeEndOfBuffer", "Normal")
  hl("NvimTreeWinSeparator", { fg = p.bright_black, bg = p.bg })
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

  -- pwntester/octo.nvim
  hl("OctoGreen", { fg = p.green })
  hl("OctoBlue", { fg = p.blue })
  hl("OctoYellow", { fg = p.yellow })
  hl("OctoRed", { fg = p.red })
  hl("OctoPurple", { fg = p.magenta })
  hl("OctoGrey", { fg = p.bright_black })
  hl("OctoViewer", { fg = p.white })
  hl("OctoBubble", { fg = p.fg, bg = p.bg })
  hl("OctoBubbleGreen", { fg = p.green, bg = p.bright_black })
  hl("OctoBubbleRed", { fg = p.red, bg = p.bright_black })
  hl("OctoBubblePurple", { fg = p.magenta, bg = p.bright_black })
  hl("OctoBubbleYellow", { fg = p.yellow, bg = p.bright_black })
  hl("OctoBubbleBlue", { fg = p.blue, bg = p.bright_black })
  hl("OctoGreenFloat", { fg = p.green, bg = p.bg })
  hl("OctoRedFloat", { fg = p.red, bg = p.bg })
  hl("OctoPurpleFloat", { fg = p.magenta, bg = p.bg })
  hl("OctoGreyFloat", { fg = p.bright_black, bg = p.bg })

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
  hl("markdownH1", { fg = p.red })
  hl("markdownH2", { fg = p.bright_yellow })
  hl("markdownH3", { fg = p.yellow })
  hl("markdownH4", { fg = p.green })
  hl("markdownH5", { fg = p.blue })
  hl("markdownH6", { fg = p.magenta })
  hl("markdownItalic", { italic = true })
  hl("markdownBold", { bold = true })
  hl("markdownItalicDelimiter", { fg = p.bright_black, italic = true })
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
  hl("LazyH1", { fg = p.bg, bg = p.red })
  hl("LazyH2", { fg = p.yellow })
  hl("LazyButton", { fg = p.fg, bg = p.bg })
  hl("LazyButtonActive", { fg = p.bg, bg = p.white })
  hl("LazyProp", { fg = p.bright_black })
  hl("LazyCommit", { fg = p.cyan })

  -- mason
  hl("MasonHeader", { fg = p.bg, bg = p.red })
  hl("MasonHeaderSecondary", { fg = p.bg, bg = p.yellow })
  link("MasonHighlight", "Green")
  link("MasonHighlightSecondary", "Yellow")
  hl("MasonHighlightBlock", { fg = p.bg, bg = p.yellow })
  hl("MasonHighlightBlockBold", { fg = p.bg, bg = p.yellow, bold = true })
  hl("MasonHighlightBlockSecondary", { fg = p.bg, bg = p.red })
  hl("MasonHighlightBlockBoldSecondary", { fg = p.bg, bg = p.red, bold = true })
  hl("MasonMuted", { fg = p.bright_black })
  hl("MasonMutedBlock", { fg = p.bg, bg = p.bright_black })
end

return M
