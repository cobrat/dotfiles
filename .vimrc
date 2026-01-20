syntax on
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set noesckeys
set relativenumber
set number
set ignorecase
set smartcase
set incsearch
set cinoptions=l1
set modeline
set autoindent
set autochdir

autocmd BufEnter * if &filetype == "go" | setlocal noexpandtab
autocmd BufNewFile,BufRead ?\+.c3 setf c
