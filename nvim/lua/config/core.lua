-- CORE OPTIONS
local set = vim.opt

set.relativenumber = true
set.number = true

set.tabstop = 4
set.shiftwidth = 4
set.autoindent = true
set.expandtab = true

set.ignorecase = true
set.smartcase = true

set.termguicolors = true
set.background = "dark"
set.signcolumn = "yes"

set.cursorline = true
set.colorcolumn = "80"
set.clipboard:append("unnamedplus")
set.backspace = "indent,eol,start"
set.splitbelow = true
set.splitright = true
set.scrolloff = 8
set.incsearch = true
set.updatetime = 50

-- '-' counts as part of a word so dw/diw/ciw handle hyphenated words
set.iskeyword:append("-")

-- undo persistence
set.swapfile = false
set.backup = false
vim.fn.mkdir(os.getenv("HOME") .. "/.vim/undodir", "p")
set.undodir = os.getenv("HOME") .. "/.vim/undodir"
set.undofile = true

-- reload buffers when the file changes on disk
set.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("auto_refresh", { clear = true }),
    command = "checktime",
})

-- STATUSLINE: active window shows bright file + gray info on a dark bar,
-- inactive windows one dim line. mode display is left to 'showmode';
-- highlight groups live in theme.lua. search match count shows in the
-- cmdline by default ('shortmess' without S), so it is not duplicated here.

-- last two path components, cwd-independent; ~ prefix for $HOME paths
function _G.stl_file()
    local name = vim.api.nvim_buf_get_name(0)
    if name == '' then return 'No Name' end
    local parts = vim.split(vim.fn.fnamemodify(name, ':~'), '/')
    local n = #parts
    if n >= 2 then return parts[n - 1] .. '/' .. parts[n] end
    return parts[n]
end

-- git parts for the active statusline. split into tiny functions because
-- %{} results are NOT scanned for highlight items, so the %# groups must
-- live in the template itself
function _G.stl_git_head()
    local d = vim.b.gitsigns_status_dict
    return d and d.head or ''
end

function _G.stl_git_count(sign, key)
    local d = vim.b.gitsigns_status_dict
    if not d or not d.head then return '' end
    return sign .. tostring(d[key] or 0)
end

-- plain git segment for the inactive line, "(main) +4 -1 ~0"
function _G.stl_git()
    local d = vim.b.gitsigns_status_dict
    if not d or not d.head then return '' end
    return ('(%s) +%s -%s ~%s  '):format(d.head,
        tostring(d.added or 0), tostring(d.removed or 0), tostring(d.changed or 0))
end

-- diagnostic counts after the modified flags, colored via StlDiagE/StlDiagW
-- in the template (E red / W yellow)
function _G.stl_diag_e()
    local c = vim.diagnostic.count(0)
    return (c[1] or 0) > 0 and ('E' .. c[1]) or ''
end

function _G.stl_diag_w()
    local c = vim.diagnostic.count(0)
    return (c[2] or 0) > 0 and ('W' .. c[2]) or ''
end

-- %! renderer, called per window; g:statusline_winid picks active vs dim variant
function _G.stl()
    if vim.g.statusline_winid ~= vim.api.nvim_get_current_win() then
        return '%<%#StlNC# %{v:lua.stl_file()}%m%r%h%w %=%{v:lua.stl_git()}%{&filetype}  %l:%c  %p%% %*'
    end
    -- special buffers (help/quickfix/terminal/...) skip git/diagnostic/search
    if vim.bo.buftype ~= '' then
        return '%<%#StlFile# %{v:lua.stl_file()}%m%r%h%w %=%{&filetype}  %l:%c  %p%% %*'
    end
    return table.concat({
        '%<',
        '%#StlFile# %{v:lua.stl_file()}%m%r%h%w%*  ',
        '%#StlDiagE#%{v:lua.stl_diag_e()}%*  ',
        '%#StlDiagW#%{v:lua.stl_diag_w()}%*',
        '%=',
        '%#StlInfo#%{v:lua.stl_git_head() != "" ? "(" . v:lua.stl_git_head() . ")" : ""} ',
        '%#StlGitAdd#%{v:lua.stl_git_count("+", "added")}%* ',
        '%#StlGitDel#%{v:lua.stl_git_count("-", "removed")}%* ',
        '%#StlGitMod#%{v:lua.stl_git_count("~", "changed")}%*  ',
        '%#StlInfo#%{&filetype}  %l:%c  %p%% %*',
    })
end

vim.o.statusline = '%!v:lua.stl()'

-- KEYBINDS
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", function()
    require("oil").open()
end, { desc = "Open Oil file explorer" })

-- move visual selection up/down (vscode Alt+Up/Down)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- join lines / page and search navigation with the screen kept centered
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste over selection without clobbering the register; delete without yanking
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- quickfix / location list navigation (j = next, k = prev, matching j/k)
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz")
vim.keymap.set("n", "<leader>cl", ":cclose<CR>", { silent = true })
vim.keymap.set("n", "<leader>co", ":copen<CR>", { silent = true })

vim.keymap.set("n", "Q", "<nop>") -- disable Ex mode

-- replace every occurrence of the word under cursor on the current line
vim.keymap.set("n", "<leader>s", [[:s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])

-- yank into the clipboard even over ssh
vim.keymap.set('n', '<leader>y', '<Plug>OSCYankOperator')
vim.keymap.set('v', '<leader>y', '<Plug>OSCYankVisual')

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<leader>li", ":checkhealth vim.lsp<CR>", { desc = "LSP Info" })
vim.keymap.set("n", "<leader>mm", "<cmd>make<CR>") -- run make in cwd
