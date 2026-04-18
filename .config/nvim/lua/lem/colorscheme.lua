-- Custom colorscheme (no external dependency)
-- FIXME: This file requires thorough testing, adjusting highlights and colors as needed.
-- Currently it may not be fully polished and may have some inconsistencies or missing highlights.

local M = {}

-- Palette (matches color/schemes/gruvbox-dark-material.yaml)
M.palette = {
  base00 = "#282828",
  base01 = "#32302f",
  base02 = "#45403d",
  base03 = "#7c6f64",
  base04 = "#928374",
  base05 = "#d4be98",
  base06 = "#ddc7a1",
  base07 = "#ebdbb2",
  base08 = "#ea6962",
  base09 = "#e78a4e",
  base0A = "#d8a657",
  base0B = "#a9b665",
  base0C = "#89b482",
  base0D = "#7daea3",
  base0E = "#d3869b",
  base0F = "#a89984",
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
      fg = best_contrast_fg(
        M.palette.base07,
        M.palette.base00,
        M.palette.base05
      ),
    },
    b = { bg = M.palette.base02, fg = M.palette.base05 },
    c = { bg = M.palette.base02, fg = M.palette.base05 },
  },
  insert = {
    a = {
      bg = M.palette.base0B,
      fg = best_contrast_fg(
        M.palette.base0B,
        M.palette.base00,
        M.palette.base05
      ),
    },
    b = { bg = M.palette.base02, fg = M.palette.base05 },
    c = { bg = M.palette.base02, fg = M.palette.base05 },
  },
  visual = {
    a = {
      bg = M.palette.base0A,
      fg = best_contrast_fg(
        M.palette.base0A,
        M.palette.base00,
        M.palette.base05
      ),
    },
    b = { bg = M.palette.base02, fg = M.palette.base05 },
    c = { bg = M.palette.base02, fg = M.palette.base05 },
  },
  replace = {
    a = {
      bg = M.palette.base08,
      fg = best_contrast_fg(
        M.palette.base08,
        M.palette.base00,
        M.palette.base05
      ),
    },
    b = { bg = M.palette.base02, fg = M.palette.base05 },
    c = { bg = M.palette.base02, fg = M.palette.base05 },
  },
  command = {
    a = {
      bg = M.palette.base0D,
      fg = best_contrast_fg(
        M.palette.base0D,
        M.palette.base00,
        M.palette.base05
      ),
    },
    b = { bg = M.palette.base02, fg = M.palette.base05 },
    c = { bg = M.palette.base02, fg = M.palette.base05 },
  },
  terminal = {
    a = {
      bg = M.palette.base0E,
      fg = best_contrast_fg(
        M.palette.base0E,
        M.palette.base00,
        M.palette.base05
      ),
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

M.fzf_lua_colors = {
  ["fg"] = M.palette.base05,
  ["bg"] = M.palette.base00,
  ["hl"] = M.palette.base0B,
  ["fg+"] = M.palette.base05,
  ["bg+"] = M.palette.base01,
  ["hl+"] = M.palette.base0B,
  ["info"] = M.palette.base04,
  ["border"] = M.palette.base03,
  ["gutter"] = M.palette.base00,
  ["query"] = M.palette.base05,
  ["prompt"] = M.palette.base0A,
  ["pointer"] = M.palette.base0A,
  ["marker"] = M.palette.base0A,
  ["header"] = M.palette.base09,
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
  hl("Folded", { fg = p.base0D, bg = p.base01 })
  hl("ToolbarLine", { fg = p.base05, bg = p.base01 })
  hl("SignColumn", { fg = p.base03 })
  hl("FoldColumn", { fg = p.base03 })

  hl("IncSearch", { fg = p.base00, bg = p.base09 })
  hl("Search", { fg = p.base00, bg = p.base0A })
  hl("CurSearch", { fg = p.base00, bg = p.base0A })
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
  link("LineNrAbove", "LineNr")
  link("LineNrBelow", "LineNr")
  hl("CursorLineNr", { fg = p.base07 })
  link("CursorLineFold", "FoldColumn")
  link("CursorLineSign", "SignColumn")

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
  hl("PmenuMatch", { fg = p.base0A, bold = true })
  hl("PmenuMatchSel", { fg = p.base0A, bg = p.base02, bold = true })
  hl("PmenuKind", { fg = p.base0B, bg = p.base00 })
  hl("PmenuExtra", { fg = p.base06, bg = p.base00 })
  link("WildMenu", "PmenuSel")
  hl("PmenuThumb", { bg = p.base03 })

  -- Float: match the main editor background with a visible border
  hl("NormalFloat", { fg = p.base05, bg = p.base00 })
  hl("FloatBorder", { fg = p.base03, bg = p.base00 })
  hl("FloatTitle", { fg = p.base09, bg = p.base00 })
  link("FloatFooter", "FloatTitle")
  hl("FloatShadow", { bg = p.base00, blend = 30 })
  hl("FloatShadowThrough", { bg = p.base00, blend = 100 })

  hl("Question", { fg = p.base0A })
  hl("MsgArea", { fg = p.base05, bg = p.base00 })
  hl("MsgSeparator", { fg = p.base03, bg = p.base00 })

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
  hl("Boolean", { fg = p.base09 })
  hl("Number", { fg = p.base09 })
  hl("Float", { fg = p.base09 })
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
  hl("Function", { fg = p.base0D })
  hl("String", { fg = p.base0B })
  hl("Character", { fg = p.base0B })
  hl("Constant", { fg = p.base09 })
  hl("Macro", { fg = p.base0E })
  hl("Identifier", { fg = p.base08 })
  hl("Todo", { fg = p.base00, bg = p.base0D })
  hl("Comment", { fg = p.base03, italic = true })
  hl("SpecialComment", { fg = p.base03, italic = true })
  hl("Delimiter", { fg = p.base05 })
  hl("Ignore", { fg = p.base03 })
  hl("Underlined", { fg = p.base0D, underline = true })

  hl("TSCharacter", { fg = p.base0C })
  hl("TSMarkupLinkUrl", { fg = p.base0D, italic = true, underline = true })
  hl("TSMarkupListUnchecked", { fg = p.base03 })
  hl("TSStringEscape", { fg = p.base0E })
  hl("TSStringRegexp", { fg = p.base0E })
  hl("TSStringSpecialUrl", { fg = p.base0D })

  -- ==========================================================================
  -- Predefined highlight groups
  -- ==========================================================================
  hl("Fg", { fg = p.base05 })
  hl("Grey", { fg = p.base03 })
  hl("Red", { fg = p.base08 })
  hl("Orange", { fg = p.base09 })
  hl("Yellow", { fg = p.base0A })
  hl("Green", { fg = p.base0B })
  hl("Aqua", { fg = p.base0C })
  hl("Blue", { fg = p.base0D })
  hl("Purple", { fg = p.base0E })

  -- Italic variants (italic enabled)
  hl("RedItalic", { fg = p.base08, italic = true })
  hl("OrangeItalic", { fg = p.base09, italic = true })
  hl("YellowItalic", { fg = p.base0A, italic = true })
  hl("GreenItalic", { fg = p.base0B, italic = true })
  hl("AquaItalic", { fg = p.base0C, italic = true })
  hl("BlueItalic", { fg = p.base0D, italic = true })
  hl("PurpleItalic", { fg = p.base0E, italic = true })

  -- Bold variants (bold enabled)
  hl("RedBold", { fg = p.base08, bold = true })
  hl("OrangeBold", { fg = p.base09, bold = true })
  hl("YellowBold", { fg = p.base0A, bold = true })
  hl("GreenBold", { fg = p.base0B, bold = true })
  hl("AquaBold", { fg = p.base0C, bold = true })
  hl("BlueBold", { fg = p.base0D, bold = true })
  hl("PurpleBold", { fg = p.base0E, bold = true })

  -- Sign variants (sign_column_background=none)
  hl("RedSign", { fg = p.base08 })
  hl("OrangeSign", { fg = p.base09 })
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
  hl("SnippetTabstop", { bg = p.base01 })
  hl("SnippetTabstopActive", { bg = p.base02 })

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
  hl("@comment.error", { fg = p.base00, bg = p.base08 })
  hl("@comment.note", { fg = p.base07, bg = p.base0E })
  hl("@comment.warning", { fg = p.base00, bg = p.base0A })
  hl("@comment.hint", { fg = p.base00, bg = p.base0D })
  hl("@markup.italic", { italic = true })
  link("@markup.link.url", "TSMarkupLinkUrl")
  hl("@markup.strong", { bold = true })
  hl("@markup.underline", { underline = true })

  -- Neovim 0.12 treesitter captures
  link("@annotation", "Orange")
  link("@attribute", "Aqua")
  link("@attribute.builtin", "@attribute")
  link("@boolean", "Orange")
  link("@character", "Green")
  link("@character.special", "SpecialChar")
  link("@comment", "Comment")
  link("@comment.todo", "Todo")
  link("@conceal", "Grey")
  link("@conditional", "PurpleItalic")
  link("@constant", "Orange")
  link("@constant.builtin", "Orange")
  link("@constant.macro", "PurpleItalic")
  link("@constructor", "Blue")
  link("@diff.delta", "diffChanged")
  link("@diff.minus", "diffRemoved")
  link("@diff.plus", "diffAdded")
  link("@error", "Error")
  link("@exception", "PurpleItalic")
  link("@field", "Blue")
  link("@float", "Orange")
  link("@function", "Blue")
  link("@function.builtin", "Blue")
  link("@function.call", "Blue")
  link("@function.macro", "Purple")
  link("@function.method", "Blue")
  link("@function.method.call", "Blue")
  link("@include", "PurpleItalic")
  link("@keyword", "PurpleItalic")
  link("@keyword.conditional", "PurpleItalic")
  link("@keyword.debug", "Debug")
  link("@keyword.directive", "PreProc")
  link("@keyword.directive.define", "Define")
  link("@keyword.exception", "PurpleItalic")
  link("@keyword.function", "PurpleItalic")
  link("@keyword.import", "PurpleItalic")
  link("@keyword.operator", "Yellow")
  link("@keyword.repeat", "PurpleItalic")
  link("@keyword.return", "PurpleItalic")
  link("@keyword.storage", "Yellow")
  link("@label", "Yellow")
  link("@markup.environment", "Macro")
  link("@markup.environment.name", "Type")
  link("@markup.heading", "Title")
  link("@markup.link", "Constant")
  link("@markup.link.label", "SpecialChar")
  link("@markup.list", "Blue")
  link("@markup.list.checked", "Green")
  link("@markup.list.unchecked", "Ignore")
  link("@markup.math", "Blue")
  link("@markup.note", "@comment.note")
  link("@markup.quote", "Grey")
  link("@markup.raw", "String")
  link("@markup.strike", "Grey")
  link("@math", "Blue")
  link("@method", "Blue")
  link("@method.call", "Blue")
  link("@module", "YellowItalic")
  link("@namespace", "YellowItalic")
  link("@none", "Fg")
  link("@number", "Orange")
  link("@number.float", "Orange")
  link("@operator", "Yellow")
  link("@parameter", "Fg")
  link("@parameter.reference", "Fg")
  link("@preproc", "PreProc")
  link("@property", "Blue")
  link("@punctuation.bracket", "Fg")
  link("@punctuation.delimiter", "Grey")
  link("@punctuation.special", "Blue")
  link("@repeat", "PurpleItalic")
  link("@storageclass", "Yellow")
  link("@storageclass.lifetime", "Yellow")
  link("@strike", "Grey")
  link("@string", "Green")
  link("@string.escape", "Aqua")
  link("@string.regex", "Aqua")
  link("@string.regexp", "Aqua")
  link("@string.special", "SpecialChar")
  link("@string.special.symbol", "Fg")
  link("@string.special.url", "@markup.link.url")
  link("@string.special.uri", "@markup.link.url")
  link("@symbol", "Fg")
  link("@tag", "Red")
  link("@tag.attribute", "Yellow")
  link("@tag.builtin", "@tag")
  link("@tag.delimiter", "Red")
  link("@text", "Green")
  link("@text.diff.add", "diffAdded")
  link("@text.diff.delete", "diffRemoved")
  link("@text.environment", "Macro")
  link("@text.environment.name", "Type")
  link("@text.literal", "String")
  link("@text.math", "Blue")
  link("@text.reference", "Constant")
  link("@text.strike", "Grey")
  link("@text.title", "Title")
  link("@text.todo", "Todo")
  link("@text.todo.checked", "Green")
  link("@text.todo.unchecked", "Ignore")
  link("@type", "YellowItalic")
  link("@type.builtin", "YellowItalic")
  link("@type.definition", "YellowItalic")
  link("@type.qualifier", "Yellow")
  link("@variable", "Fg")
  link("@variable.builtin", "PurpleItalic")
  link("@variable.member", "Blue")
  link("@variable.parameter", "Fg")

  hl("DiagnosticUnnecessary", { fg = p.base03 })
  hl("DiagnosticDeprecated", { strikethrough = true, sp = p.base05 })
  link("@lsp.mod.deprecated", "DiagnosticDeprecated")

  -- ==========================================================================
  -- Plugin highlights
  -- ==========================================================================

  -- copilot.lua
  link("CopilotSuggestion", "Grey")

  -- hrsh7th/nvim-cmp
  hl("CmpItemAbbrMatch", { fg = p.base0B, bold = true })
  hl("CmpItemAbbrMatchFuzzy", { fg = p.base0B, bold = true })
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
  link("NvimTreeOpenedFile", "Fg")
  hl("NvimTreeStatuslineNc", { fg = p.base01, bg = p.base01 })
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
  hl("MasonHeader", { fg = p.base00, bg = p.base0D, bold = true })
  hl("MasonHeaderSecondary", { fg = p.base00, bg = p.base0E, bold = true })
  link("MasonHighlight", "Green")
  link("MasonHighlightSecondary", "Purple")
  hl("MasonHighlightBlock", { fg = p.base00, bg = p.base0B })
  hl("MasonHighlightBlockBold", { fg = p.base00, bg = p.base0B, bold = true })
  hl("MasonHighlightBlockSecondary", { fg = p.base00, bg = p.base0D })
  hl(
    "MasonHighlightBlockBoldSecondary",
    { fg = p.base00, bg = p.base0E, bold = true }
  )
  hl("MasonMuted", { fg = p.base03 })
  hl("MasonMutedBlock", { fg = p.base00, bg = p.base03 })
end

return M
