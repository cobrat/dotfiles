vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = 'a'
opt.clipboard = 'unnamedplus'
opt.undofile = true

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 8
opt.signcolumn = 'yes'
opt.termguicolors = true
opt.cursorline = true
opt.wrap = false

opt.updatetime = 250
opt.timeoutlen = 500

local map = vim.keymap.set

map('n', '<Leader>w', '<Cmd>write<CR>', { desc = 'Write file' })
map('n', '<Leader>q', '<Cmd>quit<CR>', { desc = 'Quit window' })
map('n', '<Leader>h', '<Cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

map('n', '<C-h>', '<C-w>h', { desc = 'Move to left split' })
map('n', '<C-j>', '<C-w>j', { desc = 'Move to lower split' })
map('n', '<C-k>', '<C-w>k', { desc = 'Move to upper split' })
map('n', '<C-l>', '<C-w>l', { desc = 'Move to right split' })

map('n', '<Leader>sv', '<Cmd>vsplit<CR>', { desc = 'Vertical split' })
map('n', '<Leader>sh', '<Cmd>split<CR>', { desc = 'Horizontal split' })
