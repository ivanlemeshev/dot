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

" Disable swap file.
set noswapfile

" Show tabs, spaces and line endings.
set list
set listchars=tab:→\ ,space:·

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

" Show cursor position in the status line.
set ruler

" Show incomplete commands in the bottom right corner.
set showcmd

" Highlight the current line.
set cursorline

" Enable true color support.
if has('termguicolors')
  set termguicolors
endif

" Gruvbox Material configuration
" Available values: 'hard', 'medium', 'soft'
let g:gruvbox_material_background = 'medium'
" Available values: 'material', 'mix', 'original'
let g:gruvbox_material_foreground = 'material'
let g:gruvbox_material_enable_italic = 1
let g:gruvbox_material_enable_bold = 1
let g:gruvbox_material_transparent_background = 0
let g:gruvbox_material_better_performance = 1

" Set colorscheme.
colorscheme gruvbox-material

" Catppuccin colorscheme (commented out)
" colorscheme catppuccin_mocha

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
