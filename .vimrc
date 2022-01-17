if exists("skip_defaults_vim")
    finish
endif

" Use Vim-specific features
if has("compatible")
  set nocompatible
endif

" Functions for use in vimrc

" Get underlying OS's type
function GetOSType()
	for l:os_name in ['unix', 'win32', 'macos']
		if has(l:os_name)
			return l:os_name
		endif
	endfor
endfunction

" Get type of underlying terminal
function GetTerminalType()
	return &term
endfunction

" Get separator used by the underlying OS
function GetOSSep(os_type)
	if a:os_type ==# "unix"
		return "/"
	elseif a:os_type ==# "win32"
		return "\\"
	elseif a:os_type ==# "macos"
		return ":"
	endif

	return "(invalid sep)"
endfunction

" Replace path using old separators with new separators
function ReplacePathSeps(path, old_sep, new_sep)
	let l:dir_list = split(a:path, a:old_sep)

	let l:new_path = join(l:dir_list, a:new_sep)

	return l:new_path
endfunction

" Start of settings
let s:os_type = GetOSType()
let s:os_sep = GetOSSep(s:os_type)

" Modify cursor to be block
if has("guicursor")
	highlight Cursor guifg=white guibg=black
	highlight iCursor guifg=white guibg=steelblue

	set guicursor = n-v-c-i:block-Cursor
elseif GetTerminalType() =~ '^xterm'
	" Insert mode
	let &t_SI.="\e[5 q"
	
	" Replace mode
	let &t_SR.="\e[4 q"

	" Normal mode
	let &t_EI.="\e41 q"
endif

" Set undo directories
let s:vim_dir = $HOME . s:os_sep . ".vim"
let s:vim_undo_dir = s:vim_dir . s:os_sep . "undo-dir" 

if !isdirectory(s:vim_dir)
	call mkdir(s:vim_dir, "", 0770)
endif

if !isdirectory(s:vim_undo_dir)
	call mkdir(s:vim_undo_dir, "p", 0700)
endif

let &undodir = s:vim_undo_dir
set undofile

" Set indentation
set autoindent
set expandtab
set shiftround
set shiftwidth=4
set smarttab
set tabstop=4
filetype plugin indent on

" Set backspaces
set backspace=indent,eol,start

" Set search options
set hlsearch
set ignorecase

" Set text options
set encoding=utf-8
set linebreak
syntax enable

" Set editor options
set ruler
set wildmenu
set number

" Set shell
if s:os_type[-3:] == "nix" || s:os_type[:3] == "mac"
	set shell=bash
elseif s:os_type[:3] == "win"
	set shell=powershell
endif
