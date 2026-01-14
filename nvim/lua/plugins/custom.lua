return {
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "tokyonight-night",
        },
    },
    {
        "nvim-lspconfig",
        opts = {
            inlay_hints = { enabled = false },
        },
    },
    {
        "saghen/blink.cmp",
        opts = {
            keymap = {
                preset = "none",
                ["<CR>"] = { "fallback" },
                ["<Tab>"] = { "select_and_accept", "fallback" },
                -- ["<C-space>"] = { "show", "show_documentation", "hide" },
                ["<C-e>"] = { "hide" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
            },
            completion = {
                ghost_text = { enabled = false },
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = false,
                    },
                },
                menu = {
                    auto_show = true,
                },
            },
        },
    },
}
