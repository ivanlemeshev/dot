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
  true,
  ["fg"] = { "fg", "Normal" },
  ["bg"] = { "bg", "Normal" },
  ["hl"] = { "fg", "Comment" },
  ["fg+"] = { "fg", "Normal" },
  ["bg+"] = { "bg", { "CursorLine", "Normal" } },
  ["hl+"] = { "fg", "Statement" },
  ["info"] = { "fg", "PreProc" },
  ["query"] = { "fg", "Normal" },
  ["prompt"] = { "fg", "Conditional" },
  ["pointer"] = { "fg", "Exception" },
  ["marker"] = { "fg", "Keyword" },
  ["spinner"] = { "fg", "Label" },
  ["header"] = { "fg", "Comment" },
  ["gutter"] = "-1",
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
  hl("Boolean", { fg = p.base0E })
  hl("Number", { fg = p.base0E })
  hl("Float", { fg = p.base0E })

  -- syntax groups
  hl("PreProc", { fg = p.base0E })
  hl("PreCondit", { fg = p.base0E })
  hl("Include", { fg = p.base0E })
  hl("Define", { fg = p.base0E })
  hl("Conditional", { fg = p.base08 })
  hl("Repeat", { fg = p.base08 })
  hl("Keyword", { fg = p.base08 })
  hl("Typedef", { fg = p.base08 })
  hl("Exception", { fg = p.base08 })
  hl("Statement", { fg = p.base08 })

  hl("Error", { fg = p.base08 })
  hl("StorageClass", { fg = p.base09 })
  hl("Tag", { fg = p.base09 })
  hl("Label", { fg = p.base09 })
  hl("Structure", { fg = p.base09 })
  hl("Operator", { fg = p.base09 })
  hl("Title", { fg = p.base09, bold = true })
  hl("Special", { fg = p.base0A })
  hl("SpecialChar", { fg = p.base0A })
  hl("Type", { fg = p.base0A })

  -- bold enabled
  hl("Function", { fg = p.base0B })

  hl("String", { fg = p.base0C })
  hl("Character", { fg = p.base0B })
  hl("Constant", { fg = p.base0C })
  hl("Macro", { fg = p.base0C })
  hl("Identifier", { fg = p.base0D })

  hl("Todo", { fg = p.base00, bg = p.base0D })

  -- italic comments (disable_italic_comment=false)
  hl("Comment", { fg = p.base03, italic = true })
  hl("SpecialComment", { fg = p.base03, italic = true })

  hl("Delimiter", { fg = p.base05 })
  hl("Ignore", { fg = p.base03 })
  hl("Underlined", { fg = p.base0D, underline = true })
  hl("TSCharacter", { fg = p.base0C })
  hl("TSMarkupLinkUrl", { fg = p.base0D, italic = true, underline = true })
  hl("TSMarkupListUnchecked", { fg = p.base08 })
  hl("TSStringEscape", { fg = p.base0A })
  hl("TSStringRegexp", { fg = p.base0B })
  hl("TSStringSpecialUrl", { fg = p.base0A })

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
  hl("@markup.italic", { italic = true })
  link("@markup.link.url", "TSMarkupLinkUrl")
  hl("@markup.strong", { bold = true })
  hl("@markup.underline", { underline = true })

  -- Neovim 0.12 treesitter captures
  link("@attribute", "Purple")
  link("@attribute.builtin", "@attribute")
  link("@boolean", "Boolean")
  link("@character", "TSCharacter")
  link("@character.special", "TSCharacter")
  link("@comment", "Comment")
  link("@comment.documentation", "Comment")
  link("@comment.todo", "Todo")
  link("@conceal", "Grey")
  link("@constant", "Constant")
  link("@constant.builtin", "Yellow")
  link("@constant.macro", "Blue")
  link("@constructor", "Function")
  link("@diff.delta", "diffChanged")
  link("@diff.minus", "diffRemoved")
  link("@diff.plus", "diffAdded")
  link("@function", "Function")
  link("@function.builtin", "Yellow")
  link("@function.call", "@function")
  link("@function.macro", "Macro")
  link("@function.method", "Function")
  link("@function.method.call", "@method")
  link("@method", "Function")
  link("@keyword", "Keyword")
  link("@keyword.conditional", "@keyword")
  link("@keyword.conditional.ternary", "@keyword.conditional")
  link("@keyword.coroutine", "@keyword")
  link("@keyword.debug", "@keyword")
  link("@keyword.directive", "Red")
  link("@keyword.directive.define", "@keyword.directive")
  link("@keyword.exception", "@keyword")
  link("@keyword.function", "@keyword")
  link("@keyword.import", "@keyword")
  link("@keyword.modifier", "@keyword")
  link("@keyword.operator", "@keyword")
  link("@keyword.repeat", "@keyword")
  link("@keyword.return", "@keyword")
  link("@keyword.type", "@keyword")
  link("@label", "Label")
  link("@markup", "Green")
  link("@markup.heading", "Title")
  link("@markup.heading.1", "Title")
  link("@markup.heading.2", "Title")
  link("@markup.heading.3", "Title")
  link("@markup.heading.4", "Title")
  link("@markup.heading.5", "Title")
  link("@markup.heading.6", "Title")
  link("@markup.link", "Blue")
  link("@markup.link.label", "@markup.link")
  link("@markup.list", "Orange")
  link("@markup.list.checked", "Green")
  link("@markup.list.unchecked", "TSMarkupListUnchecked")
  link("@markup.math", "Blue")
  link("@markup.quote", "Grey")
  link("@markup.raw", "Purple")
  link("@markup.raw.block", "@markup.raw")
  link("@markup.strikethrough", "Grey")
  link("@module", "Blue")
  link("@module.builtin", "@module")
  link("@number", "Number")
  link("@number.float", "@number")
  link("@operator", "Operator")
  link("@property", "Green")
  link("@punctuation", "Fg")
  link("@punctuation.bracket", "Fg")
  link("@punctuation.delimiter", "Grey")
  link("@punctuation.special", "Blue")
  link("@string", "String")
  link("@string.documentation", "Comment")
  link("@string.escape", "TSStringEscape")
  link("@string.regexp", "TSStringRegexp")
  link("@string.special", "SpecialChar")
  link("@string.special.path", "@string")
  link("@string.special.symbol", "@string")
  link("@string.special.url", "TSStringSpecialUrl")
  link("@tag", "Tag")
  link("@tag.attribute", "@tag")
  link("@tag.builtin", "@tag")
  link("@tag.delimiter", "Green")
  link("@type", "Type")
  link("@type.builtin", "@type")
  link("@type.definition", "@type")
  link("@variable", "Identifier")
  link("@variable.builtin", "@variable")
  link("@variable.member", "@variable")
  link("@variable.parameter", "@variable")
  link("@variable.parameter.builtin", "@variable.builtin")

  hl("DiagnosticUnnecessary", { fg = p.base03 })
  hl("DiagnosticDeprecated", { strikethrough = true, sp = p.base05 })
  link("@lsp.mod.deprecated", "DiagnosticDeprecated")

  -- ==========================================================================
  -- Plugin highlights
  -- ==========================================================================

  -- copilot.lua
  link("CopilotSuggestion", "Grey")

  -- hrsh7th/nvim-cmp
  hl("CmpItemAbbrMatch", { fg = p.base0B })
  hl("CmpItemAbbrMatchFuzzy", { fg = p.base0B })
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
    -- Main window
    FzfLuaNormal = "NormalFloat",
    FzfLuaBorder = "FloatBorder",
    FzfLuaTitle = "Title",
    FzfLuaTitleFlags = "Comment",
    FzfLuaBackdrop = "Normal",

    -- Preview
    FzfLuaPreviewNormal = "NormalFloat",
    FzfLuaPreviewBorder = "FloatBorder",
    FzfLuaPreviewTitle = "Title",
    FzfLuaCursor = "Cursor",
    FzfLuaCursorLine = "DiffAdd",
    FzfLuaCursorLineNr = "DiffAdd",

    -- Help
    FzfLuaHelpNormal = "NormalFloat",
    FzfLuaHelpBorder = "FloatBorder",

    -- fzf terminal colors
    FzfLuaFzfNormal = "NormalFloat",
    FzfLuaFzfBorder = "FloatBorder",
    FzfLuaFzfCursorLine = "DiffAdd",
    FzfLuaFzfGutter = "NormalFloat",
    FzfLuaFzfHeader = "Comment",
    FzfLuaFzfInfo = "Grey",
    FzfLuaFzfMarker = "Keyword",
    FzfLuaFzfMatch = "Statement",
    FzfLuaFzfPointer = "Exception",
    FzfLuaFzfQuery = "NormalFloat",
    FzfLuaFzfPrompt = "Conditional",
    FzfLuaFzfScrollbar = "FloatBorder",
    FzfLuaFzfSeparator = "FloatBorder",
    FzfLuaFzfSpinner = "Comment",

    -- Headers and live prompts
    FzfLuaHeaderBind = "Comment",
    FzfLuaHeaderText = "Comment",
    FzfLuaLivePrompt = "Comment",
    FzfLuaLiveSym = "Comment",

    -- Paths, buffers, tabs
    FzfLuaPathColNr = "LineNr",
    FzfLuaPathLineNr = "LineNr",
    FzfLuaBufName = "Directory",
    FzfLuaBufId = "TabLine",
    FzfLuaBufNr = "LineNr",
    FzfLuaBufLineNr = "LineNr",
    FzfLuaBufFlagCur = "Comment",
    FzfLuaBufFlagAlt = "Comment",
    FzfLuaTabTitle = "Title",
    FzfLuaTabMarker = "Comment",
    FzfLuaDirIcon = "Directory",
    FzfLuaDirPart = "Comment",
    FzfLuaFilePart = "NormalFloat",

    -- Commands
    FzfLuaCmdEx = "Statement",
    FzfLuaCmdBuf = "Added",
    FzfLuaCmdGlobal = "Directory",

    -- Scrollbars
    FzfLuaScrollBorderEmpty = "FloatBorder",
    FzfLuaScrollBorderFull = "FloatBorder",
    FzfLuaScrollFloatEmpty = "PmenuSbar",
    FzfLuaScrollFloatFull = "PmenuThumb",

    FzfLuaSearch = "Search",
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
  link("markdownUrl", "@markup.link.url")
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
