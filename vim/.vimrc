" NOTE: DECSCUSR values 2, 4, and 6 select steady block, underline, and bar cursors.
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
let &t_SR = "\e[4 q"
set guicursor+=a:blinkon0

nnoremap ; :

nnoremap <leader>w :w<CR>

nnoremap <leader>h :nohlsearch<CR>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" NOTE: netrw replaces window navigation mappings in its buffers.
augroup NetrwKeymaps
  autocmd!
  autocmd FileType netrw noremap <buffer> <C-h> <C-w>h
  autocmd FileType netrw noremap <buffer> <C-j> <C-w>j
  autocmd FileType netrw noremap <buffer> <C-k> <C-w>k
  autocmd FileType netrw noremap <buffer> <C-l> <C-w>l
augroup END

vnoremap < <gv
vnoremap > >gv

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

set notermguicolors
set t_Co=16
set background=dark

syntax on

filetype plugin indent on

set number

" NOTE: A fixed sign column prevents text movement when signs appear.
set signcolumn=yes

set mouse=a

set nocompatible

set autoindent

set smartindent

" Allow Backspace across indentation, line breaks, and the insertion start.
set backspace=2

set hidden

set noerrorbells
set novisualbell
set belloff=all

set noswapfile

set encoding=utf-8

set list
set listchars=tab:▸\ ,trail:·,nbsp:␣

function! s:ToggleWhitespace() abort
  if &listchars =~# '\(^\|,\)space:·\($\|,\)'
    setlocal listchars-=space:·
  else
    setlocal listchars+=space:·
  endif
  setlocal list
endfunction

nnoremap <silent> <leader>tw :call <SID>ToggleWhitespace()<CR>

" NOTE: DOS detection lets Vim read CRLF files.
set fileformats=unix,dos

" Use the system clipboard for unnamed copy and paste operations.
set clipboard=unnamedplus

set fixendofline

set ignorecase
set smartcase

set hlsearch

set incsearch

set showmatch

set history=1000

set undolevels=1000

set undofile
set undodir=~/.vim/undodir

set splitbelow
set splitright

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set scrolloff=10

set laststatus=2

" NOTE: The status line shows the current mode.
set noshowmode

set showcmd

function! StatuslineMode() abort
  let l:mode = mode()
  if l:mode ==# 'n'
    return '%#StatusModeNormal#  NORMAL '
  elseif l:mode ==# 'i'
    return '%#StatusModeInsert#  INSERT '
  elseif l:mode ==# 'v' || l:mode ==# 'V' || l:mode ==# "\<C-v>"
    return '%#StatusModeVisual#  VISUAL '
  elseif l:mode ==# 'R'
    return '%#StatusModeReplace#  REPLACE '
  elseif l:mode ==# 'c'
    return '%#StatusModeCommand#  COMMAND '
  elseif l:mode ==# 't'
    return '%#StatusModeTerminal#  TERMINAL '
  else
    return '%#StatusModeNormal#  ' . toupper(l:mode) . ' '
  endif
endfunction

function! ActiveStatusline() abort
  let l:s = StatuslineMode()
  let l:s .= '%#StatusModeC# '
  let l:s .= '%f %m'
  let l:s .= '%='
  let l:s .= '%{&encoding}  %{&filetype} '
  let l:s .= '%#StatusModeB# %l:%c '
  let l:s .= '%#StatusModeC# %p%% '
  return l:s
endfunction

function! InactiveStatusline() abort
  return '%#StatusInactive# %f %m%= %l:%c '
endfunction

augroup Statusline
  autocmd!
  autocmd WinEnter,BufEnter * setlocal statusline=%!ActiveStatusline()
  autocmd WinLeave,BufLeave * setlocal statusline=%!InactiveStatusline()
augroup END

let &fillchars = 'vert:│,eob: '

set cursorline
set cursorlineopt=number

set ttyfast

set updatetime=250

set timeoutlen=500
set ttimeoutlen=10

set wildmenu
set wildmode=longest:full,full

set pumheight=10

set autoread

set wrap
set linebreak

augroup AutoReload
  autocmd!
  autocmd FocusGained,BufEnter * checktime
augroup END

augroup ForceUnixLineEndings
  autocmd!
  autocmd BufWritePre * set ff=unix
augroup END

augroup RemoveTrailingSpaces
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
augroup END

" NOTE: Numeric colors use the terminal ANSI palette.
highlight Normal cterm=NONE ctermfg=7 ctermbg=0
highlight NonText cterm=NONE ctermfg=8 ctermbg=NONE
highlight EndOfBuffer cterm=NONE ctermfg=8 ctermbg=NONE
highlight SpecialKey cterm=NONE ctermfg=8 ctermbg=NONE
highlight Whitespace cterm=NONE ctermfg=8 ctermbg=NONE
highlight Conceal cterm=NONE ctermfg=7 ctermbg=0
highlight Ignore cterm=NONE ctermfg=7 ctermbg=0
highlight ToolbarButton cterm=NONE ctermfg=0 ctermbg=4
highlight LineNr cterm=NONE ctermfg=8 ctermbg=NONE
highlight CursorLine cterm=NONE ctermfg=NONE ctermbg=NONE
highlight CursorLineNr cterm=NONE ctermfg=3 ctermbg=NONE
highlight CursorColumn cterm=NONE ctermfg=7 ctermbg=0
highlight ColorColumn cterm=NONE ctermfg=7 ctermbg=0
highlight SignColumn cterm=NONE ctermfg=7 ctermbg=0
highlight VertSplit cterm=NONE ctermfg=8 ctermbg=0
highlight FoldColumn cterm=NONE ctermfg=8 ctermbg=0
highlight Folded cterm=NONE ctermfg=7 ctermbg=0
highlight Visual cterm=NONE ctermfg=0 ctermbg=4
highlight VisualNOS cterm=NONE ctermfg=0 ctermbg=4
highlight Search cterm=NONE ctermfg=0 ctermbg=3
highlight CurSearch cterm=NONE ctermfg=0 ctermbg=6
highlight IncSearch cterm=NONE ctermfg=0 ctermbg=6
highlight MatchParen cterm=NONE ctermfg=0 ctermbg=6
highlight QuickFixLine cterm=NONE ctermfg=0 ctermbg=4
highlight Pmenu cterm=NONE ctermfg=7 ctermbg=0
highlight PmenuSel cterm=NONE ctermfg=0 ctermbg=4
highlight PmenuSbar cterm=NONE ctermfg=0 ctermbg=0
highlight PmenuThumb cterm=NONE ctermfg=7 ctermbg=0
highlight WildMenu cterm=NONE ctermfg=0 ctermbg=4
highlight StatusLine cterm=NONE ctermfg=7 ctermbg=0
highlight StatusLineNC cterm=NONE ctermfg=8 ctermbg=0
highlight StatusLineTerm cterm=NONE ctermfg=7 ctermbg=0
highlight StatusLineTermNC cterm=NONE ctermfg=8 ctermbg=0
highlight StatusModeNormal cterm=NONE ctermfg=3 ctermbg=0
highlight StatusModeInsert cterm=NONE ctermfg=2 ctermbg=0
highlight StatusModeVisual cterm=NONE ctermfg=5 ctermbg=0
highlight StatusModeReplace cterm=NONE ctermfg=1 ctermbg=0
highlight StatusModeCommand cterm=NONE ctermfg=6 ctermbg=0
highlight StatusModeTerminal cterm=NONE ctermfg=4 ctermbg=0
highlight StatusModeB cterm=NONE ctermfg=7 ctermbg=0
highlight StatusModeC cterm=NONE ctermfg=7 ctermbg=0
highlight StatusInactive cterm=NONE ctermfg=8 ctermbg=0
highlight TabLine cterm=NONE ctermfg=8 ctermbg=0
highlight TabLineSel cterm=NONE ctermfg=3 ctermbg=0
highlight TabLineFill cterm=NONE ctermfg=8 ctermbg=0
highlight Title cterm=NONE ctermfg=3 ctermbg=NONE
highlight Directory cterm=NONE ctermfg=4 ctermbg=NONE
highlight ErrorMsg cterm=NONE ctermfg=9 ctermbg=0
highlight WarningMsg cterm=NONE ctermfg=11 ctermbg=0
highlight ModeMsg cterm=NONE ctermfg=7 ctermbg=0
highlight MoreMsg cterm=NONE ctermfg=3 ctermbg=0
highlight Question cterm=NONE ctermfg=4 ctermbg=0
highlight DiffAdd cterm=NONE ctermfg=2 ctermbg=0
highlight DiffChange cterm=NONE ctermfg=3 ctermbg=0
highlight DiffDelete cterm=NONE ctermfg=1 ctermbg=0
highlight DiffText cterm=NONE ctermfg=0 ctermbg=3
highlight SpellBad cterm=undercurl ctermfg=NONE ctermbg=NONE
highlight SpellCap cterm=undercurl ctermfg=NONE ctermbg=NONE
highlight SpellLocal cterm=undercurl ctermfg=NONE ctermbg=NONE
highlight SpellRare cterm=undercurl ctermfg=NONE ctermbg=NONE
highlight Comment cterm=NONE ctermfg=8 ctermbg=NONE
highlight Constant cterm=NONE ctermfg=5 ctermbg=NONE
highlight String cterm=NONE ctermfg=2 ctermbg=NONE
highlight Character cterm=NONE ctermfg=2 ctermbg=NONE
highlight Number cterm=NONE ctermfg=5 ctermbg=NONE
highlight Boolean cterm=NONE ctermfg=5 ctermbg=NONE
highlight Float cterm=NONE ctermfg=5 ctermbg=NONE
highlight Identifier cterm=NONE ctermfg=7 ctermbg=NONE
highlight Function cterm=NONE ctermfg=3 ctermbg=NONE
highlight Statement cterm=NONE ctermfg=1 ctermbg=NONE
highlight Conditional cterm=NONE ctermfg=1 ctermbg=NONE
highlight Repeat cterm=NONE ctermfg=1 ctermbg=NONE
highlight Label cterm=NONE ctermfg=3 ctermbg=NONE
highlight Operator cterm=NONE ctermfg=6 ctermbg=NONE
highlight Keyword cterm=NONE ctermfg=1 ctermbg=NONE
highlight Exception cterm=NONE ctermfg=1 ctermbg=NONE
highlight PreProc cterm=NONE ctermfg=1 ctermbg=NONE
highlight Include cterm=NONE ctermfg=1 ctermbg=NONE
highlight Define cterm=NONE ctermfg=1 ctermbg=NONE
highlight Macro cterm=NONE ctermfg=5 ctermbg=NONE
highlight PreCondit cterm=NONE ctermfg=1 ctermbg=NONE
highlight Type cterm=NONE ctermfg=4 ctermbg=NONE
highlight StorageClass cterm=NONE ctermfg=3 ctermbg=NONE
highlight Structure cterm=NONE ctermfg=4 ctermbg=NONE
highlight Typedef cterm=NONE ctermfg=4 ctermbg=NONE
highlight Special cterm=NONE ctermfg=3 ctermbg=NONE
highlight SpecialChar cterm=NONE ctermfg=6 ctermbg=NONE
highlight Tag cterm=NONE ctermfg=2 ctermbg=NONE
highlight Delimiter cterm=NONE ctermfg=7 ctermbg=NONE
highlight SpecialComment cterm=NONE ctermfg=8 ctermbg=NONE
highlight Debug cterm=NONE ctermfg=7 ctermbg=NONE
highlight Underlined cterm=underline ctermfg=4 ctermbg=NONE
highlight Error cterm=NONE ctermfg=9 ctermbg=NONE
highlight Todo cterm=NONE ctermfg=11 ctermbg=NONE

highlight netrwMarkFile cterm=NONE ctermfg=0 ctermbg=4
