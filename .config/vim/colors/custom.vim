" ==========================================================================
" Semantic color definitions (mirrors Neovim sections)
" ==========================================================================

let s:ui_bg_dim = "1b1b1b"
let s:ui_bg = "282828"
let s:ui_bg_alt = "32302f"
let s:ui_fg = "d4be98"
let s:ui_fg_alt = "ddc7a1"
let s:ui_fg_dim = "928374"
let s:ui_border = "928374"
let s:ui_border_active = "a89984"
let s:ui_selection = "45403d"
let s:ui_visual = "45403d"
let s:ui_cursorline = "32302f"
let s:ui_search_bg = "d8a657"
let s:ui_search_fg = "282828"
let s:ui_inc_search_bg = "e78a4e"
let s:ui_inc_search_fg = "282828"
let s:ui_popup_bg = "282828"
let s:ui_popup_sel = "45403d"
let s:ui_status_bg = "32302f"
let s:ui_status_fg = "ddc7a1"
let s:ui_status_inactive_fg = "928374"

let s:statusline_normal_bg = "3a3735"
let s:statusline_normal_fg = "ddc7a1"
let s:statusline_insert_bg = "a9b665"
let s:statusline_insert_fg = "282828"
let s:statusline_visual_bg = "d8a657"
let s:statusline_visual_fg = "282828"
let s:statusline_replace_bg = "ea6962"
let s:statusline_replace_fg = "282828"
let s:statusline_command_bg = "7daea3"
let s:statusline_command_fg = "282828"
let s:statusline_terminal_bg = "d3869b"
let s:statusline_terminal_fg = "282828"
let s:statusline_section_bg = "504945"
let s:statusline_section_fg = "d4be98"
let s:statusline_inactive_bg = "32302f"
let s:statusline_inactive_fg = "928374"

let s:semantic_text = "d4be98"
let s:semantic_muted = "928374"
let s:semantic_error = "ea6962"
let s:semantic_warning = "d8a657"
let s:semantic_info = "7daea3"
let s:semantic_hint = "d3869b"
let s:semantic_success = "a9b665"
let s:semantic_prompt = "e78a4e"
let s:semantic_operator = "e78a4e"
let s:semantic_type = "d8a657"
let s:semantic_function = "a9b665"
let s:semantic_constant = "89b482"
let s:semantic_variable = "7daea3"
let s:semantic_number = "d3869b"
let s:semantic_directory = "7daea3"
let s:semantic_symlink = "89b482"
let s:semantic_executable = "a9b665"
let s:semantic_special = "d8a657"
let s:semantic_special_char = "d8a657"
let s:semantic_title = "a9b665"
let s:semantic_added = "a9b665"
let s:semantic_changed = "7daea3"
let s:semantic_removed = "ea6962"
let s:semantic_diff_text = "7daea3"
let s:semantic_border = "928374"
let s:semantic_border_active = "a89984"
let s:semantic_surface = "32302f"
let s:semantic_surface_alt = "45403d"
let s:semantic_selection = "45403d"
let s:semantic_current_word = "3c3836"
let s:semantic_status_bg = "3a3735"
let s:semantic_status_fg = "ddc7a1"
let s:semantic_status_inactive_fg = "928374"
let s:semantic_search_bg = "d8a657"
let s:semantic_search_fg = "282828"
let s:semantic_inc_search_bg = "e78a4e"
let s:semantic_inc_search_fg = "282828"
let s:semantic_popup_bg = "282828"
let s:semantic_popup_sel = "45403d"

let s:syntax_comment = "928374"
let s:syntax_string = "89b482"
let s:syntax_escape = "d8a657"
let s:syntax_number = "d3869b"
let s:syntax_constant = "89b482"
let s:syntax_keyword = "ea6962"
let s:syntax_operator = "e78a4e"
let s:syntax_type = "d8a657"
let s:syntax_function = "a9b665"
let s:syntax_variable = "7daea3"
let s:syntax_property = "7daea3"
let s:syntax_builtin = "ea6962"
let s:syntax_preproc = "d3869b"
let s:syntax_special = "d8a657"
let s:syntax_delimiter = "d4be98"

let s:diagnostic_error = "ea6962"
let s:diagnostic_warn = "d8a657"
let s:diagnostic_info = "7daea3"
let s:diagnostic_hint = "d3869b"
let s:diagnostic_ok = "a9b665"

let s:diff_add = "a9b665"
let s:diff_change = "7daea3"
let s:diff_delete = "ea6962"
let s:diff_text = "7daea3"
let s:diff_add_bg = "34381b"
let s:diff_change_bg = "0e363e"
let s:diff_delete_bg = "402120"
let s:diff_text_bg = "374141"

let s:tool_prompt = "d8a657"
let s:tool_prompt_alt = "e78a4e"
let s:tool_path = "7daea3"
let s:tool_root = "ea6962"
let s:tool_duration = "d8a657"
let s:tool_git_clean = "a9b665"
let s:tool_git_dirty = "d8a657"
let s:tool_git_ahead = "7daea3"
let s:tool_git_behind = "ea6962"
let s:tool_directory = "7daea3"
let s:tool_executable = "a9b665"
let s:tool_symlink = "89b482"
let s:tool_archive = "d8a657"
let s:tool_media = "89b482"
let s:tool_document = "d8a657"
let s:tool_backup = "7c6f64"

let s:terminal_background = "282828"
let s:terminal_foreground = "d4be98"
let s:terminal_selection = "45403d"
let s:terminal_tab_background = "282828"
let s:terminal_tab_unfocused_background = "282828"

" ==========================================================================
" Helper
" ==========================================================================
function! s:hl(group, fg, bg, ...)
  let l:attr = a:0 > 0 ? a:1 : 'NONE'
  let l:sp = a:0 > 1 ? a:2 : ''
  execute 'highlight ' . a:group
    \ . ' guifg=' . (a:fg ==# '' ? 'NONE' : '#' . a:fg)
    \ . ' guibg=' . (a:bg ==# '' ? 'NONE' : '#' . a:bg)
    \ . ' gui=' . l:attr
    \ . ' cterm=NONE'
    \ . (l:sp !=# '' ? ' guisp=#' . l:sp : '')
endfunction

" ==========================================================================
" UI highlights
" ==========================================================================
call s:hl('Normal',       s:ui_fg, s:ui_bg)
call s:hl('NormalNC',     s:ui_fg, s:ui_bg)
call s:hl('Terminal',     s:ui_fg, s:ui_bg)
call s:hl('EndOfBuffer',  s:ui_bg, s:ui_bg)
call s:hl('Folded',       s:ui_fg_dim, s:ui_bg_alt)
call s:hl('ToolbarLine',  s:ui_fg, s:ui_bg_alt)
call s:hl('SignColumn',   s:ui_fg_dim, '')
call s:hl('FoldColumn',   s:ui_fg_dim, '')

call s:hl('IncSearch',    s:ui_inc_search_fg, s:ui_inc_search_bg)
call s:hl('Search',       s:ui_search_fg, s:ui_search_bg)
highlight! link CurSearch IncSearch
call s:hl('ColorColumn',  '',      s:ui_bg_alt)
call s:hl('Conceal',      s:ui_bg_alt, '')

call s:hl('Cursor',       '',      '',      'reverse')
highlight! link vCursor   Cursor
highlight! link iCursor   Cursor
highlight! link lCursor   Cursor
highlight! link CursorIM  Cursor

call s:hl('CursorLine',   '',      s:ui_cursorline)
call s:hl('CursorColumn', '',      s:ui_cursorline)

call s:hl('LineNr',       s:ui_fg_dim, '')
call s:hl('CursorLineNr', s:ui_border_active, '')

call s:hl('DiffAdd',      s:diff_add, s:diff_add_bg)
call s:hl('DiffChange',   s:diff_change, s:diff_change_bg)
call s:hl('DiffDelete',   s:diff_delete, s:diff_delete_bg)
call s:hl('DiffText',     s:diff_text, s:diff_text_bg)

call s:hl('Directory',    s:semantic_directory, '')
call s:hl('ErrorMsg',     s:diagnostic_error, '',      'underline')
call s:hl('WarningMsg',   s:diagnostic_warn, '')
call s:hl('ModeMsg',      s:ui_fg, '')
call s:hl('MoreMsg',      s:diagnostic_warn, '')
call s:hl('MatchParen',   '',      s:ui_bg_alt)
call s:hl('NonText',      s:ui_bg_alt, '')
call s:hl('Whitespace',   s:ui_bg_alt, '')
call s:hl('SpecialKey',   s:ui_bg_alt, '')

" Pmenu
call s:hl('Pmenu',        s:ui_fg, s:ui_bg)
call s:hl('PmenuSbar',    '',      s:ui_bg)
call s:hl('PmenuSel',     s:ui_fg, s:ui_popup_sel)
call s:hl('PmenuKind',    s:syntax_function, s:ui_popup_bg)
call s:hl('PmenuExtra',   s:ui_fg_alt, s:ui_popup_bg)
highlight! link WildMenu PmenuSel
call s:hl('PmenuThumb',   '',      s:ui_fg_dim)

call s:hl('Question',     s:diagnostic_info, '')

" Spell
call s:hl('SpellBad',     '',      '',      'undercurl', s:diagnostic_error)
call s:hl('SpellCap',     '',      '',      'undercurl', s:diagnostic_info)
call s:hl('SpellLocal',   '',      '',      'undercurl', s:diagnostic_ok)
call s:hl('SpellRare',    '',      '',      'undercurl', s:diagnostic_hint)

" StatusLine
call s:hl('StatusLine',       s:semantic_status_fg, s:semantic_status_bg)
call s:hl('StatusLineTerm',    s:semantic_status_fg, s:semantic_status_bg)
call s:hl('StatusLineNC',     s:semantic_status_inactive_fg, s:semantic_status_bg)
call s:hl('StatusLineTermNC', s:semantic_status_inactive_fg, s:semantic_status_bg)
call s:hl('TabLine',          s:semantic_status_inactive_fg, s:semantic_status_bg)
call s:hl('TabLineFill',      s:semantic_status_inactive_fg, s:semantic_status_bg)
call s:hl('TabLineSel',       s:ui_bg, s:ui_fg)

" VertSplit / WinSeparator
call s:hl('VertSplit',    s:ui_fg_dim, '')
if exists('+winfixbuf')
  highlight! link WinSeparator VertSplit
endif

" Visual
call s:hl('Visual',       s:ui_fg, s:ui_visual)
call s:hl('VisualNOS',    s:ui_fg, s:ui_visual)

call s:hl('QuickFixLine', s:syntax_number, '')
call s:hl('Debug',        s:tool_prompt_alt, '')
call s:hl('debugPC',      s:ui_bg, s:tool_git_clean)
call s:hl('debugBreakpoint', s:ui_bg, s:diagnostic_error)
call s:hl('ToolbarButton', s:ui_fg, s:ui_bg_alt)
call s:hl('Substitute',   s:ui_bg, s:syntax_type)

" ==========================================================================
" Syntax highlights
" ==========================================================================
call s:hl('Boolean',      s:syntax_number, '')
call s:hl('Number',       s:syntax_number, '')
call s:hl('Float',        s:syntax_number, '')

" italic enabled
call s:hl('PreProc',      s:syntax_number, '',      'italic')
call s:hl('PreCondit',    s:syntax_number, '',      'italic')
call s:hl('Include',      s:syntax_number, '',      'italic')
call s:hl('Define',       s:syntax_number, '',      'italic')
call s:hl('Conditional',  s:syntax_keyword, '',      'italic')
call s:hl('Repeat',       s:syntax_keyword, '',      'italic')
call s:hl('Keyword',      s:syntax_keyword, '',      'italic')
call s:hl('Typedef',      s:syntax_type, '',      'italic')
call s:hl('Exception',    s:syntax_special, '',      'italic')
call s:hl('Statement',    s:syntax_keyword, '',      'italic')

call s:hl('Error',        s:diagnostic_error, '')
call s:hl('StorageClass', s:syntax_type, '')
call s:hl('Tag',          s:syntax_type, '')
call s:hl('Label',        s:syntax_type, '')
call s:hl('Structure',    s:syntax_type, '')
call s:hl('Operator',     s:syntax_operator, '')
call s:hl('Title',        s:semantic_title, '',      'bold')
call s:hl('Special',      s:syntax_special, '')
call s:hl('SpecialChar',  s:syntax_escape, '')
call s:hl('Type',         s:syntax_type, '')

call s:hl('Function',     s:syntax_function, '')

call s:hl('String',       s:syntax_string, '')
call s:hl('Character',    s:syntax_string, '')
call s:hl('Constant',     s:syntax_constant, '')
call s:hl('Macro',        s:syntax_constant, '')
call s:hl('Identifier',   s:syntax_variable, '')

call s:hl('Todo',         s:ui_bg, s:syntax_variable, 'bold')

" italic comments
call s:hl('Comment',        s:syntax_comment, '',    'italic')
call s:hl('SpecialComment', s:syntax_comment, '',    'italic')

call s:hl('Delimiter',    s:syntax_delimiter, '')
call s:hl('Ignore',       s:ui_fg_dim, '')
call s:hl('Underlined',   '',      '',      'underline')

" ==========================================================================
" Predefined highlight groups
" ==========================================================================
call s:hl('SemanticText',    s:semantic_text, '')
call s:hl('SemanticMuted',   s:semantic_muted, '')
call s:hl('SemanticError',   s:semantic_error, '')
call s:hl('SemanticWarning', s:semantic_warning, '')
call s:hl('SemanticInfo',    s:semantic_info, '')
call s:hl('SemanticHint',    s:semantic_hint, '')
call s:hl('SemanticSuccess', s:semantic_success, '')
call s:hl('SemanticPrompt',  s:semantic_prompt, '')
call s:hl('SemanticDirectory', s:semantic_directory, '')
call s:hl('SemanticType',      s:semantic_type, '')
call s:hl('SemanticFunction',  s:semantic_function, '')
call s:hl('SemanticConstant',  s:semantic_constant, '')
call s:hl('SemanticVariable',  s:semantic_variable, '')
call s:hl('SemanticNumber',    s:semantic_number, '')
call s:hl('SemanticAdded',     s:semantic_added, '')
call s:hl('SemanticChanged',   s:semantic_changed, '')
call s:hl('SemanticRemoved',   s:semantic_removed, '')
call s:hl('SemanticDiffText',  s:semantic_diff_text, '')

call s:hl('SemanticTextItalic',    s:semantic_text, '',      'italic')
call s:hl('SemanticMutedItalic',   s:semantic_muted, '',      'italic')
call s:hl('SemanticErrorItalic',   s:semantic_error, '',      'italic')
call s:hl('SemanticWarningItalic', s:semantic_warning, '',      'italic')
call s:hl('SemanticInfoItalic',    s:semantic_info, '',      'italic')
call s:hl('SemanticHintItalic',    s:semantic_hint, '',      'italic')
call s:hl('SemanticSuccessItalic', s:semantic_success, '',      'italic')
call s:hl('SemanticPromptItalic',  s:semantic_prompt, '',      'italic')
call s:hl('SemanticDirectoryItalic', s:semantic_directory, '', 'italic')
call s:hl('SemanticTypeItalic',      s:semantic_type, '',      'italic')
call s:hl('SemanticFunctionItalic',  s:semantic_function, '',  'italic')
call s:hl('SemanticConstantItalic',  s:semantic_constant, '',  'italic')
call s:hl('SemanticVariableItalic',  s:semantic_variable, '',  'italic')
call s:hl('SemanticNumberItalic',    s:semantic_number, '',    'italic')

call s:hl('SemanticTextBold',    s:semantic_text, '',      'bold')
call s:hl('SemanticMutedBold',   s:semantic_muted, '',      'bold')
call s:hl('SemanticErrorBold',   s:semantic_error, '',      'bold')
call s:hl('SemanticWarningBold', s:semantic_warning, '',      'bold')
call s:hl('SemanticInfoBold',    s:semantic_info, '',      'bold')
call s:hl('SemanticHintBold',    s:semantic_hint, '',      'bold')
call s:hl('SemanticSuccessBold', s:semantic_success, '',      'bold')
call s:hl('SemanticPromptBold',  s:semantic_prompt, '',      'bold')
call s:hl('SemanticDirectoryBold', s:semantic_directory, '', 'bold')
call s:hl('SemanticTypeBold',      s:semantic_type, '',      'bold')
call s:hl('SemanticFunctionBold',  s:semantic_function, '',  'bold')
call s:hl('SemanticConstantBold',  s:semantic_constant, '',  'bold')
call s:hl('SemanticVariableBold',  s:semantic_variable, '',  'bold')
call s:hl('SemanticNumberBold',    s:semantic_number, '',    'bold')

call s:hl('SemanticTextSign',    s:semantic_text, '')
call s:hl('SemanticMutedSign',   s:semantic_muted, '')
call s:hl('SemanticErrorSign',   s:semantic_error, '')
call s:hl('SemanticWarningSign', s:semantic_warning, '')
call s:hl('SemanticInfoSign',    s:semantic_info, '')
call s:hl('SemanticHintSign',    s:semantic_hint, '')
call s:hl('SemanticSuccessSign', s:semantic_success, '')
call s:hl('SemanticPromptSign',  s:semantic_prompt, '')
call s:hl('SemanticDirectorySign', s:semantic_directory, '')
call s:hl('SemanticTypeSign',      s:semantic_type, '')
call s:hl('SemanticFunctionSign',  s:semantic_function, '')
call s:hl('SemanticConstantSign',  s:semantic_constant, '')
call s:hl('SemanticVariableSign',  s:semantic_variable, '')
call s:hl('SemanticNumberSign',    s:semantic_number, '')

highlight! link Added   SemanticSuccess
highlight! link Removed SemanticError
highlight! link Changed SemanticInfo

" ==========================================================================
" Error/Warning/Info/Hint
" ==========================================================================
call s:hl('ErrorText',    '',      '',      'undercurl', s:diagnostic_error)
call s:hl('WarningText',  '',      '',      'undercurl', s:diagnostic_warn)
call s:hl('InfoText',     '',      '',      'undercurl', s:diagnostic_info)
call s:hl('HintText',     '',      '',      'undercurl', s:diagnostic_hint)

highlight! link VirtualTextWarning SemanticMuted
highlight! link VirtualTextError   SemanticMuted
highlight! link VirtualTextInfo    SemanticMuted
highlight! link VirtualTextHint    SemanticMuted

call s:hl('ErrorFloat',   s:diagnostic_error, '')
call s:hl('WarningFloat', s:diagnostic_warn, '')
call s:hl('InfoFloat',    s:diagnostic_info, '')
call s:hl('HintFloat',    s:diagnostic_hint, '')

call s:hl('CurrentWord',  s:ui_fg, s:semantic_current_word)

highlight! link healthError   SemanticError
highlight! link healthSuccess SemanticSuccess
highlight! link healthWarning SemanticWarning

" ==========================================================================
" Diff
" ==========================================================================
highlight! link diffAdded     SemanticSuccess
highlight! link diffRemoved   SemanticError
highlight! link diffChanged   SemanticInfo
highlight! link diffFile      SemanticConstant
highlight! link diffOldFile   SemanticWarning
highlight! link diffNewFile   SemanticWarning
highlight! link diffIndexLine SemanticNumber
highlight! link diffLine      SemanticMuted

" ==========================================================================
" Filetype: markdown
" ==========================================================================
call s:hl('markdownH1',   s:diagnostic_error, '')
call s:hl('markdownH2',   s:syntax_operator, '')
call s:hl('markdownH3',   s:syntax_type, '')
call s:hl('markdownH4',   s:syntax_function, '')
call s:hl('markdownH5',   s:syntax_variable, '')
call s:hl('markdownH6',   s:syntax_number, '')
call s:hl('markdownItalic', '',    '',      'italic')
call s:hl('markdownBold', '',      '',      'bold')
call s:hl('markdownItalicDelimiter', s:ui_fg_dim, '', 'italic')
highlight! link markdownUrl              Underlined
highlight! link markdownCode             SemanticSuccess
highlight! link markdownCodeBlock        SemanticConstant
highlight! link markdownCodeDelimiter    SemanticConstant
highlight! link markdownBlockquote       SemanticMuted
highlight! link markdownListMarker       SemanticError
highlight! link markdownOrderedListMarker SemanticError
highlight! link markdownRule             SemanticHint
highlight! link markdownHeadingRule      SemanticMuted
highlight! link markdownUrlDelimiter     SemanticMuted
highlight! link markdownLinkDelimiter    SemanticMuted
highlight! link markdownLinkTextDelimiter SemanticMuted
highlight! link markdownHeadingDelimiter SemanticMuted
highlight! link markdownLinkText         SemanticHint
highlight! link markdownUrlTitleDelimiter SemanticSuccess
highlight! link markdownIdDeclaration    markdownLinkText
highlight! link markdownBoldDelimiter    SemanticMutedBold
highlight! link markdownId               SemanticWarning

" ==========================================================================
" Filetype: lua
" ==========================================================================
highlight! link luaFunc         SemanticSuccess
highlight! link luaFunction     SemanticVariable
highlight! link luaTable        SemanticText
highlight! link luaIn           SemanticErrorItalic
highlight! link luaFuncCall     SemanticSuccess
highlight! link luaLocal        SemanticWarning
highlight! link luaSpecialValue SemanticSuccess
highlight! link luaBraces       SemanticText
highlight! link luaBuiltIn      SemanticHint
highlight! link luaNoise        SemanticMuted
highlight! link luaLabel        SemanticHint
highlight! link luaFuncTable    SemanticWarning
highlight! link luaFuncArgName  SemanticVariable
highlight! link luaEllipsis     SemanticWarning
highlight! link luaDocTag       SemanticSuccess

" ==========================================================================
" Filetype: go
" ==========================================================================
highlight! link goPackage              Define
highlight! link goImport               Include
highlight! link goVar                  SemanticWarningItalic
highlight! link goConst                goVar
highlight! link goType                 SemanticWarning
highlight! link goSignedInts           goType
highlight! link goUnsignedInts         goType
highlight! link goFloats               goType
highlight! link goComplexes            goType
highlight! link goVarDefs              SemanticConstant
highlight! link goDeclType             SemanticWarningItalic
highlight! link goFunctionCall         Function
highlight! link goPredefinedIdentifiers SemanticConstant
highlight! link goBuiltins             SemanticSuccess
highlight! link goVarArgs              SemanticMuted

" ==========================================================================
" Statusline mode highlights (lualine-like)
" ==========================================================================
call s:hl('StatusModeNormal',   s:ui_bg, s:ui_fg)
call s:hl('StatusModeInsert',   s:ui_bg, s:diagnostic_error)
call s:hl('StatusModeVisual',   s:ui_bg, s:syntax_type)
call s:hl('StatusModeReplace',  s:ui_bg, s:diagnostic_error)
call s:hl('StatusModeCommand',  s:ui_bg, s:semantic_info)
call s:hl('StatusModeTerminal', s:ui_bg, s:semantic_hint)
call s:hl('StatusModeB',        s:semantic_status_fg, s:statusline_section_bg)
call s:hl('StatusModeC',        s:semantic_status_fg, s:statusline_section_bg)
call s:hl('StatusInactive',     s:semantic_status_inactive_fg, s:statusline_inactive_bg)

" ==========================================================================
" Terminal colors
" ==========================================================================
if has('terminal') || has('nvim')
  let g:terminal_color_0  = '#' . s:ui_bg_alt
  let g:terminal_color_1  = '#' . s:diagnostic_error
  let g:terminal_color_2  = '#' . s:syntax_function
  let g:terminal_color_3  = '#' . s:syntax_type
  let g:terminal_color_4  = '#' . s:syntax_variable
  let g:terminal_color_5  = '#' . s:syntax_number
  let g:terminal_color_6  = '#' . s:syntax_constant
  let g:terminal_color_7  = '#' . s:ui_fg_alt
  let g:terminal_color_8  = '#' . s:ui_fg_dim
  let g:terminal_color_9  = '#' . s:diagnostic_error
  let g:terminal_color_10 = '#' . s:syntax_function
  let g:terminal_color_11 = '#' . s:syntax_type
  let g:terminal_color_12 = '#' . s:syntax_variable
  let g:terminal_color_13 = '#' . s:syntax_number
  let g:terminal_color_14 = '#' . s:syntax_constant
  let g:terminal_color_15 = '#' . s:ui_border_active
endif

" Cleanup
delfunction s:hl
