" vi:syntax=vim

highlight clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'custom'
set background=dark

" ==========================================================================
" GUI color definitions (base16 palette, hex without #)
" ==========================================================================

" base00 - background
let s:gui00        = "181616"
let g:base16_gui00 = "181616"
" base01 - lighter background (cursor line, statusline, pmenu)
let s:gui01        = "282626"
let g:base16_gui01 = "282626"
" base02 - selection / visual background
let s:gui02        = "383636"
let g:base16_gui02 = "383636"
" base03 - comments, line numbers, faded
let s:gui03        = "696a68"
let g:base16_gui03 = "696a68"
" base04 - dark foreground (inactive UI, borders)
let s:gui04        = "777876"
let g:base16_gui04 = "777876"
" base05 - default foreground
let s:gui05        = "c5c9c5"
let g:base16_gui05 = "c5c9c5"
" base06 - light foreground (selected item backgrounds)
let s:gui06        = "c5c9c5"
let g:base16_gui06 = "c5c9c5"
" base07 - bright white
let s:gui07        = "c5c9c5"
let g:base16_gui07 = "c5c9c5"
" base08 - red (errors, diff deleted, keywords: return/if/for)
let s:gui08        = "c4746e"
let g:base16_gui08 = "c4746e"
" base09 - orange (integers, booleans, constants)
let s:gui09        = "c48776"
let g:base16_gui09 = "c48776"
" base0A - yellow (types, search background, operators)
let s:gui0A        = "c4b28a"
let g:base16_gui0A = "c4b28a"
" base0B - green (strings, diff added, success)
let s:gui0B        = "8a9a7b"
let g:base16_gui0B = "8a9a7b"
" base0C - cyan (support, regex, escape characters)
let s:gui0C        = "8ea4a2"
let g:base16_gui0C = "8ea4a2"
" base0D - blue (functions, methods, identifiers)
let s:gui0D        = "8ba4b1"
let g:base16_gui0D = "8ba4b1"
" base0E - magenta (preprocessor, macros, storage keywords)
let s:gui0E        = "a292a3"
let g:base16_gui0E = "a292a3"
" base0F - brown (deprecated, embedded language tags)
let s:gui0F        = "905854"
let g:base16_gui0F = "905854"
" gui_faint - non-printable chars: whitespace, special keys, non-text (barely visible)
let s:gui_faint       = "2c2a2a"
" gui_border - split borders, matches tmux pane border (brightBlack)
let s:gui_border      = "a6a69c"

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

" Public Base16hi for plugin compatibility
function! g:Base16hi(group, guifg, guibg, ...)
  let l:attr = get(a:, 1, '')
  let l:guisp = get(a:, 2, '')
  call s:hl(a:group, a:guifg, a:guibg, l:attr ==# '' ? 'NONE' : l:attr, l:guisp)
endfunction

" ==========================================================================
" UI highlights
" ==========================================================================
call s:hl('Normal',       s:gui05, s:gui00)
call s:hl('NormalNC',     s:gui05, s:gui00)
call s:hl('Terminal',     s:gui05, s:gui00)
call s:hl('EndOfBuffer',  s:gui00, s:gui00)
call s:hl('Folded',       s:gui03, s:gui01)
call s:hl('ToolbarLine',  s:gui05, s:gui01)
call s:hl('SignColumn',   s:gui05, '')
call s:hl('FoldColumn',   s:gui03, '')

call s:hl('IncSearch',    s:gui00, s:gui08)
call s:hl('Search',       s:gui00, s:gui0B)
highlight! link CurSearch IncSearch
call s:hl('ColorColumn',  '',      s:gui01)
call s:hl('Conceal',      s:gui03, '')

call s:hl('Cursor',       '',      '',      'reverse')
highlight! link vCursor   Cursor
highlight! link iCursor   Cursor
highlight! link lCursor   Cursor
highlight! link CursorIM  Cursor

call s:hl('CursorLine',   '',      s:gui01)
call s:hl('CursorColumn', '',      s:gui01)

call s:hl('LineNr',       s:gui03, '')
call s:hl('CursorLineNr', s:gui04, '')

call s:hl('DiffAdd',      s:gui0B, '')
call s:hl('DiffChange',   s:gui0D, '')
call s:hl('DiffDelete',   s:gui08, '')
call s:hl('DiffText',     s:gui00, s:gui0D)

call s:hl('Directory',    s:gui0B, '')
call s:hl('ErrorMsg',     s:gui08, '',      'bold,underline')
call s:hl('WarningMsg',   s:gui0A, '',      'bold')
call s:hl('ModeMsg',      s:gui05, '',      'bold')
call s:hl('MoreMsg',      s:gui0A, '',      'bold')
call s:hl('MatchParen',   '',      s:gui02)
call s:hl('NonText',      s:gui_faint, '')
call s:hl('Whitespace',   s:gui_faint, '')
call s:hl('SpecialKey',   s:gui_faint, '')

" Pmenu
call s:hl('Pmenu',        s:gui05, s:gui01)
call s:hl('PmenuSbar',    '',      s:gui01)
call s:hl('PmenuSel',     s:gui01, s:gui06)
call s:hl('PmenuKind',    s:gui0B, s:gui01)
call s:hl('PmenuExtra',   s:gui06, s:gui01)
highlight! link WildMenu PmenuSel
call s:hl('PmenuThumb',   '',      s:gui04)

call s:hl('Question',     s:gui0A, '')

" Spell
call s:hl('SpellBad',     '',      '',      'undercurl', s:gui08)
call s:hl('SpellCap',     '',      '',      'undercurl', s:gui0D)
call s:hl('SpellLocal',   '',      '',      'undercurl', s:gui0C)
call s:hl('SpellRare',    '',      '',      'undercurl', s:gui0E)

" StatusLine
call s:hl('StatusLine',       s:gui05, s:gui01)
call s:hl('StatusLineTerm',   s:gui05, s:gui01)
call s:hl('StatusLineNC',     s:gui04, s:gui01)
call s:hl('StatusLineTermNC', s:gui04, s:gui01)
call s:hl('TabLine',          s:gui05, s:gui01)
call s:hl('TabLineFill',      s:gui05, s:gui01)
call s:hl('TabLineSel',       s:gui00, s:gui06)

" VertSplit / WinSeparator
call s:hl('VertSplit',    s:gui_border, '')
if exists('+winfixbuf')
  highlight! link WinSeparator VertSplit
endif

" Visual
call s:hl('Visual',       '',      s:gui02)
call s:hl('VisualNOS',    '',      s:gui02)

call s:hl('QuickFixLine', s:gui0E, '',      'bold')
call s:hl('Debug',        s:gui0A, '')
call s:hl('debugPC',      s:gui00, s:gui0B)
call s:hl('debugBreakpoint', s:gui00, s:gui08)
call s:hl('ToolbarButton', s:gui00, s:gui06)
call s:hl('Substitute',   s:gui00, s:gui0A)

" ==========================================================================
" Syntax highlights
" ==========================================================================
call s:hl('Boolean',      s:gui09, '')
call s:hl('Number',       s:gui09, '')
call s:hl('Float',        s:gui09, '')

" italic enabled
call s:hl('PreProc',      s:gui0E, '',      'italic')
call s:hl('PreCondit',    s:gui0E, '',      'italic')
call s:hl('Include',      s:gui0E, '',      'italic')
call s:hl('Define',       s:gui0E, '',      'italic')
call s:hl('Conditional',  s:gui08, '',      'italic')
call s:hl('Repeat',       s:gui08, '',      'italic')
call s:hl('Keyword',      s:gui08, '',      'italic')
call s:hl('Typedef',      s:gui08, '',      'italic')
call s:hl('Exception',    s:gui08, '',      'italic')
call s:hl('Statement',    s:gui08, '',      'italic')

call s:hl('Error',        s:gui08, '')
call s:hl('StorageClass', s:gui0A, '')
call s:hl('Tag',          s:gui0A, '')
call s:hl('Label',        s:gui0A, '')
call s:hl('Structure',    s:gui0A, '')
call s:hl('Operator',     s:gui0A, '')
call s:hl('Title',        s:gui0A, '',      'bold')
call s:hl('Special',      s:gui0A, '')
call s:hl('SpecialChar',  s:gui0A, '')
call s:hl('Type',         s:gui0A, '')

" bold enabled
call s:hl('Function',     s:gui0B, '',      'bold')

call s:hl('String',       s:gui0B, '')
call s:hl('Character',    s:gui0B, '')
call s:hl('Constant',     s:gui0C, '')
call s:hl('Macro',        s:gui0C, '')
call s:hl('Identifier',   s:gui0D, '')

call s:hl('Todo',         s:gui00, s:gui0D, 'bold')

" italic comments
call s:hl('Comment',        s:gui03, '',    'italic')
call s:hl('SpecialComment', s:gui03, '',    'italic')

call s:hl('Delimiter',    s:gui05, '')
call s:hl('Ignore',       s:gui03, '')
call s:hl('Underlined',   '',      '',      'underline')

" ==========================================================================
" Predefined highlight groups
" ==========================================================================
call s:hl('Fg',           s:gui05, '')
call s:hl('Grey',         s:gui04, '')
call s:hl('Red',          s:gui08, '')
call s:hl('Yellow',       s:gui0A, '')
call s:hl('Green',        s:gui0B, '')
call s:hl('Aqua',         s:gui0C, '')
call s:hl('Blue',         s:gui0D, '')
call s:hl('Purple',       s:gui0E, '')

" Italic variants
call s:hl('RedItalic',    s:gui08, '',      'italic')
call s:hl('YellowItalic', s:gui0A, '',      'italic')
call s:hl('GreenItalic',  s:gui0B, '',      'italic')
call s:hl('AquaItalic',   s:gui0C, '',      'italic')
call s:hl('BlueItalic',   s:gui0D, '',      'italic')
call s:hl('PurpleItalic', s:gui0E, '',      'italic')

" Bold variants
call s:hl('RedBold',      s:gui08, '',      'bold')
call s:hl('YellowBold',   s:gui0A, '',      'bold')
call s:hl('GreenBold',    s:gui0B, '',      'bold')
call s:hl('AquaBold',     s:gui0C, '',      'bold')
call s:hl('BlueBold',     s:gui0D, '',      'bold')
call s:hl('PurpleBold',   s:gui0E, '',      'bold')

" Sign variants
call s:hl('RedSign',      s:gui08, '')
call s:hl('YellowSign',   s:gui0A, '')
call s:hl('GreenSign',    s:gui0B, '')
call s:hl('AquaSign',     s:gui0C, '')
call s:hl('BlueSign',     s:gui0D, '')
call s:hl('PurpleSign',   s:gui0E, '')

highlight! link Added   Green
highlight! link Removed Red
highlight! link Changed Blue

" ==========================================================================
" Error/Warning/Info/Hint
" ==========================================================================
call s:hl('ErrorText',    '',      '',      'undercurl', s:gui08)
call s:hl('WarningText',  '',      '',      'undercurl', s:gui0A)
call s:hl('InfoText',     '',      '',      'undercurl', s:gui0D)
call s:hl('HintText',     '',      '',      'undercurl', s:gui0E)

highlight! link VirtualTextWarning Grey
highlight! link VirtualTextError   Grey
highlight! link VirtualTextInfo    Grey
highlight! link VirtualTextHint    Grey

call s:hl('ErrorFloat',   s:gui08, '')
call s:hl('WarningFloat', s:gui0A, '')
call s:hl('InfoFloat',    s:gui0D, '')
call s:hl('HintFloat',    s:gui0E, '')

call s:hl('CurrentWord',  '',      '',      'underline')

highlight! link healthError   Red
highlight! link healthSuccess Green
highlight! link healthWarning Yellow

" ==========================================================================
" Diff
" ==========================================================================
highlight! link diffAdded     Green
highlight! link diffRemoved   Red
highlight! link diffChanged   Blue
highlight! link diffFile      Aqua
highlight! link diffOldFile   Yellow
highlight! link diffNewFile   Yellow
highlight! link diffIndexLine Purple
highlight! link diffLine      Grey

" ==========================================================================
" Filetype: markdown
" ==========================================================================
call s:hl('markdownH1',   s:gui08, '',      'bold')
call s:hl('markdownH2',   s:gui0A, '',      'bold')
call s:hl('markdownH3',   s:gui0A, '',      'bold')
call s:hl('markdownH4',   s:gui0B, '',      'bold')
call s:hl('markdownH5',   s:gui0D, '',      'bold')
call s:hl('markdownH6',   s:gui0E, '',      'bold')
call s:hl('markdownItalic', '',    '',      'italic')
call s:hl('markdownBold', '',      '',      'bold')
call s:hl('markdownItalicDelimiter', s:gui03, '', 'italic')
highlight! link markdownUrl              Underlined
highlight! link markdownCode             Green
highlight! link markdownCodeBlock        Aqua
highlight! link markdownCodeDelimiter    Aqua
highlight! link markdownBlockquote       Grey
highlight! link markdownListMarker       Red
highlight! link markdownOrderedListMarker Red
highlight! link markdownRule             Purple
highlight! link markdownHeadingRule      Grey
highlight! link markdownUrlDelimiter     Grey
highlight! link markdownLinkDelimiter    Grey
highlight! link markdownLinkTextDelimiter Grey
highlight! link markdownHeadingDelimiter Grey
highlight! link markdownLinkText         Purple
highlight! link markdownUrlTitleDelimiter Green
highlight! link markdownIdDeclaration    markdownLinkText
highlight! link markdownBoldDelimiter    Grey
highlight! link markdownId               Yellow

" ==========================================================================
" Filetype: lua
" ==========================================================================
highlight! link luaFunc         GreenBold
highlight! link luaFunction     Aqua
highlight! link luaTable        Fg
highlight! link luaIn           RedItalic
highlight! link luaFuncCall     GreenBold
highlight! link luaLocal        Yellow
highlight! link luaSpecialValue GreenBold
highlight! link luaBraces       Fg
highlight! link luaBuiltIn      Purple
highlight! link luaNoise        Grey
highlight! link luaLabel        Purple
highlight! link luaFuncTable    Yellow
highlight! link luaFuncArgName  Blue
highlight! link luaEllipsis     Yellow
highlight! link luaDocTag       Green

" ==========================================================================
" Filetype: go
" ==========================================================================
highlight! link goPackage              Define
highlight! link goImport               Include
highlight! link goVar                  YellowItalic
highlight! link goConst                goVar
highlight! link goType                 Yellow
highlight! link goSignedInts           goType
highlight! link goUnsignedInts         goType
highlight! link goFloats               goType
highlight! link goComplexes            goType
highlight! link goVarDefs              Aqua
highlight! link goDeclType             YellowItalic
highlight! link goFunctionCall         Function
highlight! link goPredefinedIdentifiers Aqua
highlight! link goBuiltins             GreenBold
highlight! link goVarArgs              Grey

" ==========================================================================
" Statusline mode highlights (lualine-like)
" ==========================================================================
call s:hl('StatusModeNormal',   s:gui00, s:gui06,  'bold')
call s:hl('StatusModeInsert',   s:gui00, s:gui0B,  'bold')
call s:hl('StatusModeVisual',   s:gui00, s:gui09,  'bold')
call s:hl('StatusModeReplace',  s:gui00, s:gui0A,  'bold')
call s:hl('StatusModeCommand',  s:gui00, s:gui0D,  'bold')
call s:hl('StatusModeTerminal', s:gui00, s:gui0E,  'bold')
call s:hl('StatusModeB',        s:gui05, s:gui01)
call s:hl('StatusModeC',        s:gui05, s:gui01)
call s:hl('StatusInactive',     s:gui06, s:gui01)

" ==========================================================================
" Terminal colors
" ==========================================================================
if has('terminal') || has('nvim')
  let g:terminal_color_0  = '#' . s:gui03
  let g:terminal_color_1  = '#' . s:gui08
  let g:terminal_color_2  = '#' . s:gui0B
  let g:terminal_color_3  = '#' . s:gui0A
  let g:terminal_color_4  = '#' . s:gui0D
  let g:terminal_color_5  = '#' . s:gui0E
  let g:terminal_color_6  = '#' . s:gui0C
  let g:terminal_color_7  = '#' . s:gui05
  let g:terminal_color_8  = '#' . s:gui03
  let g:terminal_color_9  = '#' . s:gui08
  let g:terminal_color_10 = '#' . s:gui0B
  let g:terminal_color_11 = '#' . s:gui0A
  let g:terminal_color_12 = '#' . s:gui0D
  let g:terminal_color_13 = '#' . s:gui0E
  let g:terminal_color_14 = '#' . s:gui0C
  let g:terminal_color_15 = '#' . s:gui07
endif

" Cleanup
delfunction s:hl
