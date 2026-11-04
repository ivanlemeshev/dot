" Use a line cursor within insert mode and a block cursor everywhere else.
"
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Remap ; to : in normal mode.
nnoremap ; :

" Save the current buffer in normal mode.
nnoremap <leader>w :w<CR>

" Clear search highlighting.
nnoremap <leader>h :nohlsearch<CR>

" Navigate between panes with Ctrl+hjkl.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Override netrw buffer-local mappings so Ctrl+hjkl window navigation still works.
augroup NetrwKeymaps
  autocmd!
  autocmd FileType netrw noremap <buffer> <C-h> <C-w>h
  autocmd FileType netrw noremap <buffer> <C-j> <C-w>j
  autocmd FileType netrw noremap <buffer> <C-k> <C-w>k
  autocmd FileType netrw noremap <buffer> <C-l> <C-w>l
augroup END

" Stay in visual mode after indenting.
vnoremap < <gv
vnoremap > >gv

" Center screen on search and scroll navigation.
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

set notermguicolors
set t_Co=16
set background=dark

" Enable syntax highlighting.
syntax on

" Enable file type detection, plugins, and indentation.
filetype plugin indent on

" Enable line numbers.
set number

" Always show the sign column to prevent text shifting.
set signcolumn=yes

" Enables mouse support in all modes.
set mouse=a

" Disable compatibility with older versions of Vi.
set nocompatible

" Enable automatic indentation.
set autoindent

" Smarter auto-indent for C-like languages.
set smartindent

" Allow the Backspace key to operate more intuitively during text editing,
" enabling the deletion of spaces, line endings, and all text without
" restriction in insert mode.
set backspace=2

" Allow switching buffers without saving.
set hidden

" No beep or screen flash on errors.
set noerrorbells
set novisualbell
set belloff=all

" Disable swap file.
set noswapfile

" Explicit UTF-8 encoding.
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

" Prioritize Unix (LF) line endings for new and edited files, while still
" allowing Vim to read and write files with DOS (CRLF) line endings when
" encountered.
set fileformats=unix,dos

" Better integration between the system clipboard and Vim by using the
" unnamedplus register, which allows you to copy and paste between Vim and
" other applications seamlessly.
set clipboard=unnamedplus

" Ensure that files always end with a newline character.
set fixendofline

" Case-insensitive search, unless uppercase is used.
set ignorecase
set smartcase

" Highlight search matches.
set hlsearch

" Show matches as you type.
set incsearch

" Briefly highlight matching bracket when inserting one.
set showmatch

" Remember more command/search history.
set history=1000

" More undo steps.
set undolevels=1000

" Persistent undo (survives closing the file).
set undofile
set undodir=~/.vim/undodir

" New splits open below and to the right.
set splitbelow
set splitright

" Global default indentation.
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Keep 10 lines visible above and below the cursor when scrolling.
set scrolloff=10

" Always display the status line.
set laststatus=2

" Hide default mode indicator (shown in statusline instead).
set noshowmode

" Show incomplete commands in the bottom right corner.
set showcmd

" Custom statusline (lualine-like).
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

" Hide ~ end-of-buffer filler characters and use line chars for separators.
let &fillchars = 'vert:│,eob: '

" Highlight the current line.
set cursorline

" Faster terminal rendering.
set ttyfast

" Reduce update time (faster CursorHold events).
set updatetime=250

" Faster key sequence timeout.
set timeoutlen=500
set ttimeoutlen=10

" Visual autocomplete menu for commands.
set wildmenu
set wildmode=longest:full,full

" Limit completion menu height.
set pumheight=10

" Automatically read file when changed externally.
set autoread

" Wrap lines without splitting words.
set wrap
set linebreak

" Auto-reload files changed externally.
augroup AutoReload
  autocmd!
  autocmd FocusGained,BufEnter * checktime
augroup END

" Force Unix line endings on save.
augroup ForceUnixLineEndings
  autocmd!
  autocmd BufWritePre * set ff=unix
augroup END

" Remove trailing whitespace on save.
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
highlight LineNr cterm=NONE ctermfg=8 ctermbg=NONE
highlight CursorLine cterm=NONE ctermfg=0 ctermbg=8
highlight CursorLineNr cterm=NONE ctermfg=11 ctermbg=NONE
highlight CursorColumn cterm=NONE ctermfg=0 ctermbg=8
highlight ColorColumn cterm=NONE ctermfg=0 ctermbg=8
highlight SignColumn cterm=NONE ctermfg=7 ctermbg=0
highlight VertSplit cterm=NONE ctermfg=8 ctermbg=0
highlight FoldColumn cterm=NONE ctermfg=8 ctermbg=0
highlight Folded cterm=NONE ctermfg=8 ctermbg=0
highlight Visual cterm=NONE ctermfg=0 ctermbg=8
highlight VisualNOS cterm=NONE ctermfg=0 ctermbg=8
highlight Search cterm=NONE ctermfg=0 ctermbg=11
highlight CurSearch cterm=NONE ctermfg=0 ctermbg=14
highlight IncSearch cterm=NONE ctermfg=0 ctermbg=14
highlight MatchParen cterm=NONE ctermfg=0 ctermbg=6
highlight QuickFixLine cterm=NONE ctermfg=0 ctermbg=8
highlight Pmenu cterm=NONE ctermfg=7 ctermbg=0
highlight PmenuSel cterm=NONE ctermfg=0 ctermbg=8
highlight PmenuSbar cterm=NONE ctermfg=0 ctermbg=0
highlight PmenuThumb cterm=NONE ctermfg=7 ctermbg=7
highlight WildMenu cterm=NONE ctermfg=0 ctermbg=8
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
highlight Title cterm=NONE ctermfg=15 ctermbg=NONE
highlight Directory cterm=NONE ctermfg=4 ctermbg=NONE
highlight ErrorMsg cterm=NONE ctermfg=9 ctermbg=0
highlight WarningMsg cterm=NONE ctermfg=11 ctermbg=0
highlight ModeMsg cterm=NONE ctermfg=7 ctermbg=0
highlight MoreMsg cterm=NONE ctermfg=3 ctermbg=0
highlight Question cterm=NONE ctermfg=4 ctermbg=0
highlight DiffAdd cterm=NONE ctermfg=10 ctermbg=0
highlight DiffChange cterm=NONE ctermfg=14 ctermbg=0
highlight DiffDelete cterm=NONE ctermfg=9 ctermbg=0
highlight DiffText cterm=NONE ctermfg=0 ctermbg=11
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
highlight Macro cterm=NONE ctermfg=13 ctermbg=NONE
highlight PreCondit cterm=NONE ctermfg=1 ctermbg=NONE
highlight Type cterm=NONE ctermfg=4 ctermbg=NONE
highlight StorageClass cterm=NONE ctermfg=3 ctermbg=NONE
highlight Structure cterm=NONE ctermfg=4 ctermbg=NONE
highlight Typedef cterm=NONE ctermfg=4 ctermbg=NONE
highlight Special cterm=NONE ctermfg=3 ctermbg=NONE
highlight SpecialChar cterm=NONE ctermfg=14 ctermbg=NONE
highlight Tag cterm=NONE ctermfg=2 ctermbg=NONE
highlight Delimiter cterm=NONE ctermfg=7 ctermbg=NONE
highlight SpecialComment cterm=NONE ctermfg=8 ctermbg=NONE
highlight Debug cterm=NONE ctermfg=7 ctermbg=NONE
highlight Underlined cterm=underline ctermfg=4 ctermbg=NONE
highlight Error cterm=NONE ctermfg=9 ctermbg=NONE
highlight Todo cterm=NONE ctermfg=11 ctermbg=NONE

highlight netrwMarkFile cterm=NONE ctermfg=0 ctermbg=8
