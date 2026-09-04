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
    set clipboard=unnamed,unnamedplus
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keep 8 lines visible above/below the cursor
set so=8

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

" Colorscheme (silently skip if unavailable)
try
    colorscheme habamax
catch
endtry
set background=dark

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
" Left: one space, file path + flags in Normal fg, then paste-mode indicator
" (2-space gap) and the right side in Comment fg (StlInfo).
" Right: position segment (see StlPos) padded to the file's totals so the
" bar width never shifts while the cursor moves (no jitter).
set statusline=\ %f\ %m%r%h%w%#StlInfo#\ \ %{HasPaste()}
set statusline+=%=%{StlPos()}%*


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 0 jumps to the first non-blank character
nnoremap 0 ^

" Alt+J/K (Cmd+J/K on mac) move the current line
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

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
        return 'PASTE MODE '
    endif
    return ''
endfunction

" Statusline position segment: "Column: c  Line: l/L". fields are left-
" aligned at fixed width (column 2 chars, line = digits of line('$')) so
" there is exactly one space after each colon and the bar never shifts
" while the cursor moves (no jitter)
function! StlPos() abort
    let l:lw = len(string(line('$')))
    return printf('Column: %-2d  Line: %-*d/%d  ',
        \ col('.'), l:lw, line('.'), line('$'))
endfunction

" Statusline colors matched to the nvim config (nvim/lua/config/theme.lua):
" active bar lifted with the theme's CursorLine bg, text tiers
" file (Normal fg) > info (Comment fg) > inactive (LineNr fg)
function! s:HlAttr(name, what) abort
    let l:sid = synIDtrans(hlID(a:name))
    return [synIDattr(l:sid, a:what, 'gui'), synIDattr(l:sid, a:what, 'cterm')]
endfunction

function! s:HiCmd(name, fg, bg) abort
    let l:cmd = 'highlight ' . a:name
    if a:fg[0] != ''
        let l:cmd .= ' guifg=' . a:fg[0]
    endif
    if a:fg[1] != ''
        let l:cmd .= ' ctermfg=' . a:fg[1]
    endif
    if a:bg[0] != ''
        let l:cmd .= ' guibg=' . a:bg[0]
    endif
    if a:bg[1] != ''
        let l:cmd .= ' ctermbg=' . a:bg[1]
    endif
    execute l:cmd
endfunction

function! s:ApplyStlColors() abort
    let l:normal_fg = s:HlAttr('Normal', 'fg')
    let l:comment_fg = s:HlAttr('Comment', 'fg')
    let l:linenr_fg = s:HlAttr('LineNr', 'fg')
    let l:bar_bg = s:HlAttr('CursorLine', 'bg')
    call s:HiCmd('StatusLine', l:normal_fg, l:bar_bg)
    call s:HiCmd('StlInfo', l:comment_fg, l:bar_bg)
    call s:HiCmd('StatusLineNC', l:linenr_fg, ['NONE', 'NONE'])
    " tab bar: selected tab like the active bar, others dim + transparent
    call s:HiCmd('TabLineSel', l:normal_fg, l:bar_bg)
    call s:HiCmd('TabLine', l:linenr_fg, ['NONE', 'NONE'])
    call s:HiCmd('TabLineFill', ['', ''], ['NONE', 'NONE'])
endfunction

augroup vimrc_stl_colors
    autocmd!
    autocmd ColorScheme * call s:ApplyStlColors()
augroup END

call s:ApplyStlColors()

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
