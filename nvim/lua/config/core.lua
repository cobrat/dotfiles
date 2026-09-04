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

set.cursorline = true
set.colorcolumn = "80"
set.clipboard:append("unnamedplus")
set.splitbelow = true
set.splitright = true
set.scrolloff = 8
set.updatetime = 50

-- '-' counts as part of a word so dw/diw/ciw handle hyphenated words
set.iskeyword:append("-")

-- undo persistence
set.swapfile = false
vim.fn.mkdir(os.getenv("HOME") .. "/.vim/undodir", "p")
set.undodir = os.getenv("HOME") .. "/.vim/undodir"
set.undofile = true

-- pick up file changes on disk ('autoread' is on by default)
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    group = vim.api.nvim_create_augroup("auto_refresh", { clear = true }),
    command = "checktime",
})

-- libuv dir watchers: :checktime within ~100ms of any on-disk write;
-- watch dirs, not files, to catch tmp-file+rename writes
do
    local group = vim.api.nvim_create_augroup("file_watchers", { clear = true })
    local watchers = {}
    local debounce = assert(vim.uv.new_timer())

    local function checktime_soon()
        debounce:start(100, 0, vim.schedule_wrap(function()
            vim.cmd("silent! checktime")
        end))
    end

    local function watch(buf)
        local path = vim.api.nvim_buf_get_name(buf)
        if path == "" or vim.bo[buf].buftype ~= "" then return end
        local dir = vim.fs.dirname(path)
        if watchers[dir] then return end
        local w = assert(vim.uv.new_fs_event())
        watchers[dir] = w
        w:start(dir, {}, function(err)
            if err then return end
            vim.schedule(checktime_soon)
        end)
    end

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufFilePost" }, {
        group = group,
        callback = function(a) watch(a.buf) end,
    })

    -- stop the watcher when its dir has no buffers left
    vim.api.nvim_create_autocmd("BufUnload", {
        group = group,
        callback = function(a)
            local path = vim.api.nvim_buf_get_name(a.buf)
            if path == "" then return end
            local dir = vim.fs.dirname(path)
            local w = watchers[dir]
            if not w then return end
            for _, info in ipairs(vim.fn.getbufinfo({ bufloaded = 1 })) do
                local p = vim.api.nvim_buf_get_name(info.bufnr)
                if info.bufnr ~= a.buf and p ~= "" and vim.fs.dirname(p) == dir then
                    return
                end
            end
            w:stop()
            w:close()
            watchers[dir] = nil
        end,
    })
end

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
-- git branch segment for the active statusline, "main"; empty without git
-- (the [ ] brackets live in the stl() template)
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

-- diagnostic counts after the modified flags, colored via StlDiagE/StlDiagW
-- in the template (E red / W yellow); sev 1=ERROR 2=WARN
function _G.stl_diag(sev, letter)
    local c = vim.diagnostic.count(0)
    return (c[sev] or 0) > 0 and ('(' .. letter .. c[sev] .. ')') or ''
end

-- cursor position, "Column:  1  Line: 29/100"; virtcol so tabs count as
-- cells. Column uses a fixed 2-digit width; Line is padded to the total's
-- digit count so the layout doesn't shift while moving the cursor
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
    return table.concat({
        '%<',
        '%#StlFile# %{v:lua.stl_file()}%m%r%h%w%*  ',
        '%#StlDiagE#%{v:lua.stl_diag(1,\"E\")}%*  ',
        '%#StlDiagW#%{v:lua.stl_diag(2,\"W\")}%*',
        '%=',
        '%#StlInfo#[%{v:lua.stl_git_branch()}%* ',
        '%#StlGitAdd#%{v:lua.stl_git_count("+", "added")}%* ',
        '%#StlGitDel#%{v:lua.stl_git_count("-", "removed")}%* ',
        '%#StlGitMod#%{v:lua.stl_git_count("~", "changed")}%*',
        '%#StlInfo#]  %{v:lua.stl_pos()} %*',
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
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over, register kept" })
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

-- yank into the clipboard even over ssh
vim.keymap.set('n', '<leader>y', '<Plug>OSCYankOperator', { desc = "Yank to system clipboard (operator)" })
vim.keymap.set('v', '<leader>y', '<Plug>OSCYankVisual', { desc = "Yank to system clipboard" })

-- built-in undotree (bundled since 0.12 as an opt package); packadd is
-- guarded by a loaded flag inside the plugin, so repeating it is harmless
vim.keymap.set("n", "<leader>u", function()
    vim.cmd.packadd("nvim.undotree")
    require("undotree").open({ command = "topleft 30vnew" })
end, { desc = "Toggle undotree" })

