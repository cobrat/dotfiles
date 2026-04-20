" ============================================================
" .vimrc - simplified Vim config aligned with nvim/
" ============================================================

set nocompatible

" General
let mapleader = ' '
let $LANG = 'en_US.UTF-8'

set history=500
set autoread
set encoding=utf-8
set ffs=unix,dos,mac

filetype plugin indent on
syntax enable

if exists('+mouse')
  set mouse=a
endif
if exists('+mousescroll')
  set mousescroll=ver:8,hor:6
endif
if exists('+undofile')
  set undofile
endif

" UI
set number
set cursorline
set colorcolumn=80
set scrolloff=10
set sidescrolloff=10
set splitbelow
set splitright
set nowrap
set list
set pumheight=10
set wildmenu
set wildmode=longest:full,full
set noshowmode
set noruler

if exists('+breakindent')
  set breakindent
endif
if exists('+cursorlineopt')
  set cursorlineopt=screenline,number
endif
if exists('+signcolumn')
  set signcolumn=yes
endif
if exists('+completeopt')
  set completeopt=menuone,noinsert,noselect
endif
if exists('+listchars')
  set listchars=tab:>-,trail:-,nbsp:+,extends:>,precedes:<
endif
if exists('+fillchars')
  set fillchars=fold:-
endif

" Editing
set backspace=eol,start,indent
set hidden
set ignorecase
set smartcase
set hlsearch
set incsearch
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set autoindent
set smartindent
set virtualedit=block
set iskeyword=@,48-57,_,192-255,-
set updatetime=200
set timeoutlen=400

" Folding
set foldmethod=indent
set foldlevel=10
set foldnestmax=10

" Files
set nobackup
set nowritebackup
set noswapfile

try
  set switchbuf=useopen,usetab
catch
endtry

set wildignore=*.o,*~,*.pyc
if has('win16') || has('win32') || has('win64')
  set wildignore+=.git\*,.hg\*,.svn\*
else
  set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Colors
try
  colorscheme gruvbox
catch
  try
    colorscheme habamax
  catch
  endtry
endtry
set background=dark

" Functions
function! s:RestoreCursor() abort
  if line("'\"") > 1 && line("'\"") <= line('$')
    execute "normal! g'\""
  endif
endfunction

function! s:TrimTrailingWhitespace() abort
  let l:save_cursor = getpos('.')
  let l:old_search = getreg('/')
  silent! %s/\s\+$//e
  call setpos('.', l:save_cursor)
  call setreg('/', l:old_search)
endfunction

function! s:CopyFilePath() abort
  let l:path = expand('%:p')
  if has('clipboard')
    let @+ = l:path
  else
    let @" = l:path
  endif
  echo 'file: ' . l:path
endfunction

function! s:NewScratchBuffer() abort
  enew
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
endfunction

function! s:Explore(path) abort
  execute 'edit' fnameescape(a:path)
endfunction

function! s:ToggleQuickfix() abort
  let l:info = getqflist({ 'winid': 0 })
  if get(l:info, 'winid', 0) != 0
    cclose
    return
  endif
  copen
endfunction

function! s:ToggleLocationList() abort
  let l:info = getloclist(0, { 'winid': 0 })
  if get(l:info, 'winid', 0) != 0
    lclose
    return
  endif
  if empty(getloclist(0))
    echo 'Location list is empty'
    return
  endif
  lopen
endfunction

function! s:SetupProse() abort
  setlocal wrap
  setlocal linebreak
  setlocal spell
  setlocal textwidth=80
  setlocal colorcolumn=80
endfunction

function! s:ToggleBackground() abort
  if &background ==# 'dark'
    set background=light
  else
    set background=dark
  endif
endfunction

" Autocommands
augroup UserConfig
  autocmd!
  autocmd FocusGained,BufEnter * silent! checktime
  autocmd FileChangedShellPost * echo 'File reloaded from disk'
  autocmd BufReadPost * call <SID>RestoreCursor()
  autocmd FileType * setlocal formatoptions-=c formatoptions-=o
  autocmd FileType markdown,text,gitcommit call <SID>SetupProse()
augroup END

" General mappings
nnoremap <silent> <Esc> :nohlsearch<CR>
nnoremap <silent> <leader>c :nohlsearch<CR>

nnoremap <silent> <C-s> :update<CR>
inoremap <silent> <C-s> <C-o>:update<CR>
xnoremap <silent> <C-s> <Esc>:update<CR>gv

nnoremap go o<Esc>
nnoremap gO O<Esc>

nnoremap [p :execute 'put! ' . v:register<CR>
nnoremap ]p :execute 'put ' . v:register<CR>

nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

vnoremap < <gv
vnoremap > >gv

if has('clipboard')
  nnoremap gy "+y
  xnoremap gy "+y
  nnoremap gY "+Y
  nnoremap gp "+p
  nnoremap gP "+P
  xnoremap gp "+P
  xnoremap gP "+P
endif

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Buffer mappings
nnoremap <leader>ba :b#<CR>
nnoremap <leader>bd :bdelete<CR>
nnoremap <leader>bD :bdelete!<CR>
nnoremap <leader>bw :bwipeout<CR>
nnoremap <leader>bW :bwipeout!<CR>
nnoremap <leader>bs :call <SID>NewScratchBuffer()<CR>

" Explore/edit mappings
nnoremap <leader>ed :call <SID>Explore(getcwd())<CR>
nnoremap <leader>ef :call <SID>Explore(expand('%:p:h'))<CR>
nnoremap <leader>ei :edit $MYVIMRC<CR>
nnoremap <leader>eo :edit $MYVIMRC<CR>
nnoremap <leader>eq :call <SID>ToggleQuickfix()<CR>
nnoremap <leader>eQ :call <SID>ToggleLocationList()<CR>

" Other mappings
nnoremap <leader>fp :call <SID>CopyFilePath()<CR>
nnoremap <leader>or :vertical resize 80<CR>
nnoremap <leader>ot :call <SID>TrimTrailingWhitespace()<CR>

" Toggle mappings
nnoremap \b :call <SID>ToggleBackground()<CR>
nnoremap \c :set cursorline!<CR>
nnoremap \C :set cursorcolumn!<CR>
nnoremap \h :set hlsearch!<CR>
nnoremap \l :set list!<CR>
nnoremap \n :set number!<CR>
nnoremap \r :set relativenumber!<CR>
nnoremap \s :set spell!<CR>
nnoremap \w :set wrap!<CR>
