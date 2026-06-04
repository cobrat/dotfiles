" ============================================================
" .vimrc - Vim config aligned with nvim defaults
" ============================================================

set nocompatible
scriptencoding utf-8

let mapleader = ' '
let maplocalleader = ' '

filetype plugin indent on
syntax enable

" UI
set number
if exists('+relativenumber')
  set relativenumber
endif
set cursorline
set showmode
if exists('+signcolumn')
  set signcolumn=yes
endif
if exists('+termguicolors')
  set termguicolors
endif
set linebreak
if exists('+breakindent')
  set breakindent
endif
set colorcolumn=80

" Editing
set expandtab
set shiftwidth=4
set tabstop=4
set mouse=a
set confirm
if exists('+undofile')
  set undofile
endif
set noswapfile
set hidden
set backspace=indent,eol,start

" Search
set ignorecase
set smartcase
set incsearch
if exists('+inccommand')
  set inccommand=split
endif

if executable('rg')
  set grepprg=rg\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

set splitbelow
set splitright
set updatetime=250
set timeoutlen=300
if exists('+completeopt')
  set completeopt=menu,menuone,noselect
endif
set wildmenu
set wildmode=longest:full,full

try
  colorscheme gruvbox
catch
  try
    colorscheme habamax
  catch
  endtry
endtry
set background=dark

function! s:CloseBuffer() abort
  if &buflisted
    bdelete
  else
    close
  endif
endfunction

function! s:CenterView() abort
  let l:height = winheight(0)
  let l:cursor = line('.')
  let l:last = line('$')
  let l:margin = float2nr(l:height / 2)
  if l:cursor <= l:margin || l:cursor > l:last - l:margin
    return
  endif
  normal! zz
endfunction

function! s:TrimTrailingWhitespace() abort
  if !&modifiable || &filetype ==# 'markdown'
    return
  endif
  let l:view = winsaveview()
  silent! keeppatterns %s/\s\+$//e
  call winrestview(l:view)
endfunction

function! s:HighlightYank() abort
  if !exists('v:event') || get(v:event, 'operator', '') !=# 'y'
    return
  endif

  if exists('w:last_yank_match')
    silent! call matchdelete(w:last_yank_match)
    unlet w:last_yank_match
  endif

  let l:start = getpos("'[")
  let l:end = getpos("']")
  if l:start[1] <= 0 || l:end[1] <= 0
    return
  endif

  let l:positions = []
  if l:start[1] == l:end[1]
    call add(l:positions, [l:start[1], l:start[2], max([1, l:end[2] - l:start[2] + 1])])
  else
    call add(l:positions, [l:start[1], l:start[2]])
    for lnum in range(l:start[1] + 1, l:end[1] - 1)
      call add(l:positions, [lnum])
    endfor
    call add(l:positions, [l:end[1], 1, l:end[2]])
  endif

  let w:last_yank_match = matchaddpos('IncSearch', l:positions, 10)
  if exists('*timer_start')
    call timer_start(150, function('<SID>ClearYankHighlight', [win_getid(), w:last_yank_match]))
  endif
endfunction

function! s:ClearYankHighlight(winid, matchid, timer) abort
  if exists('*win_execute') && win_id2win(a:winid) > 0
    call win_execute(a:winid, 'silent! call matchdelete(' . a:matchid . ')')
    call win_execute(a:winid, 'silent! unlet w:last_yank_match')
  else
    silent! call matchdelete(a:matchid)
  endif
endfunction

augroup UserConfig
  autocmd!
  autocmd TextYankPost * call <SID>HighlightYank()
  autocmd BufEnter,FocusGained * silent! checktime
  autocmd BufWritePre * call <SID>TrimTrailingWhitespace()
augroup END

" Movement
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
xnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
xnoremap <expr> k v:count == 0 ? 'gk' : 'k'

nnoremap <silent> n n:call <SID>CenterView()<CR>
nnoremap <silent> N N:call <SID>CenterView()<CR>

" Core commands
nnoremap <leader>e :Explore<CR>
nnoremap <silent> <leader>q :call <SID>CloseBuffer()<CR>
nnoremap <leader><leader> <C-^>
nnoremap <leader>ff :find<Space>
nnoremap <leader>fg :grep<Space>
nnoremap <leader>fb :buffers<CR>:buffer<Space>

" Clipboard and registers
nnoremap <leader>y "+y
xnoremap <leader>y "+y
nnoremap <leader>Y "+Y
nnoremap <leader>d "_d
xnoremap <leader>d "_d
xnoremap <leader>p "_dP

nnoremap Q <Nop>
nnoremap <Esc> :nohlsearch<CR>
nnoremap J mzJ`z

" Visual editing
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv
xnoremap < <gv
xnoremap > >gv
