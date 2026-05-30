local map = vim.keymap.set

local function close_buffer()
  if vim.bo.buflisted then
    vim.cmd.bdelete()
  else
    vim.cmd.close()
  end
end

local function center_view()
  local win = vim.api.nvim_get_current_win()
  local height = vim.api.nvim_win_get_height(win)
  local cursor = vim.api.nvim_win_get_cursor(win)[1]
  local last = vim.api.nvim_buf_line_count(0)
  local margin = math.floor(height / 2)
  if cursor <= margin or cursor > last - margin then
    return
  end
  vim.cmd.normal({ 'zz', bang = true })
end

map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

for _, key in ipairs({ 'n', 'N' }) do
  map('n', key, function()
    vim.cmd.normal({ vim.v.count1 .. key, bang = true })
    center_view()
  end, {
    desc = key == 'n' and 'Next search match and center'
      or 'Previous search match and center',
  })
end

map('n', '<leader>e', '<cmd>Oil<cr>', { desc = 'Open file explorer' })
map('n', '<leader>q', close_buffer, { desc = 'Close buffer' })
map('n', '<leader><leader>', '<C-^>', { desc = 'Previous buffer' })
map('n', '<leader>ff', '<cmd>FzfLua files<cr>', { desc = 'Find files' })
map('n', '<leader>fg', '<cmd>FzfLua live_grep<cr>', { desc = 'Live grep' })
map('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', { desc = 'Pick buffer' })
map('n', '<leader>fd', '<cmd>FzfLua diagnostics_document<cr>', { desc = 'Document diagnostics' })
map('n', '<leader>fD', '<cmd>FzfLua diagnostics_workspace<cr>', { desc = 'Workspace diagnostics' })

map('n', '<leader>gf', '<cmd>FzfLua git_files<cr>', { desc = 'Git files' })
map('n', '<leader>gs', '<cmd>FzfLua git_status<cr>', { desc = 'Git status' })
map('n', '<leader>gh', '<cmd>FzfLua git_hunks<cr>', { desc = 'Git hunks' })

map({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to clipboard' })
map('n', '<leader>Y', '"+Y', { desc = 'Yank line to clipboard' })
map({ 'n', 'x' }, '<leader>d', '"_d', { desc = 'Delete without yanking' })

map('n', 'K', function()
  local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
  if #diagnostics > 0 then
    vim.diagnostic.open_float(nil, { focus = false, scope = 'line' })
  else
    vim.lsp.buf.hover()
  end
end, { desc = 'Line diagnostics or LSP hover' })

map('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
map('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })

map('n', 'Q', '<nop>', { desc = 'Disable Ex mode' })
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })
map('n', 'J', 'mzJ`z', { desc = 'Join line without moving cursor' })

map('x', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('x', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
map('x', '<', '<gv', { desc = 'Unindent selection' })
map('x', '>', '>gv', { desc = 'Indent selection' })
map('x', '<leader>p', [["_dP]], { desc = 'Paste without overwriting register' })
