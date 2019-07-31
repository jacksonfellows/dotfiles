call plug#begin('~/.vim/plugged')

Plug 'w0rp/ale'
Plug 'tpope/vim-surround'
Plug 'mhinz/vim-signify'
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'

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
		unlet b:signs
		let b:git_blame_on = 0
	else
		write
		let b:signs = {}
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

				let b:signs[id] = sign_define(id, params)
				call sign_place(0, bufname("%"), id, bufname("%"), {"lnum": line_number})
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

