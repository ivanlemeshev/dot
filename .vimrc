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

" Enable syntax highlig.
syntax on

" Enable file type detection, plugins, and indentation.
filetype plugin indent on

" Enable line numbers.
set number

" Enables mouse support in all modes.
set mouse=a

" Disable compatability with older versions of Vi.
set nocompatible

" Enable automatic indentation.
set autoindent

" Allow the Backspace key to operate more intuitively during text editing,
" enabling the deletion of spaces, line endings, and all text without
" restriction in insert mode.
set backspace=2

" Disable swap file.
set noswapfile

" Show tabs, spaces and line endings.
set list
set listchars=eol:¬,tab:→\ ,space:·

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

" Remove trailing whitespace on save.
augroup RemoveTrailingSpaces
  autocmd!
  autocmd BufWritePre * :%s/\s\+$//e
augroup END
