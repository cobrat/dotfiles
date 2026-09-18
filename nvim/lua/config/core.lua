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
set.showmode = false -- the statusline mode badge replaces it

-- default float border (explicit ones win)
set.winborder = "rounded"

set.cursorline = true
set.colorcolumn = "80"
set.clipboard:append("unnamedplus")
set.splitbelow = true
set.splitright = true
set.scrolloff = 8
-- idle timer behind CursorHold: auto_refresh and the document highlight
set.updatetime = 250

-- 'autocomplete' = menu-as-you-type (off by default in 0.12); 'o' = omnifunc,
-- i.e. vim.lsp.omnifunc once a client attaches. clangd returns ~100 items per
-- keystroke, so cap source/rows/width; the delay stops the menu flashing
set.autocomplete = true
set.autocompletedelay = 80
set.complete = { "o^15" }
set.pumheight = 10
set.pummaxwidth = 50
-- <C-y> to accept; pumborder matches winborder. Only popup/preinsert/longest/
-- fuzzy/preselect/preview apply under 'autocomplete'; noselect is implied
set.completeopt = { "popup" }
set.pumborder = "rounded"

-- prefix keys otherwise wait 1s
set.timeoutlen = 300

-- '-' is a word char, so dw/diw/ciw handle hyphenated words
set.iskeyword:append("-")

-- undo persistence; 'undodir' already defaults to $XDG_STATE_HOME/nvim/undo
set.swapfile = false
set.undofile = true

-- pick up on-disk changes (autoread is default)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose", "CursorHold", "CursorHoldI" }, {
    group = vim.api.nvim_create_augroup("auto_refresh", { clear = true }),
    command = "checktime",
})

-- json/jsonc are 2-space
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "json", "jsonc" },
    callback = function()
        vim.opt_local.shiftwidth, vim.opt_local.tabstop, vim.opt_local.softtabstop = 2, 2, 2
    end,
})

-- STATUSLINE (highlight groups in theme.lua)

-- width of the window being drawn. Not g:statusline_winid: it is nil during
-- the nested %{} pass, which runs after %!. The renderer points curwin at the
-- drawn window in both passes, so winwidth(0) works
local function stl_w()
    return vim.fn.winwidth(0)
end

-- three path tiers: full (cwd-relative), parent/name, tail; %< truncates
-- from its own end, so an over-long path falls back to its tail by itself
function _G.stl_file()
    local name = vim.api.nvim_buf_get_name(0)
    if name == '' then return 'No Name' end
    local w = stl_w()
    if w >= 120 then return vim.fn.fnamemodify(name, ':~:.') end
    local parts = vim.split(vim.fn.fnamemodify(name, ':~'), '/')
    local n = #parts
    if w < 60 or n < 2 then return parts[n] end
    return parts[n - 1] .. '/' .. parts[n]
end

-- mode badge, single letter below 70 columns, separator included. %# inside
-- a %{} result is not parsed, so the segment is built here, not in the template
local function stl_mode()
    local m = vim.api.nvim_get_mode().mode
    local c = m:sub(1, 1)
    local label, hl
    if c == 'i' then label, hl = 'INSERT', 'StlModeI'
    elseif c == 'R' then label, hl = 'REPLACE', 'StlModeR'
    elseif c == 'v' or c == 'V' or m == '\22' then label, hl = 'VISUAL', 'StlModeV'
    elseif c == 's' or c == 'S' or m == '\19' then label, hl = 'SELECT', 'StlModeV'
    elseif c == 'c' then label, hl = 'COMMAND', 'StlModeN'
    elseif c == 't' or c == '!' then label, hl = 'TERMINAL', 'StlModeN'
    elseif c == 'n' then label, hl = 'NORMAL', 'StlModeN'
    else label, hl = m:upper(), 'StlModeN'
    end
    return ('%%#%s# %s%%*  '):format(hl, stl_w() < 70 and label:sub(1, 1) or label)
end

-- git in one color, silent outside a repo; counts only when they fit
-- ("[main +0 -0 ~0]"), branch only below 70 columns. %{} results are not
-- re-parsed, so a branch name is safe to return
function _G.stl_git()
    local d = vim.b.gitsigns_status_dict
    if not d or not d.head then return '' end
    if stl_w() < 70 then return '[' .. d.head .. ']' end
    return ('[%s +%s -%s ~%s]'):format(d.head,
        d.added or 0, d.removed or 0, d.changed or 0)
end

-- "W4 E1", in the same info gray as git/position/lsp. Optional segments carry
-- their own leading separator: a %( %) group of highlight-only items is dropped
local function diag_seg()
    local c = vim.diagnostic.count(0)
    local w, e = c[2] or 0, c[1] or 0
    if w + e == 0 then return '' end
    local parts = {}
    if w > 0 then parts[#parts + 1] = 'W' .. w end
    if e > 0 then parts[#parts + 1] = 'E' .. e end
    return '  %#StlInfo#(' .. table.concat(parts, ' ') .. ')%*'
end

-- "12/17" for the running search; searchcount() raises E54 on a pattern it
-- cannot count yet (while typing "\(), hence the guard
local function search_seg()
    if stl_w() < 100 or vim.v.hlsearch == 0 then return '' end
    local ok, s = pcall(vim.fn.searchcount, { recompute = true })
    if not ok or not s.current or s.total == 0 then return '' end
    local txt = s.incomplete == 1 and '?/?' or ('%d/%d'):format(s.current, s.total)
    return '  %#StlSearch#' .. txt .. '%*'
end

-- "05(01)/225" = line(vcol)/total, zero padded. %v not %c so tabs count as
-- cells; the %-11() group is fixed width, so the git segment does not shift
local STL_POS = '%-11(%02l(%02v)/%-3L%)'

-- %! renderer, called per window; g:statusline_winid picks active vs dim variant
function _G.stl()
    if vim.g.statusline_winid ~= vim.api.nvim_get_current_win() then
        return ' %<%#StlNC# %{v:lua.stl_file()}%m%r%h%w %=%{v:lua.stl_git()}  '
            .. STL_POS .. '%* '
    end
    -- special buffers (help/quickfix/terminal/...) skip git/diagnostic/search
    if vim.bo.buftype ~= '' then
        return ' ' .. stl_mode() .. '%<%#StlFile# %{v:lua.stl_file()}%m%r%h%w%*'
            .. '%=  %#StlInfo#' .. STL_POS .. '%* '
    end
    -- left: mode badge + path; the rest is right-aligned and empty when it has
    -- nothing to report. %< sits after the badge, so narrow windows eat the path
    -- first; the leading space matches the trailing one next to the position
    return table.concat({
        ' ' .. stl_mode(),
        '%<%#StlFile# %{v:lua.stl_file()}%m%r%h%w%*',
        '%=',
        search_seg(),
        -- diagnostics + git at the right end, then position
        diag_seg(),
        '  %#StlInfo#%{v:lua.stl_git()}  ' .. STL_POS .. '%* ',
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

-- join/page/search navigation, screen kept centered
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join with line below, cursor kept" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down, centered" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up, centered" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next match, centered" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous match, centered" })

-- paste over, register kept; delete without yanking
vim.keymap.set("v", "<leader>p", [["_dP]], { desc = "Paste over, register kept" })
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete into black-hole register" })

-- quickfix/loclist navigation (j = next, k = prev)
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>zz", { desc = "Quickfix next, centered" })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>zz", { desc = "Quickfix previous, centered" })
vim.keymap.set("n", "<leader>j", "<cmd>lnext<CR>zz", { desc = "Loclist next, centered" })
vim.keymap.set("n", "<leader>k", "<cmd>lprev<CR>zz", { desc = "Loclist previous, centered" })
vim.keymap.set("n", "<leader>cl", "<cmd>cclose<CR>", { desc = "Close quickfix window" })
vim.keymap.set("n", "<leader>co", "<cmd>copen<CR>", { desc = "Open quickfix window" })

vim.keymap.set("n", "Q", "<nop>", { desc = "Disabled (Ex mode)" })

-- replace word under cursor on the line
vim.keymap.set("n", "<leader>s", [[:s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
    { desc = "Substitute word under cursor on line" })
