-- Custom colorscheme (no external dependency)

local M = {}

-- Fzf
M.fzf = {
  fg = "#d4be98",
  bg = "#282828",
  hl = "#a9b665",
  ["fg+"] = "#d4be98",
  ["bg+"] = "#32302f",
  ["hl+"] = "#89b482",
  info = "#89b482",
  border = "#928374",
  query = "#d4be98",
  prompt = "#e78a4e",
  pointer = "#7daea3",
  marker = "#d8a657",
  header = "#928374",
  label = "#d4be98",
  gutter = "#282828",
}

-- UI
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

-- Syntax
M.syntax = {
  comment = "#928374",
  string = "#89b482",
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

-- Semantic groups for nvim highlights
M.semantic = {
  text = "#d4be98",
  muted = "#928374",
  error = "#ea6962",
  warning = "#d8a657",
  info = "#7daea3",
  hint = "#d3869b",
  success = "#a9b665",
  prompt = "#e78a4e",
  operator = "#e78a4e",
  type = "#d8a657",
  ["function"] = "#a9b665",
  constant = "#89b482",
  variable = "#7daea3",
  number = "#d3869b",
  directory = "#7daea3",
  symlink = "#89b482",
  executable = "#a9b665",
  special = "#d8a657",
  special_char = "#d8a657",
  module = "#7daea3",
  title = "#a9b665",
  added = "#a9b665",
  added_bg = "#34381b",
  changed = "#7daea3",
  changed_bg = "#0e363e",
  removed = "#ea6962",
  removed_bg = "#402120",
  diff_text = "#7daea3",
  diff_text_bg = "#374141",
  border = "#928374",
  border_active = "#a89984",
  surface = "#32302f",
  surface_alt = "#45403d",
  selection = "#45403d",
  current_word = "#3c3836",
  status_bg = "#3a3735",
  status_fg = "#ddc7a1",
  status_inactive_fg = "#928374",
  search_bg = "#d8a657",
  search_fg = "#282828",
  inc_search_bg = "#e78a4e",
  inc_search_fg = "#282828",
  popup_bg = "#282828",
  popup_sel = "#45403d",
}

-- Diff
M.diff = {
  add = M.semantic.added,
  change = M.semantic.changed,
  delete = M.semantic.removed,
  text = M.semantic.diff_text,
  add_bg = M.semantic.added_bg,
  change_bg = M.semantic.changed_bg,
  delete_bg = M.semantic.removed_bg,
  text_bg = M.semantic.diff_text_bg,
}

-- Tooling
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

-- StatusLine
M.statusline = {
  normal_bg = "#3a3735",
  normal_fg = "#ddc7a1",
  insert_bg = "#a9b665",
  insert_fg = "#282828",
  visual_bg = "#d8a657",
  visual_fg = "#282828",
  replace_bg = "#ea6962",
  replace_fg = "#282828",
  command_bg = "#7daea3",
  command_fg = "#282828",
  terminal_bg = "#d3869b",
  terminal_fg = "#282828",
  section_bg = "#504945",
  section_fg = "#d4be98",
  inactive_bg = "#32302f",
  inactive_fg = "#928374",
}

-- lualine theme
M.lualine_theme = {
  normal = {
    a = { bg = M.ui.fg, fg = M.ui.bg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.ui.fg, fg = M.ui.bg },
  },
  insert = {
    a = { bg = M.semantic.error, fg = M.ui.bg },
    b = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    c = { bg = M.statusline.section_bg, fg = M.statusline.section_fg },
    z = { bg = M.semantic.error, fg = M.ui.bg },
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
  vim.cmd("highlight clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.g.colors_name = "custom-dark"
  vim.o.background = "dark"

  local ui = M.ui
  local statusline = M.statusline
  local sem = M.semantic
  local s = M.syntax
  local d = {
    error = sem.error,
    warn = sem.warning,
    info = sem.info,
    hint = sem.hint,
    ok = sem.success,
  }
  local diff = M.diff
  local t = M.tool

  local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  local link = function(group, target)
    vim.api.nvim_set_hl(0, group, { link = target })
  end

  -- UI
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

  hl("LineNr", { fg = ui.fg_dim })
  link("LineNrAbove", "LineNr")
  link("LineNrBelow", "LineNr")
  hl("CursorLineNr", { fg = ui.fg_alt })
  link("CursorLineFold", "FoldColumn")
  link("CursorLineSign", "SignColumn")

  -- Diff
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

  hl("Pmenu", { fg = ui.fg, bg = ui.popup_bg })
  hl("PmenuSbar", { bg = ui.popup_bg })
  hl("PmenuSel", { fg = ui.fg, bg = ui.popup_sel })
  hl("PmenuMatch", { fg = s.type, bold = true })
  hl("PmenuMatchSel", { fg = s.type, bg = ui.popup_sel, bold = true })
  hl("PmenuKind", { fg = s["function"], bg = ui.popup_bg })
  hl("PmenuExtra", { fg = ui.fg_alt, bg = ui.popup_bg })
  link("WildMenu", "PmenuSel")
  hl("PmenuThumb", { bg = ui.fg_dim })

  hl("NormalFloat", { fg = ui.fg, bg = ui.popup_bg })
  hl("FloatBorder", { fg = ui.border, bg = ui.popup_bg })
  hl("FloatTitle", { fg = s["function"], bg = ui.popup_bg })
  link("FloatFooter", "FloatTitle")
  hl("FloatShadow", { bg = ui.popup_bg, blend = 30 })
  hl("FloatShadowThrough", { bg = ui.popup_bg, blend = 100 })

  -- Floating/UI helpers
  hl("Question", { fg = d.info })
  hl("MsgArea", { fg = ui.fg, bg = ui.bg })
  hl("MsgSeparator", { fg = ui.fg_dim, bg = ui.bg })

  hl("SpellBad", { undercurl = true, sp = d.error })
  hl("SpellCap", { undercurl = true, sp = d.info })
  hl("SpellLocal", { undercurl = true, sp = d.ok })
  hl("SpellRare", { undercurl = true, sp = d.hint })

  -- StatusLine
  hl("StatusLine", { fg = sem.status_fg, bg = sem.status_bg })
  hl("StatusLineNC", { fg = sem.status_inactive_fg, bg = sem.status_bg })
  hl("StatusLineTerm", { fg = sem.status_fg, bg = sem.status_bg })
  hl("StatusLineTermNC", { fg = sem.status_inactive_fg, bg = sem.status_bg })
  hl("TabLine", { fg = sem.status_inactive_fg, bg = sem.status_bg })
  hl("TabLineFill", { fg = sem.status_inactive_fg, bg = sem.status_bg })
  hl("TabLineSel", { fg = ui.bg, bg = ui.fg })
  hl("WinBar", { fg = ui.bg, bg = ui.fg })
  hl("WinBarNC", { fg = sem.status_inactive_fg, bg = statusline.inactive_bg })
  hl(
    "LualineSeparator",
    { bg = statusline.section_bg, fg = statusline.section_fg }
  )

  hl("VertSplit", { fg = ui.border })
  link("WinSeparator", "VertSplit")

  hl("Visual", { fg = ui.fg, bg = ui.visual })
  hl("VisualNOS", { fg = ui.fg, bg = ui.visual })

  hl("QuickFixLine", { fg = s.number })
  hl("Debug", { fg = t.prompt_alt })
  hl("debugPC", { fg = ui.bg, bg = t.git_clean })
  hl("debugBreakpoint", { fg = ui.bg, bg = d.error })
  hl("ToolbarButton", { fg = ui.fg, bg = ui.bg_alt })
  hl("Substitute", { fg = ui.bg, bg = s.type })

  -- Diagnostics
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
  link("DiagnosticSignError", "ErrorSign")
  link("DiagnosticSignWarn", "WarningSign")
  link("DiagnosticSignInfo", "InfoSign")
  link("DiagnosticSignHint", "HintSign")
  link("DiagnosticSignOk", "SuccessSign")

  -- LSP
  link("LspReferenceText", "CurrentWord")
  link("LspReferenceRead", "CurrentWord")
  link("LspReferenceWrite", "CurrentWord")
  link("LspInlayHint", "InlayHints")
  link("LspCodeLens", "VirtualTextInfo")
  link("LspCodeLensSeparator", "VirtualTextHint")
  link("LspSignatureActiveParameter", "Search")
  link("TermCursor", "Cursor")
  link("healthError", "Error")
  link("healthSuccess", "Success")
  link("healthWarning", "Warning")

  -- Syntax
  hl("Boolean", { fg = s.constant })
  hl("Number", { fg = s.number })
  hl("Float", { fg = s.number })
  hl("PreProc", { fg = s.preproc, italic = true })
  hl("PreCondit", { fg = s.preproc, italic = true })
  hl("Include", { fg = s.preproc, italic = true })
  hl("Module", { fg = sem.module, italic = true })
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
  -- Semantic highlight groups
  -- ==========================================================================
  hl("Text", { fg = sem.text })
  hl("Muted", { fg = sem.muted })
  hl("Error", { fg = sem.error })
  hl("Warning", { fg = sem.warning })
  hl("Info", { fg = sem.info })
  hl("Hint", { fg = sem.hint })
  hl("Success", { fg = sem.success })
  hl("Prompt", { fg = sem.prompt })
  hl("Operator", { fg = sem.operator })
  hl("Type", { fg = sem.type })
  hl("Function", { fg = sem["function"] })
  hl("Constant", { fg = sem.constant })
  hl("Variable", { fg = sem.variable })
  hl("Number", { fg = sem.number })
  hl("Directory", { fg = sem.directory })
  hl("Symlink", { fg = sem.symlink })
  hl("Executable", { fg = sem.executable })
  hl("Special", { fg = sem.special })
  hl("SpecialChar", { fg = sem.special_char })
  hl("Title", { fg = sem.title, bold = true })

  -- Italic variants (italic enabled)
  hl("ErrorItalic", { fg = sem.error, italic = true })
  hl("WarningItalic", { fg = sem.warning, italic = true })
  hl("InfoItalic", { fg = sem.info, italic = true })
  hl("HintItalic", { fg = sem.hint, italic = true })
  hl("SuccessItalic", { fg = sem.success, italic = true })
  hl("PromptItalic", { fg = sem.prompt, italic = true })
  hl("OperatorItalic", { fg = sem.operator, italic = true })
  hl("TypeItalic", { fg = sem.type, italic = true })
  hl("FunctionItalic", { fg = sem["function"], italic = true })
  hl("ConstantItalic", { fg = sem.constant, italic = true })
  hl("VariableItalic", { fg = sem.variable, italic = true })
  hl("NumberItalic", { fg = sem.number, italic = true })

  -- Bold variants (bold enabled)
  hl("ErrorBold", { fg = sem.error, bold = true })
  hl("WarningBold", { fg = sem.warning, bold = true })
  hl("InfoBold", { fg = sem.info, bold = true })
  hl("HintBold", { fg = sem.hint, bold = true })
  hl("SuccessBold", { fg = sem.success, bold = true })
  hl("PromptBold", { fg = sem.prompt, bold = true })
  hl("OperatorBold", { fg = sem.operator, bold = true })
  hl("TypeBold", { fg = sem.type, bold = true })
  hl("FunctionBold", { fg = sem["function"], bold = true })
  hl("ConstantBold", { fg = sem.constant, bold = true })
  hl("VariableBold", { fg = sem.variable, bold = true })
  hl("NumberBold", { fg = sem.number, bold = true })

  -- Sign variants (sign_column_background=none)
  hl("ErrorSign", { fg = sem.error })
  hl("WarningSign", { fg = sem.warning })
  hl("InfoSign", { fg = sem.info })
  hl("HintSign", { fg = sem.hint })
  hl("SuccessSign", { fg = sem.success })
  hl("PromptSign", { fg = sem.prompt })
  hl("OperatorSign", { fg = sem.operator })
  hl("TypeSign", { fg = sem.type })
  hl("FunctionSign", { fg = sem["function"] })
  hl("ConstantSign", { fg = sem.constant })
  hl("VariableSign", { fg = sem.variable })
  hl("NumberSign", { fg = sem.number })

  link("Added", "Success")
  link("Removed", "Error")
  link("Changed", "Info")

  -- ==========================================================================
  -- Diagnostics
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
  link("VirtualTextWarning", "Muted")
  link("VirtualTextError", "Muted")
  link("VirtualTextInfo", "Muted")
  link("VirtualTextHint", "Muted")
  link("VirtualTextOk", "Muted")

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
  -- Terminal
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
  -- Treesitter
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
  link("@conceal", "Muted")
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
  link("@markup.list.checked", "Success")
  link("@markup.list.unchecked", "Ignore")
  link("@markup.math", "Special")
  link("@markup.note", "@comment.note")
  link("@markup.quote", "Muted")
  link("@markup.raw", "String")
  link("@markup.strike", "Muted")
  link("@math", "Special")
  link("@method", "Function")
  link("@method.call", "Function")
  link("@module", "Module")
  link("@namespace", "Include")
  link("@none", "Text")
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
  link("@strike", "Muted")
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
  link("@text", "Text")
  link("@text.diff.add", "diffAdded")
  link("@text.diff.delete", "diffRemoved")
  link("@text.environment", "Macro")
  link("@text.environment.name", "Type")
  link("@text.literal", "String")
  link("@text.math", "Special")
  link("@text.reference", "Identifier")
  link("@text.strike", "Muted")
  link("@text.title", "Title")
  link("@text.todo", "Todo")
  link("@text.todo.checked", "Success")
  link("@text.todo.unchecked", "Ignore")
  link("@type", "Type")
  link("@type.builtin", "Type")
  link("@type.definition", "Typedef")
  link("@type.qualifier", "Typedef")
  link("@variable", "Identifier")
  link("@variable.builtin", "Identifier")
  link("@variable.member", "Identifier")
  link("@variable.parameter", "Identifier")

  -- Treesitter semantic captures
  hl("DiagnosticUnnecessary", { fg = ui.fg_dim })
  hl("DiagnosticDeprecated", { strikethrough = true, sp = ui.fg })
  link("@lsp.mod.deprecated", "DiagnosticDeprecated")

  -- ==========================================================================
  -- Plugins
  -- ==========================================================================

  -- copilot.lua
  link("CopilotSuggestion", "Muted")

  -- nvim-cmp
  hl("CmpItemAbbrMatch", { fg = s["function"], bold = true })
  hl("CmpItemAbbrMatchFuzzy", { fg = s["function"], bold = true })
  link("CmpItemAbbr", "Text")
  link("CmpItemAbbrDeprecated", "Muted")
  link("CmpItemMenu", "Text")
  link("CmpItemKind", "Type")
  for group, target in pairs({
    CmpItemKindArray = "Constant",
    CmpItemKindBoolean = "Constant",
    CmpItemKindClass = "Type",
    CmpItemKindColor = "Constant",
    CmpItemKindConstant = "Constant",
    CmpItemKindConstructor = "Function",
    CmpItemKindDefault = "Text",
    CmpItemKindEnum = "Type",
    CmpItemKindEnumMember = "Constant",
    CmpItemKindEvent = "Special",
    CmpItemKindField = "Variable",
    CmpItemKindFile = "Directory",
    CmpItemKindFolder = "Directory",
    CmpItemKindFunction = "Function",
    CmpItemKindInterface = "Type",
    CmpItemKindKey = "Prompt",
    CmpItemKindKeyword = "Operator",
    CmpItemKindMethod = "Function",
    CmpItemKindModule = "Include",
    CmpItemKindNamespace = "Include",
    CmpItemKindNull = "Constant",
    CmpItemKindNumber = "Number",
    CmpItemKindObject = "Constant",
    CmpItemKindOperator = "Operator",
    CmpItemKindPackage = "Include",
    CmpItemKindProperty = "Variable",
    CmpItemKindReference = "Variable",
    CmpItemKindSnippet = "Special",
    CmpItemKindString = "Constant",
    CmpItemKindStruct = "Type",
    CmpItemKindText = "Text",
    CmpItemKindTypeParameter = "Type",
    CmpItemKindUnit = "Constant",
    CmpItemKindValue = "Constant",
    CmpItemKindVariable = "Variable",
  }) do
    link(group, target)
  end

  -- fzf-lua
  for group, target in pairs({
    FzfLuaBorder = "FloatBorder",
    FzfLuaCursorLine = "DiffAdd",
    FzfLuaCursorLineNr = "DiffAdd",
    FzfLuaFzfBorder = "FloatBorder",
    FzfLuaFzfCursorLine = "DiffAdd",
    FzfLuaFzfHeader = "Prompt",
    FzfLuaFzfInfo = "Info",
    FzfLuaFzfMarker = "Warning",
    FzfLuaFzfMatch = "Success",
    FzfLuaFzfNormal = "NormalFloat",
    FzfLuaFzfGutter = "NormalFloat",
    FzfLuaFzfPointer = "Warning",
    FzfLuaFzfQuery = "NormalFloat",
    FzfLuaFzfPrompt = "Prompt",
    FzfLuaFzfScrollbar = "FloatBorder",
    FzfLuaFzfSeparator = "FloatBorder",
    FzfLuaFzfSpinner = "Comment",
    FzfLuaNormal = "NormalFloat",
    FzfLuaPreviewBorder = "FloatBorder",
    FzfLuaPreviewNormal = "NormalFloat",
    FzfLuaPreviewTitle = "Title",
    FzfLuaSearch = "Success",
    FzfLuaTitle = "Title",
    FzfLuaTitleFlags = "Comment",
    FzfLuaBackdrop = "Normal",
    FzfLuaCursor = "Cursor",
    FzfLuaHelpNormal = "NormalFloat",
    FzfLuaHelpBorder = "FloatBorder",
    FzfLuaHeaderBind = "Warning",
    FzfLuaHeaderText = "Prompt",
    FzfLuaLivePrompt = "Prompt",
    FzfLuaLiveSym = "Prompt",
    FzfLuaPathColNr = "Variable",
    FzfLuaPathLineNr = "Success",
    FzfLuaBufName = "Number",
    FzfLuaBufId = "TabLine",
    FzfLuaBufNr = "Warning",
    FzfLuaBufLineNr = "LineNr",
    FzfLuaBufFlagCur = "Prompt",
    FzfLuaBufFlagAlt = "Variable",
    FzfLuaTabTitle = "Variable",
    FzfLuaTabMarker = "Warning",
    FzfLuaDirIcon = "Directory",
    FzfLuaDirPart = "NonText",
    FzfLuaFilePart = "NormalFloat",
    FzfLuaCmdEx = "Statement",
    FzfLuaCmdBuf = "Success",
    FzfLuaCmdGlobal = "Directory",
    FzfLuaScrollBorderEmpty = "FloatBorder",
    FzfLuaScrollBorderFull = "FloatBorder",
    FzfLuaScrollFloatEmpty = "PmenuSbar",
    FzfLuaScrollFloatFull = "PmenuThumb",
  }) do
    link(group, target)
  end

  -- gitsigns.nvim
  link("GitSignsAdd", "SuccessSign")
  link("GitSignsChange", "InfoSign")
  link("GitSignsDelete", "ErrorSign")
  link("GitSignsAddNr", "Success")
  link("GitSignsChangeNr", "Info")
  link("GitSignsDeleteNr", "Error")
  link("GitSignsAddLn", "DiffAdd")
  link("GitSignsChangeLn", "DiffChange")
  link("GitSignsDeleteLn", "DiffDelete")
  link("GitSignsCurrentLineBlame", "Muted")

  -- which-key.nvim
  link("WhichKey", "Prompt")
  link("WhichKeySeparator", "Success")
  link("WhichKeyGroup", "Warning")
  link("WhichKeyDesc", "Info")

  -- terminal backdrop
  hl("TerminalBackdrop", { bg = ui.bg })

  -- nvim-tree.nvim
  link("NvimTreeNormal", "Normal")
  link("NvimTreeNormalNC", "Normal")
  link("NvimTreeEndOfBuffer", "Normal")
  hl("NvimTreeWinSeparator", { fg = ui.border, bg = ui.bg })
  link("NvimTreeSymlink", "Symlink")
  link("NvimTreeFolderName", "Directory")
  link("NvimTreeRootFolder", "Prompt")
  link("NvimTreeFolderIcon", "Directory")
  link("NvimTreeEmptyFolderName", "Directory")
  link("NvimTreeOpenedFolderName", "Directory")
  link("NvimTreeExecFile", "Executable")
  link("NvimTreeOpenedHL", "Text")
  link("NvimTreeSpecialFile", "Special")
  link("NvimTreeImageFile", "Special")
  link("NvimTreeOpenedFile", "Text")
  hl("NvimTreeStatuslineNc", { fg = ui.bg_alt, bg = ui.bg_alt })
  link("NvimTreeIndentMarker", "Muted")
  link("NvimTreeGitDirtyIcon", "Warning")
  link("NvimTreeGitStagedIcon", "Info")
  link("NvimTreeGitMergeIcon", "Warning")
  link("NvimTreeGitRenamedIcon", "Number")
  link("NvimTreeGitNewIcon", "Success")
  link("NvimTreeGitDeletedIcon", "Error")
  link("NvimTreeLspDiagnosticsError", "ErrorSign")
  link("NvimTreeLspDiagnosticsWarning", "WarningSign")
  link("NvimTreeLspDiagnosticsInformation", "InfoSign")
  link("NvimTreeLspDiagnosticsHint", "HintSign")

  -- csvview.nvim
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
  link("diffAdded", "Success")
  link("diffRemoved", "Error")
  link("diffChanged", "Info")
  link("diffFile", "Variable")
  link("diffOldFile", "Warning")
  link("diffNewFile", "Prompt")
  link("diffIndexLine", "Constant")
  link("diffLine", "Muted")

  -- mason.nvim
  hl("MasonHeader", { fg = ui.bg, bg = s.variable, bold = true })
  hl("MasonHeaderSecondary", { fg = ui.bg, bg = s.number, bold = true })
  link("MasonHighlight", "Success")
  link("MasonHighlightSecondary", "Number")
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
