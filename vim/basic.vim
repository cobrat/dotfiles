"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" basic.vim - personal Vim configuration
" Based on amix/vimrc (https://github.com/amix/vimrc)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use Vim settings rather than Vi settings (enables line continuation)
set nocompatible
set history=500

filetype plugin on
filetype indent on

" Auto-reload files changed outside of Vim
set autoread
au FocusGained,BufEnter * silent! checktime

" <leader> is Space; <leader>w saves
let mapleader = " "
nmap <leader>w :w!<cr>

" :W saves with sudo (for permission-denied files)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Use the system clipboard (only if compiled with clipboard support)
if has('clipboard')
    set clipboard=unnamedplus
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keep 7 lines visible above/below the cursor
set so=7

" Command-line completion menu
set wildmenu
" Files ignored by completion
set wildignore=*.o,*~,*.pyc
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store

" Show cursor position; relative line numbers (current line is absolute)
set ruler
set number
set relativenumber

set cmdheight=1

" Allow switching buffers without saving
set hid

" Backspace and arrow keys wrap across line ends
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

set foldcolumn=1

" Enable mouse in all modes
set mouse=a

" Disable error bells
set noerrorbells
set novisualbell
set t_vb=
set tm=500
" Also on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Case-insensitive search; smart case when uppercase is used
set ignorecase
set smartcase
" Highlight and incrementally match search results
set hlsearch
set incsearch
" No redraw while running macros (performance)
set lazyredraw
" Highlight matching brackets
set showmatch
set mat=2


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors and Encoding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable

" Enable true color in modern terminals (iTerm2/kitty/alacritty/wezterm/tmux)
if $TERM_PROGRAM == 'iTerm.app' || $TERM =~# '\v(kitty|alacritty|wezterm|tmux-256color)'
    set termguicolors
endif

" Colorscheme (silently skip if unavailable)
try
    colorscheme habamax
catch
endtry
set background=dark

" GUI options (MacVim)
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

set encoding=utf8
set ffs=unix,dos,mac


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" No backup/swap files (version control covers this)
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Indent and Text
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spaces instead of tabs; 1 tab = 4 spaces
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4

set ai "Auto indent
set si "Smart indent
set wrap "Wrap lines


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Windows, Buffers and Tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <leader><cr> clears search highlight
map <silent> <leader><cr> :noh<cr>

" Ctrl+arrows move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Buffers: <leader>bd close, ba close all, h/l prev/next
map <leader>bd :Bclose<cr>:tabclose<cr>gT
map <leader>ba :bufdo bd<cr>
map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

" Tabs: tn new, to only, tc close, tm move, t<leader> next, tl last
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext<cr>
let g:lasttab = 1
nmap <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" <leader>te opens a new tab at the current file's directory
map <leader>te :tabedit <C-r>=escape(expand("%:p:h"), " ")<cr>/

" <leader>cd switches to the current file's directory
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Prefer reusing open windows when switching buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Restore the last edit position when reopening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Status Line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l\ \ Column:\ %c


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 0 jumps to the first non-blank character
map 0 ^

" Alt+J/K (Cmd+J/K on mac) move the current line
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

if has("mac") || has("macunix")
  nmap <D-j> <M-j>
  nmap <D-k> <M-k>
  vmap <D-j> <M-j>
  vmap <D-k> <M-k>

  " Option key as Meta (needed for <M-j>/<M-k> in terminal)
  try
      set macmeta
  catch
  endtry
endif

" Strip trailing whitespace on save
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun
if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

" Visual mode */# searches the selected text
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" <leader>pp toggles paste mode
map <leader>pp :setlocal paste!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Helper Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Paste mode indicator (used by the statusline)
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

" Close a buffer without closing the window (used by <leader>bd)
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

" Search/replace helpers for visual mode (* / #)
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
