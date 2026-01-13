-- ~/.config/nvim/lua/keymaps.lua
local keymap = vim.keymap.set
local s = { silent = true }

-- Set leader key
vim.g.mapleader = " "
keymap("n", "<space>", "<Nop>")

-- Smart movement for wrapped lines
keymap("n", "j", function()
    return tonumber(vim.api.nvim_get_vvar("count")) > 0 and "j" or "gj"
end, { expr = true, silent = true })
keymap("n", "k", function()
    return tonumber(vim.api.nvim_get_vvar("count")) > 0 and "k" or "gk"
end, { expr = true, silent = true })

-- Centered scrolling
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- File operations
keymap("n", "<Leader>w", "<cmd>w!<CR>", s) -- Save file
keymap("n", "<Leader>q", "<cmd>q<CR>", s) -- Quit Neovim
keymap("n", "<leader>cd", '<cmd>lua vim.fn.chdir(vim.fn.expand("%:p:h"))<CR>') -- Change directory

-- Window and Tab management
keymap("n", "<Leader>te", "<cmd>tabnew<CR>", s) -- New tab
keymap("n", "<Leader>_", "<cmd>vsplit<CR>", s) -- Vertical split
keymap("n", "<Leader>-", "<cmd>split<CR>", s) -- Horizontal split

-- LSP shortcuts
keymap("n", "<Leader>fo", ":lua vim.lsp.buf.format()<CR>", s) -- Format code
keymap("n", "grd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true }) -- Go to definition

-- Clipboard and Visual mode
keymap("v", "<Leader>p", '"_dP') -- Paste without overwriting register
keymap("x", "y", [["+y]], s) -- Yank to system clipboard

-- Terminal mode
keymap("t", "<Esc>", "<C-\\><C-N>") -- Exit terminal mode

-- Netrw
keymap("n", "<Leader>ex", "<cmd>Ex %:p:h<CR>") -- Open Netrw in the current file's directory

-- Fzf
keymap("n", "<leader>ff", '<cmd>FzfLua files<CR>')
keymap("n", "<leader>fg", '<cmd>FzfLua live_grep<CR>')

-- Miniharp
keymap("n", "<leader>m", '<cmd>lua require("miniharp").toggle_file()<CR>')
keymap("n", "<leader>l", '<cmd>lua require("miniharp").show_list()<CR>')
keymap("n", "<C-n>", require("miniharp").next)
keymap("n", "<C-p>", require("miniharp").prev)

-- Plugins
keymap("n", "<leader>ps", '<cmd>lua vim.pack.update()<CR>')
