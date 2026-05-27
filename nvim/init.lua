-- Load order: options and plugins before keymaps (maps call Oil/FzfLua) and
-- autocmds (yank highlight uses 0.13 vim.hl API).
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- oil replaces netrw; must be set before plugins/runtime load it.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require('config.options')
require('config.plugins')
require('config.keymaps')
require('config.autocmds')
