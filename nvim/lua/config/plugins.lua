local function github(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({
    github("nvim-lua/plenary.nvim"),
    github("stevearc/oil.nvim"),
    github("hrsh7th/nvim-cmp"),
    github("hrsh7th/cmp-nvim-lsp"),
    github("hrsh7th/cmp-path"),
    github("hrsh7th/cmp-buffer"),
    github("nvim-treesitter/nvim-treesitter"),
    {
        src = github("nvim-treesitter/nvim-treesitter-textobjects"),
        version = "main",
    },
    github("nvim-telescope/telescope.nvim"),
    {
        src = github("ThePrimeagen/harpoon"),
        version = "harpoon2",
    },
    github("brenoprata10/nvim-highlight-colors"),
    github("lewis6991/gitsigns.nvim"),
    github("ojroques/vim-oscyank"),
    github("nvim-treesitter/nvim-treesitter-context"),
}, {
    confirm = false,
})

-- FILE EXPLORER

require("oil").setup({
    columns = {
        "permissions",
        { "size", align = "right" },
        { "mtime", format = "%Y-%m-%d %H:%M" },
    },
    view_options = {
        show_hidden = true,
    },
    keymaps = {
        -- close oil; quit nvim entirely when oil is the last buffer
        -- (default would leave an empty [No Name] buffer behind)
        ["<C-c>"] = { "actions.close", opts = { exit_if_last_buf = true }, mode = "n" },
    },
})

-- COMPLETION

local cmp = require("cmp")
cmp.setup({
    completion = {
        completeopt = "menu,menuone,noinsert",
    },
    window = { documentation = cmp.config.window.bordered() },
    mapping = cmp.mapping.preset.insert({
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item() else fallback() end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then cmp.select_prev_item() end
        end, { "i", "s" }),
    }),
    sources = {
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "buffer", keyword_length = 3 },
    },
})

-- TELESCOPE

local actions = require("telescope.actions")
local themes = require("telescope.themes")
require("telescope").setup({
    -- ivy everywhere: bottom pane, prompt top line, borderless results
    defaults = vim.tbl_deep_extend("force", themes.get_ivy(), {
        mappings = {
            i = {
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
            },
        },
    }),
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fo", builtin.oldfiles)
vim.keymap.set("n", "<leader>fq", builtin.quickfix)
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set("n", "<leader>fm", function()
    builtin.man_pages({ sections = { "ALL" } })
end, { desc = "Telescope man pages" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<leader>fg", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "<leader>fc", function()
    builtin.grep_string({ search = vim.fn.expand("%:t:r") })
end, { desc = "Find current file" })
vim.keymap.set("n", "<leader>fs", function()
    builtin.grep_string({})
end, { desc = "Find current string" })
vim.keymap.set("n", "<leader>fi", function()
    builtin.find_files({ cwd = "~/.config/nvim/" })
end)

-- HARPOON

local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)

vim.keymap.set("n", "<leader>fl", function()
    local conf = require("telescope.config").values
    local file_paths = {}
    for _, item in ipairs(harpoon:list().items) do
        table.insert(file_paths, item.value)
    end
    require("telescope.pickers").new(themes.get_ivy({ prompt_title = "Working List" }), {
        finder = require("telescope.finders").new_table({ results = file_paths }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end, { desc = "Open harpoon window" })

-- STICKY CONTEXT

require("treesitter-context").setup({})

vim.keymap.set("n", "<leader>th", function()
    require("treesitter-context").toggle()
end, { desc = "Toggle sticky context header" })

-- GIT SIGNS

require("gitsigns").setup({
    preview_config = { border = 'single' }, -- thin FloatBorder-styled frame (see theme.lua)
    signs = { -- ascii-only, no nerd font needed
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '-' },
        changedelete = { text = '~' },
        untracked    = { text = '?' },
    },
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map('n', ']h', gs.next_hunk, 'Next git hunk')
        map('n', '[h', gs.prev_hunk, 'Previous git hunk')
        map('n', '<leader>hp', gs.preview_hunk, 'Preview git hunk')
        map('n', '<leader>hb', gs.blame_line, 'Blame current line')
    end,
})

-- STATUSLINE AND COLOR HIGHLIGHTS

require("nvim-highlight-colors").setup({})
