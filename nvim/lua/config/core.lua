-- CORE OPTIONS
local set = vim.opt

set.relativenumber = true
set.number = true

set.tabstop = 4
set.shiftwidth = 4
set.expandtab = true

set.ignorecase = true
set.smartcase = true

set.termguicolors = true
set.background = "dark"
set.signcolumn = "yes"

-- default border for floats that do not set their own (explicit ones win)
set.winborder = "rounded"

set.cursorline = true
set.colorcolumn = "80"
set.clipboard:append("unnamedplus")
set.splitbelow = true
set.splitright = true
set.scrolloff = 8
set.updatetime = 50

-- completion: 'autocomplete' is the menu-as-you-type switch (off by default in
-- 0.12); 'o' = omnifunc, which is vim.lsp.omnifunc once a client is attached.
-- clangd alone answers with 100 items per keystroke, each with a detail
-- column, so cap the source, the rows and the width; the delay keeps the menu
-- from flashing while typing a word
set.autocomplete = true
set.autocompletedelay = 80
set.complete = { "o^15" }
set.pumheight = 10
set.pummaxwidth = 50
-- noselect + <C-y> to accept; pumborder matches winborder
set.completeopt = { "menuone", "noselect", "popup" }
set.pumborder = "rounded"

-- prefix keys otherwise wait a full second before dropping
set.timeoutlen = 300

-- '-' counts as part of a word so dw/diw/ciw handle hyphenated words
set.iskeyword:append("-")

-- undo persistence
set.swapfile = false
vim.fn.mkdir(os.getenv("HOME") .. "/.vim/undodir", "p")
set.undodir = os.getenv("HOME") .. "/.vim/undodir"
set.undofile = true

-- pick up file changes on disk ('autoread' is on by default)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose", "CursorHold", "CursorHoldI" }, {
    group = vim.api.nvim_create_augroup("auto_refresh", { clear = true }),
    command = "checktime",
})

-- json/jsonc are 2-space (after/ftplugin would need two identical files)
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "json", "jsonc" },
    callback = function()
        vim.opt_local.shiftwidth, vim.opt_local.tabstop, vim.opt_local.softtabstop = 2, 2, 2
    end,
})

-- STATUSLINE (highlight groups in theme.lua)

-- last two path components, cwd-independent, ~ for $HOME
function _G.stl_file()
    local name = vim.api.nvim_buf_get_name(0)
    if name == '' then return 'No Name' end
    local parts = vim.split(vim.fn.fnamemodify(name, ':~'), '/')
    local n = #parts
    if n >= 2 then return parts[n - 1] .. '/' .. parts[n] end
    return parts[n]
end

-- git branch for the active line; %{} results are not scanned for %# groups,
-- so the brackets (and the "[---]" fallback) live in stl() below
function _G.stl_git_branch()
    local d = vim.b.gitsigns_status_dict
    return d and d.head or ''
end

function _G.stl_git_count(sign, key)
    local d = vim.b.gitsigns_status_dict
    if not d or not d.head then return '' end
    return sign .. tostring(d[key] or 0)
end

-- plain git segment for the inactive line, "[main +4 -1 ~0]"
function _G.stl_git()
    local d = vim.b.gitsigns_status_dict
    if not d or not d.head then return '' end
    return ('[%s +%s -%s ~%s]  '):format(d.head,
        tostring(d.added or 0), tostring(d.removed or 0), tostring(d.changed or 0))
end

-- W before E, e.g. "(W4 E1)"; only the letters take the StlDiag* colors and
-- the parens fall back to StatusLine via %*. Cells are built here (not in a
-- %{}) because %# items in a %{} result are not parsed, only in the %! template
local function diag_seg()
    local c = vim.diagnostic.count(0)
    local w, e = c[2] or 0, c[1] or 0
    if w + e == 0 then return '' end
    local parts = {}
    if w > 0 then parts[#parts + 1] = '%#StlDiagW#W' .. w .. '%*' end
    if e > 0 then parts[#parts + 1] = '%#StlDiagE#E' .. e .. '%*' end
    return '(' .. table.concat(parts, ' ') .. ')'
end

-- "Column:  1  Line: 29/100"; virtcol so tabs count as cells
function _G.stl_pos()
    local c = vim.fn.virtcol('.')
    local l, ltotal = vim.fn.line('.'), vim.fn.line('$')
    return ('Column: %2d  Line: %' .. #tostring(ltotal) .. 'd/%d')
        :format(c, l, ltotal)
end

-- %! renderer, called per window; g:statusline_winid picks active vs dim variant
function _G.stl()
    if vim.g.statusline_winid ~= vim.api.nvim_get_current_win() then
        return '%<%#StlNC# %{v:lua.stl_file()}%m%r%h%w %=%{v:lua.stl_git()}%{v:lua.stl_pos()} %*'
    end
    -- special buffers (help/quickfix/terminal/...) skip git/diagnostic/search
    if vim.bo.buftype ~= '' then
        return '%<%#StlFile# %{v:lua.stl_file()}%m%r%h%w %=%{v:lua.stl_pos()} %*'
    end
    -- branch + counts in a repo, "[---]" outside one
    local d = vim.b.gitsigns_status_dict
    local git_seg
    if d and d.head then
        git_seg = table.concat({
            '%#StlInfo#[%{v:lua.stl_git_branch()}%* ',
            '%#StlGitAdd#%{v:lua.stl_git_count("+", "added")}%* ',
            '%#StlGitDel#%{v:lua.stl_git_count("-", "removed")}%* ',
            '%#StlGitMod#%{v:lua.stl_git_count("~", "changed")}%*',
            '%#StlInfo#]  ',
        })
    else
        git_seg = '%#StlInfo#[---]  '
    end
    return table.concat({
        '%<',
        '%#StlFile# %{v:lua.stl_file()}%m%r%h%w%*  ',
        diag_seg(),
        '%=',
        git_seg,
        '%#StlInfo#%{v:lua.stl_pos()} %*',
    })
end

vim.o.statusline = '%!v:lua.stl()'

-- KEYBINDS
vim.g.mapleader = " "

vim.keymap.set("n", "<leader>e", function()
    require("oil").open()
end, { desc = "Open Oil file explorer" })

-- move visual selection up/down (vscode Alt+Up/Down)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- join lines / page and search navigation with the screen kept centered
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join with line below, cursor kept" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down, centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up, centered" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next match, centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous match, centered" })

-- paste over selection without clobbering the register; delete without yanking
vim.keymap.set("v", "<leader>p", [["_dP]], { desc = "Paste over, register kept" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete into black-hole register" })

-- quickfix / location list navigation (j = next, k = prev, matching j/k)
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Quickfix next, centered" })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Quickfix previous, centered" })
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz", { desc = "Loclist next, centered" })
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz", { desc = "Loclist previous, centered" })
vim.keymap.set("n", "<leader>cl", "<cmd>cclose<CR>", { desc = "Close quickfix window" })
vim.keymap.set("n", "<leader>co", "<cmd>copen<CR>", { desc = "Open quickfix window" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Disabled (Ex mode)" })

-- replace every occurrence of the word under cursor on the current line
vim.keymap.set("n", "<leader>s", [[:s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
    { desc = "Substitute word under cursor on line" })
