-- ┌─────────────────┐
-- │ Custom mappings │
-- └─────────────────┘

local mini_diff = require('mini.diff')
local mini_git = require('mini.git')

-- General mappings ===========================================================

local map = function(modes, lhs, rhs, desc)
  local opts = type(desc) == 'table' and desc or { desc = desc }
  vim.keymap.set(modes, lhs, rhs, opts)
end

local nmap = function(lhs, rhs, desc)
  map('n', lhs, rhs, desc)
end

-- Native completion popup navigation. Accept selection with <C-y>.
map('i', '<Tab>',
  function() return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>' end,
  { expr = true, desc = 'Pum next or Tab' })
map('i', '<S-Tab>',
  function() return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>' end,
  { expr = true, desc = 'Pum prev or S-Tab' })

-- K: diagnostic float if cursor line has one, else LSP hover.
nmap('K', function()
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  if #vim.diagnostic.get(0, { lnum = lnum }) > 0 then
    vim.diagnostic.open_float()
  else
    vim.lsp.buf.hover()
  end
end, { desc = 'Hover or diagnostic' })

-- Leader mappings ============================================================
-- <Leader> = <Space>. Two-key groups: first key = category, second = action.

-- stylua: ignore start
local lmap = function(modes, suffix, rhs, desc)
  map(modes, '<Leader>' .. suffix, rhs, desc)
end

local conform_format = function()
  require('conform').format({ async = true })
end

-- b is for 'Buffer'
-- Delete/wipe a buffer without closing its window: switch to alt or
-- a fresh listed buffer first, then drop the original.
local function buf_drop(action)
  local cur = vim.api.nvim_get_current_buf()
  local alt = vim.fn.bufnr('#')
  for _, win in ipairs(vim.fn.win_findbuf(cur)) do
    vim.api.nvim_win_call(win, function()
      if alt > 0 and alt ~= cur and vim.api.nvim_buf_is_valid(alt) then
        vim.api.nvim_set_current_buf(alt)
      else
        vim.cmd('enew')
      end
    end)
  end
  if vim.api.nvim_buf_is_valid(cur) then
    pcall(function() vim.cmd(action .. ' ' .. cur) end)
  end
end

lmap('n', 'bd', function() buf_drop('bdelete')  end, 'Delete buffer')
lmap('n', 'bw', function() buf_drop('bwipeout') end, 'Wipeout buffer')

-- e is for 'Explore'
local explore_at_file = function()
  require('mini.files').open(vim.api.nvim_buf_get_name(0))
end
local explore_quickfix = function()
  local is_open = vim.fn.getqflist({ winid = true }).winid ~= 0
  vim.cmd(is_open and 'cclose' or 'copen')
end
local explore_locations = function()
  local is_open = vim.fn.getloclist(0, { winid = true }).winid ~= 0
  if is_open then
    vim.cmd('lclose')
    return
  end

  if vim.tbl_isempty(vim.fn.getloclist(0)) then
    vim.notify('Location list is empty', vim.log.levels.INFO)
    return
  end

  vim.cmd('lopen')
end

lmap('n', 'ee', function() require('mini.files').open() end, 'Explorer')
lmap('n', 'ef', explore_at_file,                           'Explorer at file')
lmap('n', 'em', '<Cmd>messages<CR>',                       'Messages')
lmap('n', 'eq', explore_quickfix,                          'Quickfix list')
lmap('n', 'el', explore_locations,                         'Location list')

-- f is for 'Fuzzy Find' (mini.pick; requires `ripgrep` for ff/fg).
-- Other pickers via `:Pick <Tab>`.
lmap('n', 'ff', '<Cmd>Pick files<CR>',     'Files')
lmap('n', 'fg', '<Cmd>Pick grep_live<CR>', 'Grep live')
lmap('n', 'fb', '<Cmd>Pick buffers<CR>',   'Buffers')
lmap('n', 'fh', '<Cmd>Pick help<CR>',      'Help tags')
lmap('n', 'fr', '<Cmd>Pick resume<CR>',    'Resume')

-- g is for 'Git'. Use `:Git <subcmd>` for commit/diff/log directly.
local diff_overlay  = function() mini_diff.toggle_overlay() end
local git_at_cursor = function() mini_git.show_at_cursor() end
lmap('n',          'go', diff_overlay,  'Diff overlay')
lmap({ 'n', 'x' }, 'gs', git_at_cursor, 'Show at cursor')

-- l is for 'Language' (LSP)
-- K still handles hover, or diagnostic details on the current line.
lmap({ 'n', 'x' }, 'la', vim.lsp.buf.code_action,      'Code action')
lmap('n',          'ld', vim.lsp.buf.definition,       'Definition')
lmap({ 'n', 'x' }, 'lf', conform_format,               'Format')
lmap('n',          'li', vim.lsp.buf.implementation,   'Implementation')
lmap('n',          'lr', vim.lsp.buf.rename,           'Rename')
lmap('n',          'lt', vim.lsp.buf.type_definition,  'Type definition')

-- stylua: ignore end
