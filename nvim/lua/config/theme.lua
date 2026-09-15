-- THEME: habamax; tints are re-derived on every ColorScheme event

-- read fg/bg of a highlight group as a hex string, e.g. '#c7c7c7'
local function hl(name, part)
    local ok, def = pcall(vim.api.nvim_get_hl, 0, { name = name, link = true })
    if not ok or not def or not def[part] then return nil end
    return ('#%06x'):format(def[part])
end

-- first defined fg among candidate groups, e.g. Added before DiffAdd
local function fg_of(...)
    for _, name in ipairs({ ... }) do
        local f = hl(name, "fg")
        if f then return f end
    end
    return nil
end

local function apply_theme_extras()
    -- capture first: nvim_set_hl REPLACES definitions (bg=none would drop fg)
    local fg_normal = hl("Normal", "fg")
    local fg_float = hl("NormalFloat", "fg")
    local fg_comment = hl("Comment", "fg")
    local fg_linenr = hl("LineNr", "fg")
    local bar_bg = hl("CursorLine", "bg")

    -- keep editor surfaces transparent so the terminal bg shows through
    vim.api.nvim_set_hl(0, "Normal", { fg = fg_normal, bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { fg = fg_float, bg = "none" })
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = fg_normal, bg = "none" })

    -- thin border in Normal fg; the default chain paints solid gray strips

    -- active bar: CursorLine bg lift, tiers file > info > inactive
    vim.api.nvim_set_hl(0, "StatusLine", { fg = fg_normal, bg = bar_bg })
    vim.api.nvim_set_hl(0, "StlFile", { fg = fg_normal, bg = bar_bg })
    vim.api.nvim_set_hl(0, "StlInfo", { fg = fg_comment, bg = bar_bg })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = fg_linenr, bg = "none" })
    vim.api.nvim_set_hl(0, "StlNC", { fg = fg_linenr, bg = "none" })

    -- segment colors from the theme's palette (habamax Error/Warning have no fg)
    local function seg(name, ...)
        vim.api.nvim_set_hl(0, name, { fg = fg_of(...), bg = bar_bg })
    end
    seg("StlGitAdd", "Added", "DiffAdd")
    seg("StlGitDel", "Removed", "DiffDelete")
    seg("StlGitMod", "Changed", "DiffChange")
    seg("StlDiagE", "Removed", "DiagnosticError")
    seg("StlDiagW", "Changed", "DiagnosticWarn")

    -- labels link Substitute -> Search, i.e. invisible without a tint
    vim.api.nvim_set_hl(0, "FlashLabel", { fg = bar_bg, bg = fg_comment })
end

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("ThemeExtras", { clear = true }),
    callback = apply_theme_extras,
})

vim.cmd.colorscheme("habamax")
