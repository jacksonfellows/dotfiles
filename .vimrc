call plug#begin('~/.vim/plugged')

Plug 'kovisoft/slimv'
Plug 'mhinz/vim-signify'
Plug 'michaeljsmith/vim-indent-object'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
Plug 'wellle/targets.vim'

call plug#end()

filetype plugin indent on
syntax on
set relativenumber
set hidden
set showcmd
set backspace=
set incsearch hlsearch
set ignorecase smartcase
set nomodeline

runtime! ftplugin/man.vim

cnoremap <C-a>  <Home>
cnoremap <C-b>  <Left>
cnoremap <C-f>  <Right>
cnoremap <C-d>  <Delete>
cnoremap <M-b>  <S-Left>
cnoremap <M-f>  <S-Right>
cnoremap <M-d>  <S-right><Delete>
cnoremap <Esc>b <S-Left>
cnoremap <Esc>f <S-Right>
cnoremap <Esc>d <S-right><Delete>
cnoremap <C-g>  <C-c>

" set autoread

let mapleader = " "

nnoremap <LEADER>j :ALENextWrap<CR>
nnoremap <LEADER>k :ALEPreviousWrap<CR>

" TODO: better letter?
nnoremap <LEADER>t :noh<CR>

nnoremap <LEADER>ev :edit $MYVIMRC<CR>
nnoremap <LEADER>sv :source $MYVIMRC<CR>

nnoremap <LEADER>sr :SignifyRefresh<CR>

nnoremap <LEADER>n :set number!<CR>

fun! ToggleCC()
	if &colorcolumn == ''
		set colorcolumn=80
	else
		set colorcolumn=
	endif
endfun
nnoremap <LEADER>c :call ToggleCC()<CR>

fun! ToggleGitBlame()
	if !exists("b:git_blame_on")
		let b:git_blame_on = 0
	endif

	if b:git_blame_on
		call sign_unplace(bufname("%"))
		let b:git_blame_on = 0
	else
		write
		let git_blame_command = "(cd " . fnamemodify(bufname("%"), ":p:h") . " && git blame --line-porcelain " . fnamemodify(bufname("%"), ":p") . ")"
		let initials_list = systemlist(git_blame_command . " | perl -w -lnae 'next unless /^author /; shift @F, 1; $initials = join \"\", map { substr $_, 0, 1 } @F; print((length($initials) == 1) ? $initials : ((substr $initials, 0, 1), (substr $initials, -1)));'")
		if has('gui_running')
			let colors_list = systemlist(git_blame_command . " | perl -w -nae 'BEGIN { $oldest = 0; $newest = \"inf\" } next unless /^author-time /; push @times, $F[1]; $oldest = $F[1] if $F[1] > $oldest; $newest = $F[1] if $F[1] < $newest; END { $delta = $newest - $oldest; for $time (@times) { $color = $delta == 0 ? 0xFFFFFF : ((($time - $oldest)/$delta) * 0xFFFFFF); printf \"%06X %06X\n\", $color, (0xFFFFFF - $color) } }'")
		endif
		let line_number = 1
		for initials in initials_list
			if len(initials) <= 2
				let params = {"text": initials, "texthl": "StatusLineTerm"}
				let id = "Blame" . bufnr("%") . "l" . line_number
				if has('gui_running')
					let colorl = split(colors_list[line_number - 1])
					execute "highlight " . id . " guibg=#" . colorl[0] . " guifg=#" . colorl[1]
					let params['linehl'] = id
				endif

				call sign_define(id, params)
				call sign_place(0, bufname("%"), id, bufname("%"), {"lnum": line_number})
			endif
			let line_number += 1
		endfor
		let b:git_blame_on = 1
	endif
endfun

nnoremap <LEADER>b :call ToggleGitBlame()<CR>

inoremap jk <ESC>

nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

nnoremap <Tab>h <C-W>h<C-W>\|
nnoremap <Tab>j <C-W>j<C-W>_
nnoremap <Tab>k <C-W>k<C-W>_
nnoremap <Tab>l <C-W>l<C-W>\|

nnoremap <Tab>= <C-W>=

" TODO: only for Terminal.app

" Mode Settings

let &t_SI.="\e[5 q" "SI = INSERT mode
let &t_SR.="\e[4 q" "SR = REPLACE mode
let &t_EI.="\e[1 q" "EI = NORMAL mode (ELSE)

" Cursor settings:

"  1 -> blinking block
"  2 -> solid block
"  3 -> blinking underscore
"  4 -> solid underscore
"  5 -> blinking vertical bar
"  6 -> solid vertical bar
