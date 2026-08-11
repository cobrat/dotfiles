-- TREE-SITTER

local parsers = {
    "c",
    "lua",
    "python",
}

local filetypes = {
    "c",
    "lua",
    "python",
}

local treesitter = require("nvim-treesitter")

treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
})

-- Missing parsers are installed asynchronously. Existing parsers are a no-op.
treesitter.install(parsers)

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
