-- THEME
-- Built-in habamax; tints are re-derived from the active scheme on every
-- ColorScheme event so the statusline groups follow theme changes.

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
    -- capture theme colors first: nvim_set_hl REPLACES group definitions,
    -- so overwriting Normal with bg=none would otherwise drop its fg
    local fg_normal = hl("Normal", "fg")
    local fg_float = hl("NormalFloat", "fg")
    local fg_comment = hl("Comment", "fg")
    local fg_linenr = hl("LineNr", "fg")
    local bar_bg = hl("CursorLine", "bg")

    -- keep editor surfaces transparent so the terminal bg shows through
    vim.api.nvim_set_hl(0, "Normal", { fg = fg_normal, bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { fg = fg_float, bg = "none" })

    -- active bar: subtle lift (theme's CursorLine bg); text tiers
    -- file (Normal fg) > info (Comment fg) > inactive (LineNr fg)
    vim.api.nvim_set_hl(0, "StatusLine", { fg = fg_normal, bg = bar_bg })
    vim.api.nvim_set_hl(0, "StlFile", { fg = fg_normal, bg = bar_bg })
    vim.api.nvim_set_hl(0, "StlInfo", { fg = fg_comment, bg = bar_bg })
    vim.api.nvim_set_hl(0, "StatusLineNC", { fg = fg_linenr, bg = "none" })
    vim.api.nvim_set_hl(0, "StlNC", { fg = fg_linenr, bg = "none" })

    -- statusline segment colors from the theme's own palette: git counts
    -- (+ green / - red / ~ yellow) from the diff colors; diagnostic E/W
    -- red/yellow fall back to the same palette (habamax Error/WarningMsg
    -- have no usable fg)
    local function seg(name, ...)
        vim.api.nvim_set_hl(0, name, { fg = fg_of(...), bg = bar_bg })
    end
    seg("StlGitAdd", "Added", "DiffAdd")
    seg("StlGitDel", "Removed", "DiffDelete")
    seg("StlGitMod", "Changed", "DiffChange")
    seg("StlDiagE", "Removed", "DiagnosticError")
    seg("StlDiagW", "Changed", "DiagnosticWarn")
end

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("ThemeExtras", { clear = true }),
    callback = apply_theme_extras,
})

vim.cmd.colorscheme("habamax")
