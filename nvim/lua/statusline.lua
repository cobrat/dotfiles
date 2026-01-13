-- ~/.config/nvim-new/lua/statusline.lua

local state = {
    show_path = true,
    show_branch = true,
}

local config = {
    icons = { 
        path_hidden = "...", -- Text replacement for folder icon
        branch_hidden = "*", -- Text replacement for hidden branch icon
    },
    placeholder_hl = "StatusLineDim",
}

-- Create and link highlight groups
vim.api.nvim_set_hl(0, config.placeholder_hl, { link = "Comment" })

-- Helper to wrap text in statusline highlight groups
local function hl(group, text)
    return string.format("%%#%s#%s%%*", group, text)
end

-- Generate the file path string
local function filepath()
    local fpath = vim.fn.fnamemodify(vim.fn.expand "%", ":~:.:h")
    if fpath == "" or fpath == "." then return "" end
    if state.show_path then return string.format("%%<%s/", fpath) end
    return hl(config.placeholder_hl, config.config.icons.path_hidden .. "/")
end

-- Generate Git status string (requires gitsigns.nvim)
local function git()
    local git_info = vim.b.gitsigns_status_dict
    if not git_info or git_info.head == "" then return "" end

    local head = state.show_branch and git_info.head or hl(config.placeholder_hl, config.icons.branch_hidden)
    local added = (git_info.added and git_info.added > 0) and (" +" .. git_info.added) or ""
    local changed = (git_info.changed and git_info.changed > 0) and (" ~" .. git_info.changed) or ""
    local removed = (git_info.removed and git_info.removed > 0) and (" -" .. git_info.removed) or ""

    return string.format("[Git: %s%s%s%s]", head, added, changed, removed)
end

Statusline = {}

-- Active window statusline format
function Statusline.active()
    return table.concat { "[", filepath(), "%t] ", git(), "%=", "%y [%P %l:%c]" }
end

-- Inactive window statusline format
function Statusline.inactive()
    return " %t"
end

-- Toggle functions
function Statusline.toggle_path() state.show_path = not state.show_path; vim.cmd("redrawstatus") end
function Statusline.toggle_branch() state.show_branch = not state.show_branch; vim.cmd("redrawstatus") end

-- Global keymaps for UI toggles
vim.keymap.set("n", "<leader>sp", function() Statusline.toggle_path() end, { desc = "Toggle path" })
vim.keymap.set("n", "<leader>sb", function() Statusline.toggle_branch() end, { desc = "Toggle branch" })

-- Automatic statusline switching logic
local group = vim.api.nvim_create_augroup("Statusline", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = group,
    callback = function() vim.opt_local.statusline = "%!v:lua.Statusline.active()" end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
    group = group,
    callback = function() vim.opt_local.statusline = "%!v:lua.Statusline.inactive()" end,
})
