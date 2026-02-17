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

" Set leader key.
let mapleader = " "

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

" Stay in visual mode after indenting.
vnoremap < <gv
vnoremap > >gv

" Center screen on search and scroll navigation.
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Enable syntax highlig.
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

" Show tabs, spaces and line endings.
set list
set listchars=eol:\ ,tab:>\ ,space:.,trail:.,nbsp:.

" Explicit UTF-8 encoding.
set encoding=utf-8

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
  let l:s .= '%{&encoding} | %{&filetype} '
  let l:s .= '%#StatusModeB# %l:%c '
  let l:s .= '%#StatusModeNormal# %p%% '
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

" Hide ~ end-of-buffer filler characters and use line chars for window separators.
set fillchars=vert:│,eob:\

" Highlight the current line.
set cursorline

" Enable true color support.
if has('termguicolors')
  set termguicolors
endif

" Add config directory to runtimepath for custom colorscheme.
set runtimepath+=~/.config/vim

" Set colorscheme.
colorscheme custom

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
