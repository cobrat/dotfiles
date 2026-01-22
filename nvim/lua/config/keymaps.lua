-- Reference to keymap function
local keymap = vim.keymap

-- Save file
keymap.set("n", "<leader>w", ":w<cr>")

-- Quit
keymap.set("n", "<leader>q", ":q<cr>")

-- Clear search highlight
keymap.set("n", "<leader>h", ":nohlsearch<cr>")

-- Move between windows
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-l>", "<C-w>l")
