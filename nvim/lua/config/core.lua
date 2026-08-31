-- CORE OPTIONS
local set = vim.opt

--line nums
set.relativenumber = true
set.number = true

-- indentation and tabs
set.tabstop = 4
set.shiftwidth = 4
set.autoindent = true
set.expandtab = true

-- search settings
set.ignorecase = true
set.smartcase = true

-- appearance
set.termguicolors = true
set.background = "dark"
set.signcolumn = "yes"

-- cursor line
set.cursorline = true

-- 80th column
set.colorcolumn = "80"

-- clipboard
set.clipboard:append("unnamedplus")

-- backspace
set.backspace = "indent,eol,start"

-- split windows
set.splitbelow = true
set.splitright = true

-- dw/diw/ciw works on full-word
set.iskeyword:append("-")

-- keep cursor at least 8 rows from top/bot
set.scrolloff = 8

-- undo dir settings
set.swapfile = false
set.backup = false
vim.fn.mkdir(os.getenv("HOME") .. "/.vim/undodir", "p")
set.undodir = os.getenv("HOME") .. "/.vim/undodir"
set.undofile = true

-- incremental search
set.incsearch = true

-- STATUSLINE: soft and layered. active window: per-mode tinted chip + bright
-- file + mid-gray info on a faint dark bar; inactive windows: one flat dim
-- line. highlight groups are defined in the kanagawa overrides (plugins.lua).
-- left: mode, file, modified/readonly/help/preview flags
-- right: git branch, filetype, line:col, percent
local MODE_NAMES = {
    n = 'NORMAL', v = 'VISUAL', V = 'V-LINE', ['\22'] = 'V-BLOCK',
    i = 'INSERT', R = 'REPLACE', c = 'COMMAND', t = 'TERM',
}
local MODE_HL = {
    n = 'StlModeNormal', i = 'StlModeInsert', R = 'StlModeReplace',
    v = 'StlModeVisual', V = 'StlModeVisual', ['\22'] = 'StlModeVisual',
    c = 'StlModeCommand', t = 'StlModeTerm',
}

function _G.stl_mode()
    return MODE_NAMES[vim.fn.mode():sub(1, 1)] or 'OTHER'
end

-- last two path components of the full path, cwd-independent; paths under
-- $HOME keep the `~` prefix (e.g. nvim/init.lua, ~/.zshrc, dotfiles/README.md)
function _G.stl_file()
    local name = vim.api.nvim_buf_get_name(0)
    if name == '' then return 'No Name' end
    local parts = vim.split(vim.fn.fnamemodify(name, ':~'), '/')
    local n = #parts
    if n >= 2 then return parts[n - 1] .. '/' .. parts[n] end
    return parts[n]
end

-- git segment for the statusline, e.g. "[(main) +1 -0 ~1]  " (empty outside git repos)
function _G.stl_git()
    local d = vim.b.gitsigns_status_dict
    if not d or not d.head then return '' end
    return ('[(%s) +%d -%d ~%d]  '):format(d.head, d.added or 0, d.removed or 0, d.changed or 0)
end

-- %! renderer: called per window while drawing; g:statusline_winid tells us
-- which window the statusline belongs to, so inactive windows get their own
-- flat dim variant and the mode chip only shows in the focused window
function _G.stl()
    if vim.g.statusline_winid ~= vim.api.nvim_get_current_win() then
        return '%<%#StlNC# %{v:lua.stl_file()}%m%r%h%w %=%{v:lua.stl_git()}%{&filetype}  %l:%c  %p%% %*'
    end
    local m = vim.fn.mode():sub(1, 1)
    return table.concat({
        '%<',
        '%#', MODE_HL[m] or 'StlModeOther', '# ', stl_mode(), ' %*',
        '%#StlFile#  %{v:lua.stl_file()}%m%r%h%w %*',
        '%=',
        '%#StlInfo#%{v:lua.stl_git()}%{&filetype}  %l:%c  %p%% %*',
    })
end

vim.o.statusline = '%!v:lua.stl()'

-- faster cursor hold
set.updatetime = 50

-- KEYBINDS
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", function()
    require("oil").open()
end, { desc = "Open Oil file explorer" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv") -- Alt Up/Down in vscode
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")       -- Remap joining lines
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- Keep cursor in place while moving up/down page
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")       -- center screen when looping search results
vim.keymap.set("n", "N", "Nzzzv")

-- paste and don't replace clipboard over deleted text
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])


-- sometimes in insert mode, control-c doesn't exactly work like escape
vim.keymap.set("i", "<C-c>", "<Esc>")

-- add binds for Control J/K to scroll thru quickfix list
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz")

-- What the heck is Ex mode?
vim.keymap.set("n", "Q", "<nop>")

vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")


-- lint / format php files for LC
vim.keymap.set("n", "<leader>cc", "<cmd>!php-cs-fixer fix % --using-cache=no<cr>")

-- Replace all instances of whatever is under cursor (on line)
vim.keymap.set("n", "<leader>s", [[:s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])

-- make file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- yank into clipboard even if on ssh
vim.keymap.set('n', '<leader>y', '<Plug>OSCYankOperator')
vim.keymap.set('v', '<leader>y', '<Plug>OSCYankVisual')

-- reload without exiting vim
vim.keymap.set("n", "<leader>rl", "<cmd>source ~/.config/nvim/init.lua<cr>")

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Quickfix list stuff (next/prev via <C-j>/<C-k> above)
vim.keymap.set("n", "<leader>cl", ":cclose<CR>", { silent = true })
vim.keymap.set("n", "<leader>co", ":copen<CR>", { silent = true })
vim.keymap.set("n", "<leader>li", ":checkhealth vim.lsp<CR>", { desc = "LSP Info" })

-- run make in current working directory
vim.keymap.set("n", "<leader>mm", "<cmd>make<CR>")

-- source file
vim.keymap.set("n", "<leader><leader>", "<cmd>so<cr>", { desc = "Source current file" })
