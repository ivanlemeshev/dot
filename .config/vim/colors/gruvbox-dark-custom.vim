" Gruvbox Dark Custom colorscheme for Vim (no external dependency)

highlight clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'gruvbox-dark-custom'
set background=dark

" Palette: dark / warm / material (tuned for eye comfort)
let s:bg_dim          = '#1d1a19'
let s:bg0             = '#292524'
let s:bg1             = '#373230'
let s:bg2             = '#3a3735'
let s:bg3             = '#4a4541'
let s:bg4             = '#4a4541'
let s:bg5             = '#6b6258'
let s:bg_statusline1  = '#322e2c'
let s:bg_statusline2  = '#3c3835'
let s:bg_statusline3  = '#534d47'
let s:bg_visual_red   = '#4c3432'
let s:bg_visual_yellow = '#4f422e'
let s:bg_visual_green = '#3b4439'
let s:bg_visual_blue  = '#374141'
let s:bg_visual_purple = '#443840'
let s:bg_diff_red     = '#402120'
let s:bg_diff_green   = '#34381b'
let s:bg_diff_blue    = '#0e363e'
let s:bg_current_word = '#3e3633'
let s:fg0             = '#d4be98'
let s:fg1             = '#ddc7a1'
let s:red             = '#db6b65'
let s:orange          = '#d48b58'
let s:yellow          = '#cfa45e'
let s:green           = '#9fb26a'
let s:aqua            = '#89b482'
let s:blue            = '#7daea3'
let s:purple          = '#c78a96'
let s:bg_red          = '#db6b65'
let s:bg_green        = '#9fb26a'
let s:bg_yellow       = '#cfa45e'
let s:grey0           = '#7c6f64'
let s:grey1           = '#9d8e7e'
let s:grey2           = '#a89984'

" Helper
function! s:hl(group, fg, bg, ...)
  let l:attrs = a:0 > 0 ? a:1 : 'NONE'
  let l:sp = a:0 > 1 ? a:2 : ''
  execute 'highlight ' . a:group
    \ . ' guifg=' . (a:fg ==# '' ? 'NONE' : a:fg)
    \ . ' guibg=' . (a:bg ==# '' ? 'NONE' : a:bg)
    \ . ' gui=' . l:attrs
    \ . (l:sp !=# '' ? ' guisp=' . l:sp : '')
endfunction

" ==========================================================================
" UI highlights
" ==========================================================================
call s:hl('Normal',       s:fg0,    s:bg0)
call s:hl('NormalNC',     s:fg0,    s:bg0)
call s:hl('Terminal',     s:fg0,    s:bg0)
call s:hl('EndOfBuffer',  s:bg0,    s:bg0)
call s:hl('Folded',       s:grey1,  s:bg2)
call s:hl('ToolbarLine',  s:fg1,    s:bg3)
call s:hl('SignColumn',   s:fg0,    '')
call s:hl('FoldColumn',   s:bg5,    '')

call s:hl('IncSearch',    s:bg0,    s:bg_red)
call s:hl('Search',       s:bg0,    s:bg_green)
highlight! link CurSearch IncSearch
call s:hl('ColorColumn',  '',       s:bg2)
call s:hl('Conceal',      s:bg5,    '')

call s:hl('Cursor',       '',       '',       'reverse')
highlight! link vCursor Cursor
highlight! link iCursor Cursor
highlight! link lCursor Cursor
highlight! link CursorIM Cursor

call s:hl('CursorLine',   '',       s:bg1)
call s:hl('CursorColumn', '',       s:bg1)

call s:hl('LineNr',       s:bg5,    '')
call s:hl('CursorLineNr', s:grey1,  '')

call s:hl('DiffAdd',      '',       s:bg_diff_green)
call s:hl('DiffChange',   '',       s:bg_diff_blue)
call s:hl('DiffDelete',   '',       s:bg_diff_red)
call s:hl('DiffText',     s:bg0,    s:blue)

call s:hl('Directory',    s:green,  '')
call s:hl('ErrorMsg',     s:red,    '',       'bold,underline')
call s:hl('WarningMsg',   s:yellow, '',       'bold')
call s:hl('ModeMsg',      s:fg0,    '',       'bold')
call s:hl('MoreMsg',      s:yellow, '',       'bold')
call s:hl('MatchParen',   '',       s:bg4)
call s:hl('NonText',      s:bg5,    '')
call s:hl('Whitespace',   s:bg5,    '')
call s:hl('SpecialKey',   s:orange, '')

" Pmenu
call s:hl('Pmenu',        s:fg1,    s:bg3)
call s:hl('PmenuSbar',    '',       s:bg3)
call s:hl('PmenuSel',     s:bg3,    s:grey2)
call s:hl('PmenuKind',    s:green,  s:bg3)
call s:hl('PmenuExtra',   s:grey2,  s:bg3)
highlight! link WildMenu PmenuSel
call s:hl('PmenuThumb',   '',       s:grey0)

call s:hl('Question',     s:yellow, '')

" Spell
call s:hl('SpellBad',     '',       '',       'undercurl', s:red)
call s:hl('SpellCap',     '',       '',       'undercurl', s:blue)
call s:hl('SpellLocal',   '',       '',       'undercurl', s:aqua)
call s:hl('SpellRare',    '',       '',       'undercurl', s:purple)

" StatusLine
call s:hl('StatusLine',       s:fg1,   s:bg_statusline1)
call s:hl('StatusLineTerm',   s:fg1,   s:bg_statusline1)
call s:hl('StatusLineNC',     s:grey1, s:bg_statusline1)
call s:hl('StatusLineTermNC', s:grey1, s:bg_statusline1)
call s:hl('TabLine',          s:fg1,   s:bg_statusline3)
call s:hl('TabLineFill',      s:fg1,   s:bg_statusline1)
call s:hl('TabLineSel',       s:bg0,   s:grey2)

" VertSplit / WinSeparator
call s:hl('VertSplit',    s:grey0,  '')
if exists('+winfixbuf')
  highlight! link WinSeparator VertSplit
endif

" Visual
call s:hl('Visual',       '',       s:bg3)
call s:hl('VisualNOS',    '',       s:bg3)

call s:hl('QuickFixLine', s:purple, '',       'bold')
call s:hl('Debug',        s:orange, '')
call s:hl('debugPC',      s:bg0,    s:green)
call s:hl('debugBreakpoint', s:bg0, s:red)
call s:hl('ToolbarButton', s:bg0,   s:grey2)
call s:hl('Substitute',   s:bg0,    s:yellow)

" ==========================================================================
" Syntax highlights
" ==========================================================================
call s:hl('Boolean',      s:purple, '')
call s:hl('Number',       s:purple, '')
call s:hl('Float',        s:purple, '')

" italic enabled
call s:hl('PreProc',      s:purple, '',       'italic')
call s:hl('PreCondit',    s:purple, '',       'italic')
call s:hl('Include',      s:purple, '',       'italic')
call s:hl('Define',       s:purple, '',       'italic')
call s:hl('Conditional',  s:red,    '',       'italic')
call s:hl('Repeat',       s:red,    '',       'italic')
call s:hl('Keyword',      s:red,    '',       'italic')
call s:hl('Typedef',      s:red,    '',       'italic')
call s:hl('Exception',    s:red,    '',       'italic')
call s:hl('Statement',    s:red,    '',       'italic')

call s:hl('Error',        s:red,    '')
call s:hl('StorageClass', s:orange, '')
call s:hl('Tag',          s:orange, '')
call s:hl('Label',        s:orange, '')
call s:hl('Structure',    s:orange, '')
call s:hl('Operator',     s:orange, '')
call s:hl('Title',        s:orange, '',       'bold')
call s:hl('Special',      s:yellow, '')
call s:hl('SpecialChar',  s:yellow, '')
call s:hl('Type',         s:yellow, '')

" bold enabled
call s:hl('Function',     s:green,  '',       'bold')

call s:hl('String',       s:green,  '')
call s:hl('Character',    s:green,  '')
call s:hl('Constant',     s:aqua,   '')
call s:hl('Macro',        s:aqua,   '')
call s:hl('Identifier',   s:blue,   '')

call s:hl('Todo',         s:bg0,    s:blue,   'bold')

" italic comments
call s:hl('Comment',        s:grey1, '',      'italic')
call s:hl('SpecialComment', s:grey1, '',      'italic')

call s:hl('Delimiter',    s:fg0,    '')
call s:hl('Ignore',       s:grey1,  '')
call s:hl('Underlined',   '',       '',       'underline')

" ==========================================================================
" Predefined highlight groups
" ==========================================================================
call s:hl('Fg',           s:fg0,    '')
call s:hl('Grey',         s:grey1,  '')
call s:hl('Red',          s:red,    '')
call s:hl('Orange',       s:orange, '')
call s:hl('Yellow',       s:yellow, '')
call s:hl('Green',        s:green,  '')
call s:hl('Aqua',         s:aqua,   '')
call s:hl('Blue',         s:blue,   '')
call s:hl('Purple',       s:purple, '')

" Italic variants
call s:hl('RedItalic',    s:red,    '',       'italic')
call s:hl('OrangeItalic', s:orange, '',       'italic')
call s:hl('YellowItalic', s:yellow, '',       'italic')
call s:hl('GreenItalic',  s:green,  '',       'italic')
call s:hl('AquaItalic',   s:aqua,   '',       'italic')
call s:hl('BlueItalic',   s:blue,   '',       'italic')
call s:hl('PurpleItalic', s:purple, '',       'italic')

" Bold variants
call s:hl('RedBold',      s:red,    '',       'bold')
call s:hl('OrangeBold',   s:orange, '',       'bold')
call s:hl('YellowBold',   s:yellow, '',       'bold')
call s:hl('GreenBold',    s:green,  '',       'bold')
call s:hl('AquaBold',     s:aqua,   '',       'bold')
call s:hl('BlueBold',     s:blue,   '',       'bold')
call s:hl('PurpleBold',   s:purple, '',       'bold')

" Sign variants
call s:hl('RedSign',      s:red,    '')
call s:hl('OrangeSign',   s:orange, '')
call s:hl('YellowSign',   s:yellow, '')
call s:hl('GreenSign',    s:green,  '')
call s:hl('AquaSign',     s:aqua,   '')
call s:hl('BlueSign',     s:blue,   '')
call s:hl('PurpleSign',   s:purple, '')

highlight! link Added Green
highlight! link Removed Red
highlight! link Changed Blue

" ==========================================================================
" Error/Warning/Info/Hint
" ==========================================================================
call s:hl('ErrorText',    '',       '',       'undercurl', s:red)
call s:hl('WarningText',  '',       '',       'undercurl', s:yellow)
call s:hl('InfoText',     '',       '',       'undercurl', s:blue)
call s:hl('HintText',     '',       '',       'undercurl', s:purple)

highlight! link VirtualTextWarning Grey
highlight! link VirtualTextError Grey
highlight! link VirtualTextInfo Grey
highlight! link VirtualTextHint Grey

call s:hl('ErrorFloat',   s:red,    '')
call s:hl('WarningFloat', s:yellow, '')
call s:hl('InfoFloat',    s:blue,   '')
call s:hl('HintFloat',    s:purple, '')

call s:hl('CurrentWord',  '',       s:bg_current_word)

highlight! link healthError Red
highlight! link healthSuccess Green
highlight! link healthWarning Yellow

" ==========================================================================
" Diff
" ==========================================================================
highlight! link diffAdded Green
highlight! link diffRemoved Red
highlight! link diffChanged Blue
highlight! link diffFile Aqua
highlight! link diffOldFile Orange
highlight! link diffNewFile Yellow
highlight! link diffIndexLine Purple
highlight! link diffLine Grey

" ==========================================================================
" Filetype: markdown
" ==========================================================================
call s:hl('markdownH1',   s:red,    '',       'bold')
call s:hl('markdownH2',   s:orange, '',       'bold')
call s:hl('markdownH3',   s:yellow, '',       'bold')
call s:hl('markdownH4',   s:green,  '',       'bold')
call s:hl('markdownH5',   s:blue,   '',       'bold')
call s:hl('markdownH6',   s:purple, '',       'bold')
call s:hl('markdownItalic', '',     '',       'italic')
call s:hl('markdownBold', '',       '',       'bold')
call s:hl('markdownItalicDelimiter', s:grey1, '', 'italic')
highlight! link markdownUrl Underlined
highlight! link markdownCode Green
highlight! link markdownCodeBlock Aqua
highlight! link markdownCodeDelimiter Aqua
highlight! link markdownBlockquote Grey
highlight! link markdownListMarker Red
highlight! link markdownOrderedListMarker Red
highlight! link markdownRule Purple
highlight! link markdownHeadingRule Grey
highlight! link markdownUrlDelimiter Grey
highlight! link markdownLinkDelimiter Grey
highlight! link markdownLinkTextDelimiter Grey
highlight! link markdownHeadingDelimiter Grey
highlight! link markdownLinkText Purple
highlight! link markdownUrlTitleDelimiter Green
highlight! link markdownIdDeclaration markdownLinkText
highlight! link markdownBoldDelimiter Grey
highlight! link markdownId Yellow

" ==========================================================================
" Filetype: lua
" ==========================================================================
highlight! link luaFunc GreenBold
highlight! link luaFunction Aqua
highlight! link luaTable Fg
highlight! link luaIn RedItalic
highlight! link luaFuncCall GreenBold
highlight! link luaLocal Orange
highlight! link luaSpecialValue GreenBold
highlight! link luaBraces Fg
highlight! link luaBuiltIn Purple
highlight! link luaNoise Grey
highlight! link luaLabel Purple
highlight! link luaFuncTable Yellow
highlight! link luaFuncArgName Blue
highlight! link luaEllipsis Orange
highlight! link luaDocTag Green

" ==========================================================================
" Filetype: go
" ==========================================================================
highlight! link goPackage Define
highlight! link goImport Include
highlight! link goVar OrangeItalic
highlight! link goConst goVar
highlight! link goType Yellow
highlight! link goSignedInts goType
highlight! link goUnsignedInts goType
highlight! link goFloats goType
highlight! link goComplexes goType
highlight! link goVarDefs Aqua
highlight! link goDeclType OrangeItalic
highlight! link goFunctionCall Function
highlight! link goPredefinedIdentifiers Aqua
highlight! link goBuiltins GreenBold
highlight! link goVarArgs Grey

" ==========================================================================
" Statusline mode highlights (lualine-like)
" ==========================================================================
call s:hl('StatusModeNormal',  s:bg0, s:grey2,     'bold')
call s:hl('StatusModeInsert',  s:bg0, s:bg_green,   'bold')
call s:hl('StatusModeVisual',  s:bg0, s:bg_red,     'bold')
call s:hl('StatusModeReplace', s:bg0, s:bg_yellow,  'bold')
call s:hl('StatusModeCommand', s:bg0, s:blue,       'bold')
call s:hl('StatusModeTerminal', s:bg0, s:purple,    'bold')
call s:hl('StatusModeB',       s:fg1, s:bg_statusline3)
call s:hl('StatusModeC',       s:fg1, s:bg_statusline1)
call s:hl('StatusInactive',    s:grey2, s:bg_statusline1)

" ==========================================================================
" Terminal colors
" ==========================================================================
if has('terminal') || has('nvim')
  let g:terminal_color_0  = s:bg5
  let g:terminal_color_1  = s:red
  let g:terminal_color_2  = s:green
  let g:terminal_color_3  = s:yellow
  let g:terminal_color_4  = s:blue
  let g:terminal_color_5  = s:purple
  let g:terminal_color_6  = s:aqua
  let g:terminal_color_7  = s:fg0
  let g:terminal_color_8  = s:bg5
  let g:terminal_color_9  = s:red
  let g:terminal_color_10 = s:green
  let g:terminal_color_11 = s:yellow
  let g:terminal_color_12 = s:blue
  let g:terminal_color_13 = s:purple
  let g:terminal_color_14 = s:aqua
  let g:terminal_color_15 = s:fg0
endif

" Cleanup
delfunction s:hl
