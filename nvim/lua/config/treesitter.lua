-- TREE-SITTER

-- Parsers for every language with an LSP server (see lsp.lua), plus basics
-- for dotfiles/docs. Dependencies are NOT auto-installed, so listed
-- explicitly: cpp/objc->c, scss->css, markdown->markdown_inline,
-- php->php_only, html->html_tags, tsx->ecma+jsx+typescript, + *doc injectors.
local parsers = {
    -- editing basics
    "bash", "json", "markdown", "markdown_inline", "query", "vim", "vimdoc",
    -- C family (clangd)
    "c", "cpp", "objc",
    -- Lua (luals)
    "lua", "luadoc",
    -- no LSP server; kept on purpose for scripts and docs
    "python",
    -- Go (gopls, templ)
    "go", "gomod", "gowork", "gotmpl", "templ",
    -- rust_analyzer, zls, nil_ls, serve_d, c3lsp, hls
    "rust", "zig", "nix", "d", "c3", "haskell",
    -- PHP (intelephense)
    "php", "php_only", "phpdoc",
    -- Web (cssls, ts_ls)
    "css", "scss", "html", "html_tags",
    "ecma", "jsx", "javascript", "jsdoc", "typescript", "tsx",
}

-- Filetypes to start highlighting on (react/jsonc mappings are built in)
local filetypes = {
    "bash", "json", "jsonc", "markdown", "query", "vim", "vimdoc",
    "c", "cpp", "objc",
    "lua", "python",
    "go", "gomod", "gowork", "gotmpl", "templ",
    "rust", "zig", "nix", "d", "c3", "haskell",
    "php",
    "css", "scss", "less", "html",
    "javascript", "javascriptreact", "typescript", "typescriptreact",
    "sh",
}

-- no dedicated less/sh parsers; css/bash are close enough
vim.treesitter.language.register('css', 'less')
vim.treesitter.language.register('bash', 'sh')

local treesitter = require("nvim-treesitter")

-- install missing parsers in the background; observe the returned task so
-- install failures (no compiler, no network) notify instead of surfacing
-- later as a missing-parser warning on buffer open
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
