" Run with: vim -N -n -i NONE -u .config/vim/.vimrc -es -S tests/vim/ansi_theme.vim
set nomore
call assert_equal(0, &termguicolors)
call assert_equal('16', &t_Co)
call assert_equal('vert:│,eob: ', &fillchars)
let s:used = {}
let s:selections = ['CursorLine', 'Visual', 'VisualNOS', 'QuickFixLine', 'PmenuSel', 'WildMenu', 'netrwMarkFile']
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
call assert_equal('0', synIDattr(hlID('CursorLine'), 'fg', 'cterm'))
call assert_equal('8', synIDattr(hlID('CursorLine'), 'bg', 'cterm'))
call assert_equal('3', synIDattr(hlID('StatusModeNormal'), 'fg', 'cterm'))
call assert_equal('2', synIDattr(hlID('StatusModeInsert'), 'fg', 'cterm'))
call assert_equal('0', synIDattr(hlID('StatusModeNormal'), 'bg', 'cterm'))
call assert_false(ActiveStatusline() =~# '|')
for s:group in s:selections
  call assert_equal('0', synIDattr(hlID(s:group), 'fg', 'cterm'))
  call assert_equal('8', synIDattr(hlID(s:group), 'bg', 'cterm'))
endfor
source .config/vim/.vimrc
call assert_equal('16', &t_Co)
call assert_equal('0', synIDattr(hlID('StatusModeNormal'), 'bg', 'cterm'))
if !empty(v:errors)
  for s:error in v:errors
    echoerr s:error
  endfor
  cquit
endif
qa!
