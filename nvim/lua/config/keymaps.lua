local map = vim.keymap.set

map('x', '<', '<gv', {
  desc = 'Unindent selection',
})

map('x', '>', '>gv', {
  desc = 'Indent selection',
})

map('x', 'J', ":move '>+1<CR>gv=gv", {
  desc = 'Move selection down',
})

map('x', 'K', ":move '<-2<CR>gv=gv", {
  desc = 'Move selection up',
})

map('x', 'p', '"_dP', {
  desc = 'Paste without yanking selection',
})

map({ 'n', 'x' }, '<Leader>d', '"_d', {
  desc = 'Delete without yank',
})

map('n', 'n', 'nzzzv', {
  desc = 'Next search match',
})

map('n', 'N', 'Nzzzv', {
  desc = 'Previous search match',
})

map('n', '<Leader>n', '<Cmd>nohlsearch<CR>', {
  desc = 'Clear search highlight',
})

map({ 'n', 'x' }, '<Leader>bf', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, {
  desc = 'Format buffer or visual selection',
})

map('n', '<C-h>', '<C-w>h', {
  desc = 'Move to left split',
})

map('n', '<C-j>', '<C-w>j', {
  desc = 'Move to lower split',
})

map('n', '<C-k>', '<C-w>k', {
  desc = 'Move to upper split',
})

map('n', '<C-l>', '<C-w>l', {
  desc = 'Move to right split',
})

map('n', '<Leader>sv', '<Cmd>vsplit<CR>', {
  desc = 'Vertical split',
})

map('n', '<Leader>sh', '<Cmd>split<CR>', {
  desc = 'Horizontal split',
})

map('n', '<Leader>e', function()
  require('oil').toggle_float()
end, {
  desc = 'Edit directory',
})

map('n', '<Leader>?', function()
  vim.cmd.edit(vim.fn.stdpath('config') .. '/cheatsheet.md')
end, {
  desc = 'Open cheatsheet',
})

map('n', '<Leader>ff', '<Cmd>FzfLua files<CR>', {
  desc = 'Find files',
})

map('n', '<Leader>fg', '<Cmd>FzfLua live_grep<CR>', {
  desc = 'Live grep',
})

map('n', '<Leader>fb', '<Cmd>FzfLua buffers<CR>', {
  desc = 'Find buffers',
})
