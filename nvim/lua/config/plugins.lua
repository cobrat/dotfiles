local function github(repo)
    return "https://github.com/" .. repo
end

vim.pack.add({
    github("nvim-lua/plenary.nvim"),
    github("stevearc/oil.nvim"),
    github("nvim-treesitter/nvim-treesitter"),
    {
        src = github("nvim-treesitter/nvim-treesitter-textobjects"),
        version = "main",
    },
    github("nvim-telescope/telescope.nvim"),
    github("debugloop/telescope-undo.nvim"),
    {
        src = github("ThePrimeagen/harpoon"),
        version = "harpoon2",
    },
    github("brenoprata10/nvim-highlight-colors"),
    github("lewis6991/gitsigns.nvim"),
    github("nvim-treesitter/nvim-treesitter-context"),
    github("folke/flash.nvim"),
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
        -- quit nvim entirely when oil is the last buffer
        ["<C-c>"] = { "actions.close", opts = { exit_if_last_buf = true }, mode = "n" },
    },
})

-- TELESCOPE

local actions = require("telescope.actions")
local themes = require("telescope.themes")

-- label-jump in the results window; one label per row, so multi-line entry
-- pickers (the <leader>u undo picker) would mis-index
local function flash_results(prompt_bufnr)
    require("flash").jump({
        pattern = "^",
        label = { after = { 0, 0 } },
        search = {
            mode = "search",
            exclude = {
                function(win)
                    return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                end,
            },
        },
        action = function(match)
            local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
            picker:set_selection(match.pos[1] - 1)
        end,
    })
end

require("telescope").setup({
    -- ivy everywhere: bottom pane, prompt top line, borderless results
    defaults = vim.tbl_deep_extend("force", themes.get_ivy(), {
        mappings = {
            i = {
                ["<C-k>"] = actions.move_selection_previous,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
                ["<C-s>"] = flash_results,
            },
            n = {
                ["s"] = flash_results,
            },
        },
    }),
})

-- undo history as an ivy picker: fuzzy filter, diff preview, <CR> restores
require("telescope").load_extension("undo")
vim.keymap.set("n", "<leader>u", function()
    require("telescope").extensions.undo.undo()
end, { desc = "Undo history (telescope)" })

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, { desc = "Recent files" })
vim.keymap.set("n", "<leader>fq", builtin.quickfix, { desc = "Quickfix list" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
vim.keymap.set("n", "<leader>fm", function()
    builtin.man_pages({ sections = { "ALL" } })
end, { desc = "Man pages" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<leader>fg", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "Grep working directory" })
vim.keymap.set("n", "<leader>fc", function()
    builtin.grep_string({ search = vim.fn.expand("%:t:r") })
end, { desc = "Grep current file name" })
vim.keymap.set("n", "<leader>fs", function()
    builtin.grep_string({})
end, { desc = "Grep word under cursor" })
vim.keymap.set("n", "<leader>fi", function()
    builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find files in nvim config" })
vim.keymap.set("n", "<leader>fd", builtin.lsp_document_symbols, { desc = "File symbols" })
vim.keymap.set("n", "<leader>fw", builtin.lsp_dynamic_workspace_symbols,
    { desc = "Workspace symbols" })
vim.keymap.set("n", "<leader>fr", builtin.lsp_references, { desc = "References" })
vim.keymap.set("n", "<leader>fD", builtin.diagnostics, { desc = "Diagnostics" })

-- HARPOON

local harpoon = require("harpoon")
harpoon:setup()

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end,
    { desc = "Add current file to harpoon list" })
vim.keymap.set("n", "<C-e>", function()
    -- harpoon hardcodes border "single" and ignores 'winborder'
    harpoon.ui:toggle_quick_menu(harpoon:list(), { border = "rounded" })
end, { desc = "Toggle harpoon menu" })
vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end, { desc = "Harpoon previous" })
vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end, { desc = "Harpoon next" })

-- STICKY CONTEXT

require("treesitter-context").setup({})

vim.keymap.set("n", "<leader>th", function()
    require("treesitter-context").toggle()
end, { desc = "Toggle sticky context header" })

-- GIT SIGNS

require("gitsigns").setup({
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
        map('n', '<leader>hs', gs.stage_hunk, 'Stage hunk')
        map('n', '<leader>hr', gs.reset_hunk, 'Reset hunk')
        map('n', '<leader>hu', gs.undo_stage_hunk, 'Undo stage hunk')
        map('n', '<leader>hd', gs.diffthis, 'Diff this')
    end,
})

-- STATUSLINE AND COLOR HIGHLIGHTS

require("nvim-highlight-colors").setup({})

-- FLASH

-- defaults kept: f/t stay plain motions, and a unique match in another window
-- never jumps on its own
require("flash").setup({
    prompt = { prefix = {} }, -- drop the default prompt glyph
})

-- rhs must be a function or "<cmd>lua ...<cr>": a ":lua" rhs breaks dot-repeat
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end,
    { desc = "Flash jump" })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end,
    { desc = "Flash treesitter selection" })
vim.keymap.set("c", "<C-s>", function() require("flash").toggle() end,
    { desc = "Toggle flash labels in search" })
