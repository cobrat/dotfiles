-- ┌─────────────────┐
-- │ Custom mappings │
-- └─────────────────┘

-- General mappings ===========================================================

local nmap = function(lhs, rhs, desc)
  vim.keymap.set('n', lhs, rhs, { desc = desc })
end

nmap('<Esc>', '<Cmd>nohlsearch<CR>', 'Clear search highlight')

-- Paste linewise before/after current line
nmap('[p', '<Cmd>exe "put! " . v:register<CR>', 'Paste Above')
nmap(']p', '<Cmd>exe "put "  . v:register<CR>', 'Paste Below')

-- Many general mappings are created by 'mini.basics'. See 'plugin/30_mini.lua'

-- Leader mappings ============================================================
-- <Leader> = <Space>. Two-key groups: first key = category, second = action.
-- Many mappings rely on 'mini.nvim' modules set up in 'plugin/30_mini.lua'.

-- stylua: ignore start
-- Leader group descriptions used by 'mini.clue'
Config.leader_group_clues = {
  { mode = 'n', keys = '<Leader>b', desc = '+Buffer' },
  { mode = 'n', keys = '<Leader>e', desc = '+Explore/Edit' },
  { mode = 'n', keys = '<Leader>f', desc = '+Find' },
  { mode = 'n', keys = '<Leader>g', desc = '+Git' },
  { mode = 'n', keys = '<Leader>l', desc = '+Language' },
  { mode = 'n', keys = '<Leader>o', desc = '+Other' },

  { mode = 'x', keys = '<Leader>g', desc = '+Git' },
  { mode = 'x', keys = '<Leader>l', desc = '+Language' },
}

local nmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, { desc = desc })
end
local xmap_leader = function(suffix, rhs, desc)
  vim.keymap.set('x', '<Leader>' .. suffix, rhs, { desc = desc })
end

local conform_format = function(opts)
  opts = vim.tbl_extend(
    'force',
    { async = true, lsp_format = 'fallback' },
    opts or {}
  )
  require('conform').format(opts)
end

-- b is for 'Buffer'
local new_scratch_buffer = function()
  vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end

nmap_leader('ba', '<Cmd>b#<CR>',                                 'Alternate')
nmap_leader('bd', function() require('mini.bufremove').delete() end, 'Delete')
nmap_leader('bD',
  function() require('mini.bufremove').delete(0, true) end,
  'Delete!')
nmap_leader('bs', new_scratch_buffer,                            'Scratch')
nmap_leader('bw', function() require('mini.bufremove').wipeout() end, 'Wipeout')
nmap_leader('bW',
  function() require('mini.bufremove').wipeout(0, true) end,
  'Wipeout!')

-- e is for 'Explore' and 'Edit'
local edit_plugin_file = function(filename)
  local path = vim.fs.joinpath(vim.fn.stdpath('config'), 'plugin', filename)
  return string.format('<Cmd>edit %s<CR>', vim.fn.fnameescape(path))
end
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

nmap_leader('ed', function() require('mini.files').open() end, 'Directory')
nmap_leader('ef', explore_at_file,                          'File directory')
nmap_leader('ei', '<Cmd>edit $MYVIMRC<CR>',                 'init.lua')
nmap_leader('ek', edit_plugin_file('20_keymaps.lua'),       'Keymaps config')
nmap_leader('em', edit_plugin_file('30_mini.lua'),          'MINI config')
nmap_leader('en', function() MiniNotify.show_history() end, 'Notifications')
nmap_leader('eo', edit_plugin_file('10_options.lua'),       'Options config')
nmap_leader('ep', edit_plugin_file('40_plugins.lua'),       'Plugins config')
nmap_leader('eq', explore_quickfix,                         'Quickfix list')
nmap_leader('eQ', explore_locations,                        'Location list')

-- f is for 'Fuzzy Find' (uses 'mini.pick'; requires `ripgrep` for ff/fg)
local pick_added_hunks_buf =
  '<Cmd>Pick git_hunks path="%" scope="staged"<CR>'
local pick_workspace_symbols_live =
  '<Cmd>Pick lsp scope="workspace_symbol_live"<CR>'

nmap_leader('f/', '<Cmd>Pick history scope="/"<CR>',    '"/" history')
nmap_leader('f:', '<Cmd>Pick history scope=":"<CR>',    '":" history')
nmap_leader('fa', '<Cmd>Pick git_hunks scope="staged"<CR>', 'Added hunks (all)')
nmap_leader('fA', pick_added_hunks_buf,                 'Added hunks (buf)')
nmap_leader('fb', '<Cmd>Pick buffers<CR>',              'Buffers')
nmap_leader('fc', '<Cmd>Pick git_commits<CR>',          'Commits (all)')
nmap_leader('fC', '<Cmd>Pick git_commits path="%"<CR>', 'Commits (buf)')
nmap_leader('fd',
  '<Cmd>Pick diagnostic scope="all"<CR>',   'Diagnostic workspace')
nmap_leader('fD',
  '<Cmd>Pick diagnostic scope="current"<CR>', 'Diagnostic buffer')
nmap_leader('ff', '<Cmd>Pick files<CR>',                'Files')
nmap_leader('fg', '<Cmd>Pick grep_live<CR>',            'Grep live')
nmap_leader('fG',
  '<Cmd>Pick grep pattern="<cword>"<CR>',   'Grep current word')
nmap_leader('fh', '<Cmd>Pick help<CR>',                 'Help tags')
nmap_leader('fH', '<Cmd>Pick hl_groups<CR>',            'Highlight groups')
nmap_leader('fl', '<Cmd>Pick buf_lines scope="all"<CR>',    'Lines (all)')
nmap_leader('fL', '<Cmd>Pick buf_lines scope="current"<CR>', 'Lines (buf)')
nmap_leader('fm', '<Cmd>Pick git_hunks<CR>',            'Modified hunks (all)')
nmap_leader('fM', '<Cmd>Pick git_hunks path="%"<CR>',   'Modified hunks (buf)')
nmap_leader('fr', '<Cmd>Pick resume<CR>',               'Resume')
nmap_leader('fR', '<Cmd>Pick lsp scope="references"<CR>', 'References (LSP)')
nmap_leader('fs',
  pick_workspace_symbols_live,          'Symbols workspace (live)')
nmap_leader('fS',
  '<Cmd>Pick lsp scope="document_symbol"<CR>', 'Symbols document')

-- g is for 'Git'
local git_log_cmd =
  [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_log_buf_cmd = git_log_cmd .. ' --follow -- %'

nmap_leader('ga', '<Cmd>Git diff --cached<CR>',             'Added diff')
nmap_leader('gA', '<Cmd>Git diff --cached -- %<CR>',        'Added diff buffer')
nmap_leader('gc', '<Cmd>Git commit<CR>',                    'Commit')
nmap_leader('gC', '<Cmd>Git commit --amend<CR>',            'Commit amend')
nmap_leader('gd', '<Cmd>Git diff<CR>',                      'Diff')
nmap_leader('gD', '<Cmd>Git diff -- %<CR>',                 'Diff buffer')
nmap_leader('gl', '<Cmd>' .. git_log_cmd .. '<CR>',         'Log')
nmap_leader('gL', '<Cmd>' .. git_log_buf_cmd .. '<CR>',     'Log buffer')
nmap_leader('go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>', 'Toggle overlay')
nmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>',  'Show at cursor')

xmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>', 'Show at selection')

-- l is for 'Language' (LSP)
-- NOTE: overrides built-in `gr` with 'mini.operators' replace operator.
nmap_leader('la', '<Cmd>lua vim.lsp.buf.code_action()<CR>',     'Actions')
nmap_leader('ld',
  '<Cmd>lua vim.diagnostic.open_float()<CR>',   'Diagnostic popup')
nmap_leader('lf', conform_format,                              'Format')
nmap_leader('li',
  '<Cmd>lua vim.lsp.buf.implementation()<CR>',  'Implementation')
nmap_leader('lh', '<Cmd>lua vim.lsp.buf.hover()<CR>',           'Hover')
nmap_leader('lr', '<Cmd>lua vim.lsp.buf.rename()<CR>',          'Rename')
nmap_leader('lR', '<Cmd>lua vim.lsp.buf.references()<CR>',      'References')
nmap_leader('ls',
  '<Cmd>lua vim.lsp.buf.definition()<CR>',      'Source definition')
nmap_leader('lt',
  '<Cmd>lua vim.lsp.buf.type_definition()<CR>', 'Type definition')

xmap_leader('lf', conform_format, 'Format selection')

-- o is for 'Other'
nmap_leader('or',
  function() MiniMisc.resize_window() end, 'Resize to default width')
nmap_leader('ot',
  function() require('mini.trailspace').trim() end, 'Trim trailspace')
nmap_leader('oz', function() MiniMisc.zoom() end,          'Zoom toggle')

-- stylua: ignore end
