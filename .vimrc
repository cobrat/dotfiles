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
set path+=**

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
set splitbelow
set splitright
set nowrap
set linebreak
set list
set pumheight=10
set wildmenu
set wildmode=longest:full,full
set noshowmode
set noruler

if exists('+breakindent')
  set breakindent
endif
if exists('+breakindentopt')
  set breakindentopt=list:-1
endif
if exists('+cursorlineopt')
  set cursorlineopt=screenline,number
endif
if exists('+signcolumn')
  set signcolumn=auto
endif
if exists('+completeopt')
  set completeopt=menuone,noselect
endif
if exists('+wildoptions')
  set wildoptions=pum,fuzzy
endif
if exists('+listchars')
  set listchars=extends:…,nbsp:␣,precedes:…,tab:>\ 
endif
if exists('+fillchars')
  set fillchars=fold:╌
endif
if exists('+shortmess')
  set shortmess+=SWa
endif

" Editing
set backspace=eol,start,indent
set hidden
set ignorecase
set smartcase
set incsearch
set expandtab
set formatoptions=rqnl1j
set shiftwidth=2
set softtabstop=2
set tabstop=2
set smartindent
set virtualedit=block
set iskeyword=@,48-57,_,192-255,-
set formatlistpat=^\s*[0-9\-\+\*]\+[\.\)]*\s\+
set complete=.,w,b,kspell
set updatetime=200
set timeoutlen=400

" Folding
set foldmethod=indent
set foldlevel=10
set foldnestmax=10
set foldtext=

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

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m,%f:%l:%m
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

" Helpers
function! s:RestoreCursor() abort
  if line("'\"") > 1 && line("'\"") <= line('$')
    execute "normal! g'\""
  endif
endfunction

function! s:TrimTrailingWhitespace() abort
  if &filetype ==# 'markdown'
    return
  endif
  let l:view = winsaveview()
  silent! keeppatterns %s/\s\+$//e
  call winrestview(l:view)
endfunction

function! s:OpenPath(path) abort
  execute 'edit' fnameescape(a:path)
endfunction

function! s:BufDrop(action) abort
  let l:cur = bufnr('%')
  let l:alt = bufnr('#')
  let l:save_win = win_getid()

  for l:winid in win_findbuf(l:cur)
    call win_gotoid(l:winid)
    if l:alt > 0 && l:alt != l:cur && bufexists(l:alt)
      execute 'buffer' l:alt
    else
      enew
    endif
  endfor

  if bufexists(l:cur)
    silent! execute a:action l:cur
  endif

  call win_gotoid(l:save_win)
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

function! s:SetupMarkdown() abort
  setlocal wrap
  setlocal linebreak
  setlocal textwidth=80
  setlocal colorcolumn=80
  setlocal formatoptions+=t
  setlocal formatoptions+=m
  setlocal formatoptions-=l
  setlocal breakat+=，、。；：？！
endfunction

" Autocommands
augroup UserConfig
  autocmd!
  autocmd FocusGained * silent! checktime
  autocmd BufReadPost * call <SID>RestoreCursor()
  autocmd BufWritePre * call <SID>TrimTrailingWhitespace()
  autocmd FileType * setlocal formatoptions-=c formatoptions-=o
  autocmd FileType markdown call <SID>SetupMarkdown()
augroup END

" Insert / general mappings
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Buffer — <Leader>b
" Delete or wipe a buffer without closing its window first.
nnoremap <silent> <leader>bd :call <SID>BufDrop('bdelete')<CR>
nnoremap <silent> <leader>bw :call <SID>BufDrop('bwipeout')<CR>

" Explore — <Leader>e
" Closest built-in Vim equivalent to the nvim file explorer workflow.
nnoremap <leader>ee :call <SID>OpenPath(getcwd())<CR>
nnoremap <leader>ef :call <SID>OpenPath(expand('%:p:h'))<CR>
nnoremap <leader>em :messages<CR>
nnoremap <leader>eq :call <SID>ToggleQuickfix()<CR>
nnoremap <leader>el :call <SID>ToggleLocationList()<CR>

" Find — <Leader>f
" Closest built-in Vim equivalents to the nvim mini.pick workflow.
nnoremap <leader>ff :find<Space>
nnoremap <leader>fg :grep<Space>
nnoremap <leader>fb :buffers<CR>
nnoremap <leader>fh :help<Space>
