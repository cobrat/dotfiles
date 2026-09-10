" personal Vim config - based on amix/vimrc

" Basics
set nocompatible encoding=utf8 fileformats=unix,dos,mac
filetype plugin indent on
set autoread
autocmd FocusGained,BufEnter * silent! checktime
if has('clipboard') | set clipboard=unnamed,unnamedplus | endif
let mapleader = " "

" Interface
set number relativenumber scrolloff=8 ruler
set wildmenu
set wildignore=*.o,*~,*.pyc,*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
set hidden switchbuf=useopen
set backspace=indent,eol,start whichwrap+=<,>,h,l mouse=a
set noerrorbells novisualbell t_vb=
set ttimeout ttimeoutlen=50 timeoutlen=500

" Search
set ignorecase smartcase hlsearch incsearch lazyredraw
set showmatch matchtime=2

" Colors
syntax enable

" Files
set nobackup nowritebackup noswapfile

" Indent: spaces, 1 tab = 4 spaces
set expandtab smarttab shiftwidth=4 tabstop=4
set autoindent smartindent wrap

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
" :W saves with sudo
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Keymaps: editing
nnoremap 0 ^
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z
vnoremap <silent> * :<C-u>call VisualSelection()<CR>/<C-R>/<CR>
vnoremap <silent> # :<C-u>call VisualSelection()<CR>?<C-R>/<CR>
function! VisualSelection() range
    let l:reg = @"
    normal! vgvy
    let @/ = escape(@", "\\/.*'$^~[]")
    let @" = l:reg
endfunction

" Autocmds
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
    \ | exe "normal! g'\"" | endif
function! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction
autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee call CleanExtraSpaces()

