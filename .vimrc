call plug#begin('~/.vim/plugged')

Plug 'w0rp/ale'
Plug 'tpope/vim-surround'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-commentary'

call plug#end()

filetype plugin indent on
syntax on
set hidden
set backspace=indent,eol,start
set incsearch hlsearch
set ignorecase smartcase

let mapleader = " "

nnoremap <LEADER>t :set hlsearch!<CR>

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
		let g:signs = {}
		let initials_list = systemlist("git blame --line-porcelain " . bufname("%") . " | perl -nae 'shift @F, 1; @F = join \"\", map { substr $_, 0, 1 } @F; print \"@F\n\" if /^author /'")
		let line_number = 1
		for initials in initials_list
			if len(initials) <= 2
				if !has_key(g:signs, initials)
					let g:signs[initials] = sign_define(initials, {"text": initials, "texthl": "StatusLineTerm"})
				endif
				call sign_place(0, bufname("%"), initials, bufname("%"), {"lnum": line_number})
			endif
			let line_number += 1
		endfor
		let b:git_blame_on = 1
	endif
endfun

nnoremap <LEADER>b :call ToggleGitBlame()<CR>

inoremap jk <ESC>
tnoremap jk <ESC>

nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

tnoremap <C-h> <C-W>h
tnoremap <C-j> <C-W>j
tnoremap <C-k> <C-W>k
tnoremap <C-l> <C-W>l

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

