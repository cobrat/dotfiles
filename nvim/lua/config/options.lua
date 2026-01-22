-- Set the leader key to space
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Reference to options
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

-- UI and display
opt.termguicolors = true
opt.cursorline = true
opt.scrolloff = 8
opt.mouse = "a"

-- System integration
opt.clipboard = "unnamedplus"

-- Search behavior
opt.ignorecase = true
opt.smartcase = true
