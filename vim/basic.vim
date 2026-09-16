" personal Vim config - remote SSH, all-default colors

" Basics
set nocompatible encoding=utf8 fileformats=unix,dos,mac
filetype plugin indent on
set autoread
if has('clipboard') | set clipboard=unnamed,unnamedplus | endif
let mapleader = " "

" Interface
set number relativenumber scrolloff=8 ruler
set wildmenu
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set hidden switchbuf=useopen
set backspace=indent,eol,start whichwrap+=<,>,h,l mouse=a
set ttimeout ttimeoutlen=50 timeoutlen=500

" Search
set ignorecase smartcase hlsearch incsearch
set showmatch matchtime=2

" Colors
syntax enable

" Files
set noswapfile

" Indent: spaces, 1 tab = 4 spaces
set expandtab smarttab shiftwidth=4 tabstop=4
set autoindent wrap

" Keymaps: windows / buffers
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l
nnoremap <leader>bd :bd<cr>
nnoremap <leader>ba :bufdo bd<cr>
nnoremap <leader>l :bnext<cr>
nnoremap <leader>h :bprevious<cr>
nnoremap <leader>cd :cd %:p:h<cr>:pwd<cr>
nnoremap <leader>w :w!<cr>
nnoremap <silent> <leader><cr> :noh<cr>
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Keymaps: editing
nnoremap 0 ^
nnoremap <M-j> :m .+1<cr>==
nnoremap <M-k> :m .-2<cr>==
vnoremap <M-j> :m '>+1<cr>gv=gv
vnoremap <M-k> :m '<-2<cr>gv=gv

" Autocmds
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
    \ | exe "normal! g'\"" | endif
autocmd BufWritePre * %s/\s\+$//e
