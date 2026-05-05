local map = vim.keymap.set

map({ 'n', 'x' }, 'j', 'v:count == 0 ? "gj" : "j"', {
  expr = true,
  desc = 'Move down by display line',
})

map({ 'n', 'x' }, 'k', 'v:count == 0 ? "gk" : "k"', {
  expr = true,
  desc = 'Move up by display line',
})

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

map('n', '<C-l>', '<Cmd>nohlsearch<CR>', {
  desc = 'Clear search highlight',
})

map({ 'n', 'x' }, '<Leader>bf', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, {
  desc = 'Format buffer or visual selection',
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
