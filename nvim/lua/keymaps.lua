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
keymap("n", "<Leader>w", "<cmd>w!<CR>", s)                                     -- Save file
keymap("n", "<Leader>q", "<cmd>q<CR>", s)                                      -- Quit Neovim
keymap("n", "<leader>cd", '<cmd>lua vim.fn.chdir(vim.fn.expand("%:p:h"))<CR>') -- Change directory

-- Window, Tab, Buffer management
keymap("n", "<Leader>t", "<cmd>tabnew<CR>", s) -- New tab
keymap("n", "<Leader>-", "<cmd>vsplit<CR>", s)  -- Vertical split
keymap("n", "<Leader>'", "<cmd>split<CR>", s)   -- Horizontal split
keymap('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
keymap('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
keymap('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })
keymap('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })
keymap('n', '<S-h>', '<cmd>tabprevious<cr>', { desc = 'Previous tab' })
keymap('n', '<S-l>', '<cmd>tabnext<cr>', { desc = 'Next tab' })
keymap('n', '<leader>bl', '<cmd>FzfLua buffers<cr>', { desc = 'List buffers' })
vim.keymap.set('n', '<leader>l', 'g<Tab>', { desc = 'Switch to last tab' })
keymap('n', '<leader>Q', '<cmd>qa<cr>', { desc = 'Quit Neovim' })

-- LSP shortcuts
keymap("n", "<Leader>bf", ":lua vim.lsp.buf.format()<CR>", s)                                  -- Format code
keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true }) -- Go to definition
keymap('n', '<leader>be', vim.diagnostic.open_float, { desc = 'Show diagnostic' })

-- Clipboard and Visual mode
keymap("v", "<Leader>p", '"_dP') -- Paste without overwriting register
keymap("x", "y", [["+y]], s)     -- Yank to system clipboard

-- Terminal mode
-- keymap("t", "<Esc>", "<C-\\><C-N>") -- Exit terminal mode

-- Netrw
keymap("n", "<Leader>e", "<cmd>Ex %:p:h<CR>") -- Open Netrw in the current file's directory

-- Fzf
keymap("n", "<leader>ff", '<cmd>FzfLua files<CR>')
keymap("n", "<leader>fg", '<cmd>FzfLua live_grep<CR>')

-- Plugins
keymap("n", "<leader>ps", '<cmd>lua vim.pack.update()<CR>')
