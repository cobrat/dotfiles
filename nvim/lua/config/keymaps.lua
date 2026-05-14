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

map('n', 'K', function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })

  if #diagnostics > 0 then
    vim.diagnostic.open_float(nil, {
      focus = false,
      scope = 'line',
    })
  else
    vim.lsp.buf.hover()
  end
end, {
  desc = 'Show diagnostics or hover',
})

map('n', 'gd', vim.lsp.buf.definition, {
  desc = 'Go to definition',
})

map('n', 'gD', vim.lsp.buf.declaration, {
  desc = 'Go to declaration',
})

map('n', 'p', 'p`]', {
  desc = 'Paste after cursor and jump to end',
})

map('n', 'P', 'P`]', {
  desc = 'Paste before cursor and jump to end',
})

map('x', 'p', '"_dP`]', {
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

map('n', '[b', '<Cmd>bprevious<CR>', {
  desc = 'Previous buffer',
})

map('n', ']b', '<Cmd>bnext<CR>', {
  desc = 'Next buffer',
})

map('n', '<Leader><Leader>', '<C-^>', {
  desc = 'Alternate buffer',
})

map('n', '<Leader>bd', '<Cmd>bdelete<CR>', {
  desc = 'Delete buffer',
})

map('n', '<Leader>fd', function()
  local abspath = vim.fn.expand('%:p')
  if abspath == '' then
    vim.notify('fzf hunks: buffer has no file path', vim.log.levels.WARN)
    return
  end
  local fzf_path = require('fzf-lua.path')
  local root = fzf_path.git_root({ cwd = vim.fn.expand('%:p:h') }, true)
  if not root then
    vim.notify('fzf hunks: not in a git work tree', vim.log.levels.WARN)
    return
  end
  require('fzf-lua').git_hunks({
    file = fzf_path.relative_to(abspath, root),
  })
end, {
  desc = 'Fzf git hunks (current file)',
})
