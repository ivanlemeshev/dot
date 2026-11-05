" Run with: vim -N -n -i NONE -u .config/vim/.vimrc -es -S tests/vim/ansi_theme.vim
set nomore
call assert_match("a:blinkon0", &guicursor)
call assert_equal("\e[6 q", &t_SI)
call assert_equal("\e[2 q", &t_EI)
call assert_equal("\e[4 q", &t_SR)
call assert_equal(0, &termguicolors)
call assert_equal('16', &t_Co)
call assert_equal('vert:│,eob: ', &fillchars)
let s:used = {}
let s:selections = ['Visual', 'VisualNOS', 'QuickFixLine', 'PmenuSel', 'WildMenu', 'netrwMarkFile']
for s:sample in glob('tests/fixtures/syntax/*', 0, 1)
  execute 'edit ' . fnameescape(s:sample)
  for s:group in getcompletion('', 'highlight')
    for s:attr in ['fg', 'bg']
      let s:resolved = synIDtrans(hlID(s:group))
      let s:color = synIDattr(s:resolved, s:attr, 'cterm')
      if s:color =~# '^\d\+$'
        call assert_true(str2nr(s:color) <= 15, s:sample . ': ' . s:group . ' uses ' . s:color)
        let s:used[s:color] = 1
      endif
    endfor
  endfor
endfor
call assert_equal(16, len(s:used))
call assert_true(&cursorline)
call assert_equal("number", &cursorlineopt)
call assert_equal('', synIDattr(hlID('CursorLine'), 'fg', 'cterm'))
call assert_equal('', synIDattr(hlID('CursorLine'), 'bg', 'cterm'))
call assert_equal('11', synIDattr(hlID('CursorLineNr'), 'fg', 'cterm'))
call assert_equal('1', synIDattr(hlID('CursorLineNr'), 'bold', 'cterm'))
call assert_equal('', synIDattr(hlID('CursorLineNr'), 'bg', 'cterm'))
call assert_equal('3', synIDattr(hlID('StatusModeNormal'), 'fg', 'cterm'))
call assert_equal('2', synIDattr(hlID('StatusModeInsert'), 'fg', 'cterm'))
call assert_equal('0', synIDattr(hlID('StatusModeNormal'), 'bg', 'cterm'))
call assert_false(ActiveStatusline() =~# '|')
for s:group in s:selections
  call assert_equal('0', synIDattr(hlID(s:group), 'fg', 'cterm'))
  call assert_equal('4', synIDattr(hlID(s:group), 'bg', 'cterm'))
endfor
source .config/vim/.vimrc
call assert_true(&cursorline)
call assert_equal("number", &cursorlineopt)
call assert_equal('16', &t_Co)
call assert_equal('0', synIDattr(hlID('StatusModeNormal'), 'bg', 'cterm'))
if !empty(v:errors)
  for s:error in v:errors
    echoerr s:error
  endfor
  cquit
endif
qa!
