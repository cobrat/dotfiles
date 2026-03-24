" ============================================================
" .vimrc — synced with nvim/init.lua
" ============================================================


" ============================================================
" General
" ============================================================
set history=500
filetype plugin on
filetype indent on

set autoread
au FocusGained,BufEnter * silent! checktime

let mapleader = " "


" ============================================================
" Core Options
" ============================================================
set number
set relativenumber
set cursorline
set scrolloff=10
set sidescrolloff=10
set colorcolumn=80
set signcolumn=yes
set updatetime=200
set timeoutlen=400
set noshowmode
set completeopt=menuone,noinsert,noselect
set mouse=a
set splitbelow
set splitright
set pumheight=10
set synmaxcol=300
set undofile


" ============================================================
" UI
" ============================================================
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

set wildmenu
set wildmode=longest:full,full
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set hidden

set ignorecase
set smartcase
set hlsearch
set incsearch

set lazyredraw
set showmatch
set mat=2
set noerrorbells
set novisualbell
set t_vb=

if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif


" ============================================================
" Colors and Fonts
" ============================================================
syntax enable
set regexpengine=0

try
    colorscheme habamax
catch
endtry

set background=dark
set encoding=utf8
set ffs=unix,dos,mac

if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
endif


" ============================================================
" Files and Backups
" ============================================================
set nobackup
set nowb
set noswapfile


" ============================================================
" Text, Tab and Indent
" ============================================================
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set linebreak
set smartindent
set wrap


" ============================================================
" Status Line
" ============================================================
let g:sl_modes = {
    \ 'n': '--NORMAL--',  'i': '--INSERT--',  'v': '--VISUAL--',
    \ 'V': '--V-LINE--',  "\<C-v>": '--V-BLOCK--',
    \ 'c': '--COMMAND--', 'R': '--REPLACE--', 't': '--TERMINAL--'
    \ }

function! SlStatus()
    let m = mode()
    let tag = get(g:sl_modes, m, '--' . toupper(m) . '--')
    return ' ' . tag . ' %f%h%m%r %= Line:%-4l Col:%-3c %P '
endfunction

set laststatus=2
set showtabline=0
set statusline=%!SlStatus()


" ============================================================
" Keymaps
" ============================================================
" Clear highlight
nnoremap <silent> <leader>c :noh<CR>

" Navigation
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Paste / delete to void register
xnoremap p "_dP
nnoremap <leader>x "_d
vnoremap <leader>x "_d

" Window navigation
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" Window resize
nnoremap <C-Up>    :resize +2<CR>
nnoremap <C-Down>  :resize -2<CR>
nnoremap <C-Left>  :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Indent stay in visual
vnoremap < <gv
vnoremap > >gv

" Buffer ops
nnoremap <leader>bb <C-^>
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bd<CR>

" Window ops
nnoremap <leader>wv :vsplit<CR>
nnoremap <leader>wh :split<CR>
nnoremap <leader>wc :close<CR>

" Copy file path to clipboard
nnoremap <leader>fp :call CopyFilePath()<CR>


" ============================================================
" Autocmds
" ============================================================
augroup UserConfig
    autocmd!

    " Restore last cursor position on file open
    autocmd BufReadPost * call RestoreCursor()

    " Trim trailing whitespace on save
    autocmd BufWritePre
        \ *.txt,*.js,*.py,*.wiki,*.sh,*.coffee
        \ call CleanExtraSpaces()

    " Spell + linebreak for prose filetypes
    autocmd FileType markdown,text,gitcommit
        \ setlocal linebreak spell

augroup END

" Buffer switching
try
    set switchbuf=useopen,usetab
catch
endtry


" ============================================================
" Functions
" ============================================================
function! RestoreCursor()
    if line("'\"") > 1 && line("'\"") <= line("$")
        exe "normal! g'\""
    endif
endfunction

function! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction

function! CopyFilePath()
    let path = expand("%:p")
    let @+ = path
    echo "file: " . path
endfunction
