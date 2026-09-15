-- TREE-SITTER

-- Parsers for every LSP language plus dotfiles/docs; dependencies are not
-- auto-installed, hence markdown_inline and luadoc
local parsers = {
    -- editing basics
    "bash", "json", "yaml", "markdown", "markdown_inline", "query", "vim", "vimdoc",
    -- C family (clangd)
    "c", "cpp",
    -- Lua (luals)
    "lua", "luadoc",
    -- Python (pyright)
    "python",
    -- Go (gopls)
    "go", "gomod",
    -- Rust (rust_analyzer)
    "rust",
}

-- lua, markdown and query are already started by their runtime ftplugins
local filetypes = {
    "bash", "json", "jsonc", "yaml", "vim",
    "c", "cpp",
    "python",
    "go", "gomod",
    "rust",
    "sh",
}

-- no dedicated sh parser; bash is close enough
vim.treesitter.language.register('bash', 'sh')

local treesitter = require("nvim-treesitter")

-- install in the background; surface failures as a notification
local task = treesitter.install(parsers)
task:await(function(err)
    if err then
        vim.notify(tostring(err), vim.log.levels.WARN, { title = "Tree-sitter install" })
    end
end)

local group = vim.api.nvim_create_augroup("TreesitterConfig", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = filetypes,
    callback = function(args)
        local ok, err = pcall(vim.treesitter.start, args.buf)
        if not ok then
            vim.notify(err, vim.log.levels.WARN, { title = "Tree-sitter" })
        end
    end,
})

vim.api.nvim_create_autocmd("PackChanged", {
    group = group,
    callback = function(args)
        local data = args.data
        if not data or data.spec.name ~= "nvim-treesitter" then
            return
        end
        if data.kind ~= "install" and data.kind ~= "update" then
            return
        end

        vim.schedule(function()
            require("nvim-treesitter").update():wait(300000)
        end)
    end,
})

require("nvim-treesitter-textobjects").setup({
    select = {
        lookahead = true,
    },
})

local select = require("nvim-treesitter-textobjects.select")
vim.keymap.set({ "x", "o" }, "af", function()
    select.select_textobject("@function.outer", "textobjects")
end, { desc = "Around function" })
vim.keymap.set({ "x", "o" }, "if", function()
    select.select_textobject("@function.inner", "textobjects")
end, { desc = "Inside function" })
