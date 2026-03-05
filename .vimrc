" ======================" ============================================================================
" GENERAL SETTINGS
" ============================================================================
syntax on
filetype plugin indent on

set termguicolors
set background=dark
silent! colorscheme habamax

" ============================================================================
" OPTIONS
" ============================================================================
set number              " Show line numbers
set norelativenumber    " Disable relative line numbers
set cursorline          " Highlight the current line
set wrap                " Enable line wrapping
set scrolloff=10        " Keep 10 lines above/below cursor
set sidescrolloff=10    " Keep 10 lines to left/right of cursor

set tabstop=4           " Number of spaces a Tab counts for
set shiftwidth=4        " Number of spaces for auto-indent
set softtabstop=4       " Number of spaces for Tab in edit mode
set expandtab           " Turn tabs into spaces
set smartindent         " Do smart auto-indenting
set autoindent          " Copy indent from current line on newline

set ignorecase          " Case insensitive search
set smartcase           " Case sensitive if search contains uppercase
set hlsearch            " Highlight search matches
set incsearch           " Show matches while typing

set signcolumn=yes      " Always show the sign column
set showmatch           " Highlight matching brackets
set cmdheight=1         " Height of the command bar
set completeopt=menuone,noinsert,noselect " Autocomplete behavior
set noshowmode          " Hide default mode text (handled by statusline)

set nobackup            " Do not create backup files
set nowritebackup
set noswapfile          " Do not create swap files
set updatetime=200      " Faster completion/update response
set timeoutlen=500      " Key sequence timeout
set ttimeoutlen=10      " Key code timeout
set autoread            " Auto-reload file if changed outside Vim

set hidden              " Allow switching buffers without saving
set noerrorbells        " Disable beep sounds
set backspace=indent,eol,start " Fix backspace behavior
set mouse=a             " Enable mouse in all modes
set clipboard+=unnamed  " Use system clipboard
set encoding=utf-8

" Split behavior
set splitbelow          " Horizontal splits open below
set splitright          " Vertical splits open to the right

" Completion UI
set wildmenu            " Visual menu for command line completion
set wildmode=longest:full,full

" Folding logic
set foldmethod=indent   " Fold based on indentation levels
set foldlevel=99        " Start with all folds open

" ============================================================================
" STATUSLINE
" ============================================================================
function! StatuslineMode()
    let l:m = mode()
    let l:modes = {
        \ 'n':  'NORMAL', 'i':  'INSERT', 'v':  'VISUAL', 'V':  'V-LINE',
        \ "\<C-V>": 'V-BLOCK', 'c':  'COMMAND', 'R':  'REPLACE', 't':  'TERMINAL'
        \ }
    return get(l:modes, l:m, l:m)
endfunction

set statusline=
set statusline+=\ %{StatuslineMode()}\     " Current mode
set statusline+=\ %f\ %h%m%r\              " File path and flags
set statusline+=%=                         " Right align separator
set statusline+=\ %y\                      " File type
set statusline+=\ %l:%c\                   " Line:Column
set statusline+=\ %P\                      " Percentage through file

set laststatus=2        " Always show the statusline

" ============================================================================
" KEYMAPS
" ============================================================================
let mapleader = " "

" Movement in wrapped text
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')

" Clear search highlights
nnoremap <leader>c :nohlsearch<CR>

" Keep cursor centered during search/scrolling
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" Paste/Delete without overwriting default register
xnoremap <leader>p "_dP
nnoremap <leader>x "_d
vnoremap <leader>x "_d

" Buffer navigation
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Window management
nnoremap <leader>sv :vsplit<CR>
nnoremap <leader>sh :split<CR>
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Better indentation behavior
vnoremap < <gv
vnoremap > >gv

" Keep cursor position when joining lines
nnoremap J mzJ`z

" Copy file path to clipboard
nnoremap <leader>pa :let @+=expand("%:p")<CR>:echo "Copied: ".expand("%:p")<CR>

" Disable Ex mode
nnoremap Q <nop>

" Built-in File Explorer (Netrw)
nnoremap <leader>e :Lexplore<CR>
let g:netrw_banner = 0       " Hide banner
let g:netrw_liststyle = 3    " Tree view
let g:netrw_winsize = 25     " 25% width

" ============================================================================
" AUTOCMDS
" ============================================================================
augroup UserConfig
    autocmd!
    " Restore cursor position on file open
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g'\"" |
        \ endif

    " Specialized settings for text-heavy files
    autocmd FileType markdown,text,gitcommit setlocal wrap linebreak spell
augroup END
