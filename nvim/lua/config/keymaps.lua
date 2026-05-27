local map = vim.keymap.set

-- Close listed buffers with :bdelete; for scratch/special buffers, drop the
-- window with :close so we don't have to spin up a [No Name] placeholder.
local function close_buffer()
  if vim.bo.buflisted then
    vim.cmd.bdelete()
  else
    vim.cmd.close()
  end
end

-- zz in the middle of the buffer only; skip near edges to avoid a view snap.
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

-- wrap: j/k jump by buffer line; gj/gk move one screen line (no vertical snap).
map({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })
map({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })

-- normal!: avoid recursive maps. v:count1 keeps prefixes like `5n` working.
local function map_search(key)
  map('n', key, function()
    vim.cmd.normal({ vim.v.count1 .. key, bang = true })
    center_view()
  end, { desc = key == 'n' and 'Next search match and center'
    or 'Previous search match and center' })
end

-- Files and buffers
map('n', '<leader>e', '<cmd>Oil<cr>', { desc = 'Open file explorer' })
map('n', '<leader>q', close_buffer, { desc = 'Close buffer' })
map('n', '<leader><leader>', '<C-^>', { desc = 'Previous buffer' })
map('n', '<leader>ff', '<cmd>FzfLua files<cr>', { desc = 'Find files' })
map('n', '<leader>fg', '<cmd>FzfLua live_grep<cr>', { desc = 'Live grep' })
map('n', '<leader>fb', '<cmd>FzfLua buffers<cr>', { desc = 'Pick buffer' })
map('n', '<leader>u', '<cmd>UndotreeToggle<cr>', { desc = 'Toggle undotree' })

map({ 'n', 'x' }, '<leader>y', '"+y', { desc = 'Yank to clipboard' })
map('n', '<leader>Y', '"+Y', { desc = 'Yank line to clipboard' })
map({ 'n', 'x' }, '<leader>d', '"_d', { desc = 'Delete without yanking' })

map('n', 'Q', '<nop>', { desc = 'Disable Ex mode' })
map('n', '<Esc>', '<cmd>nohlsearch<cr>', { desc = 'Clear search highlight' })

map('n', 'J', 'mzJ`z', { desc = 'Join line without moving cursor' })
map_search('n')
map_search('N')

-- Visual: keep selection after indent/move; paste without touching register 0.
map('x', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('x', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
map('x', '<', '<gv', { desc = 'Unindent selection' })
map('x', '>', '>gv', { desc = 'Indent selection' })
map('x', '<leader>p', [["_dP]], { desc = 'Paste without overwriting register' })

for key, dir in pairs({ h = 'left', j = 'lower', k = 'upper', l = 'right' }) do
  map('n', '<C-' .. key .. '>', '<C-w>' .. key, {
    desc = 'Move to ' .. dir .. ' window',
  })
end

for _, spec in ipairs({
  { '<A-h>', '<C-w><', 'Decrease window width' },
  { '<A-l>', '<C-w>>', 'Increase window width' },
  { '<A-j>', '<C-w>-', 'Decrease window height' },
  { '<A-k>', '<C-w>+', 'Increase window height' },
}) do
  map('n', spec[1], spec[2], { desc = spec[3] })
end
