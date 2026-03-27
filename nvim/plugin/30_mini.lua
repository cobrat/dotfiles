-- ┌────────────────────┐
-- │ MINI configuration │
-- └────────────────────┘
-- Each module is enabled via `require('mini.xxx').setup()`.
-- See `:h mini.nvim-general-principles`.

local now, now_if_args, later = Config.now, Config.now_if_args, Config.later

-- Step one ===================================================================

-- Color scheme (miniwinter from mini.nvim)
-- now(function() vim.cmd('colorscheme miniwinter') end)
-- now(function() vim.cmd('colorscheme minispring') end)
-- now(function() vim.cmd('colorscheme minisummer') end)
-- now(function() vim.cmd('colorscheme miniautumn') end)
-- now(function() vim.cmd('colorscheme randomhue') end)

-- Common presets: options, mappings, autocommands.
-- Notable mappings: `<C-s>` save, `go`/`gO` empty lines, `gy`/`gp` clipboard,
-- `\` toggles, `<C-hjkl>` window nav, `<M-hjkl>` insert/command nav.
now(function()
  require('mini.basics').setup({
    options = { basic = false }, -- managed in 'plugin/10_options.lua'
    mappings = {
      windows = true,       -- <C-hjkl> window navigation
      move_with_alt = true, -- <M-hjkl> in Insert/Command mode
    },
  })
end)

-- Disable icons globally: mini.icons is always require-able as part of
-- mini.nvim, so we set it up then override get() to suppress all icons.
now(function()
  require('mini.icons').setup()
  MiniIcons.get = function(_, _) return '', 'MiniIconsGrey', false end
end)

-- Notifications in upper-right corner. `<Leader>en` shows history.
now(function() require('mini.notify').setup() end)

-- Statusline. Layout (left → right):
--   [mode] [branch +~/~/-] | filename | [fileinfo] [search] [location]
now(function()
  -- Custom git+diff section: "main +2 ~1 -0"
  local function git_diff(trunc_width)
    if MiniStatusline.is_truncated(trunc_width) then return '' end
    local str = vim.b.minigit_summary_string or ''
    local branch = str:match('^%S+') or ''
    if branch == '' then return '' end
    -- Truncate full commit hash (detached HEAD) to 8 chars
    if #branch > 12 and branch:match('^%x+$') then
      branch = branch:sub(1, 8)
    end
    local d = vim.b.minidiff_summary
    local parts = { branch }
    if d then
      if (d.add    or 0) > 0 then parts[#parts+1] = '+' .. d.add    end
      if (d.change or 0) > 0 then parts[#parts+1] = '~' .. d.change end
      if (d.delete or 0) > 0 then parts[#parts+1] = '-' .. d.delete end
    end
    return table.concat(parts, ' ')
  end

  require('mini.statusline').setup({
    use_icons = false,
    content = {
      active = function()
        local mode, mode_hl =
          MiniStatusline.section_mode({ trunc_width = 0 })
        local git       = git_diff(60)
        local filename  =
          MiniStatusline.section_filename({ trunc_width = 140 })
        local fileinfo  = (function()
          if MiniStatusline.is_truncated(80) then return '' end
          local size = math.max(vim.fn.line2byte(vim.fn.line('$') + 1) - 1, 0)
          if size < 1024 then return size .. 'B'
          elseif size < 1048576 then
            return string.format('%.2fKiB', size / 1024)
          else return string.format('%.2fMiB', size / 1048576) end
        end)()
        local location  =
          MiniStatusline.section_location({ trunc_width = 60 })
        local search    =
          MiniStatusline.section_searchcount({ trunc_width = 80 })

        return MiniStatusline.combine_groups({
          { hl = mode_hl,                 strings = { mode } },
          { hl = 'MiniStatuslineDevinfo', strings = { git } },
          '%<', -- truncate here when window is narrow
          { hl = 'MiniStatuslineFilename', strings = { filename } },
          '%=', -- right-align everything after this
          { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
          { hl = mode_hl,                  strings = { search, location } },
        })
      end,
    },
  })
end)

-- Tabline: listed buffers at the top. Navigate with `[b` and `]b`.
now(function() require('mini.tabline').setup({ show_icons = false }) end)

-- Step one or two ============================================================

-- Completion (async two-stage: LSP then keyword fallback) + signature help.
-- `<Tab>`/`<S-Tab>` navigate menu, `<C-n>`/`<C-p>` also work, `<C-e>` abort.
now_if_args(function()
  local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }
  local process_items = function(items, base)
    return MiniCompletion.default_process_items(
      items, base, process_items_opts)
  end
  require('mini.completion').setup({
    lsp_completion = {
      source_func = 'omnifunc', -- cleaner setup; enables `<C-u>`
      auto_setup = false,
      process_items = process_items,
    },
  })

  -- Set 'omnifunc' only when an LSP attaches
  local on_attach = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp'
  end
  Config.new_autocmd('LspAttach', nil, on_attach, "Set 'omnifunc'")

  vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })
end)

-- File explorer (Miller columns). `l`/`h` navigate in/out, `g?` for help.
-- Manipulate by editing buffer text, then `=` to sync.
now_if_args(function()
  require('mini.files').setup({
    mappings = {
      close      = '<Esc>',
      go_in_plus = '<CR>',
    },
  })

  -- Bookmarks available inside explorer (press `'c`, `'p`, etc.)
  local add_marks = function()
    MiniFiles.set_bookmark('c', vim.fn.stdpath('config'), { desc = 'Config' })
    local vimpack = vim.fn.stdpath('data') .. '/site/pack/core/opt'
    MiniFiles.set_bookmark('p', vimpack, { desc = 'Plugins' })
    MiniFiles.set_bookmark('w', vim.fn.getcwd, { desc = 'Working directory' })
  end
  Config.new_autocmd('User', 'MiniFilesExplorerOpen', add_marks, 'Add bookmarks')
end)

-- Misc utilities: put(), zoom, auto-root, cursor restore.
now_if_args(function()
  require('mini.misc').setup()
  MiniMisc.setup_auto_root()      -- cd to project root on file open
  MiniMisc.setup_restore_cursor() -- restore cursor position on reopen
end)

-- Step two ===================================================================

-- Extra mini.nvim functionality: pickers, ai specs, highlighters.
later(function() require('mini.extra').setup() end)

-- Extended a/i textobjects. Adds next/last variants and more targets.
later(function()
  local ai = require('mini.ai')
  ai.setup({
    custom_textobjects = {
      B = MiniExtra.gen_ai_spec.buffer(), -- whole buffer
      -- `aF`/`iF` = around/inside function definition (tree-sitter)
      F = ai.gen_spec.treesitter(
        { a = '@function.outer', i = '@function.inner' }),
    },
    -- Search only covering textobject; use `an`/`in`/`al`/`il` for next/last
    search_method = 'cover',
  })
end)

-- Animated cursor/scroll/window. Disabled by default (matter of taste).
-- later(function() require('mini.animate').setup() end)

-- `[`/`]` navigation for buffers, diagnostics, quickfix, jumps, etc.
later(function() require('mini.bracketed').setup() end)

-- Buffer removal without closing windows. `<Leader>bd/bw/bD/bW`.
later(function() require('mini.bufremove').setup() end)

-- Key sequence clue window (shows available next keys after a trigger).
later(function()
  local miniclue = require('mini.clue')
  -- stylua: ignore
  miniclue.setup({
    clues = {
      Config.leader_group_clues,
      miniclue.gen_clues.builtin_completion(),
      miniclue.gen_clues.g(),
      miniclue.gen_clues.marks(),
      miniclue.gen_clues.registers(),
      miniclue.gen_clues.square_brackets(),
      -- Window resize submode: `<C-w>s` split, then `+`/`-` resize repeatedly
      miniclue.gen_clues.windows({ submode_resize = true }),
      miniclue.gen_clues.z(),
    },
    triggers = {
      { mode = { 'n', 'x' }, keys = '<Leader>' },
      { mode =   'n',        keys = '\\' },
      { mode = { 'n', 'x' }, keys = '[' },
      { mode = { 'n', 'x' }, keys = ']' },
      { mode =   'i',        keys = '<C-x>' },
      { mode = { 'n', 'x' }, keys = 'g' },
      { mode = { 'n', 'x' }, keys = "'" },
      { mode = { 'n', 'x' }, keys = '`' },
      { mode = { 'n', 'x' }, keys = '"' },
      { mode = { 'i', 'c' }, keys = '<C-r>' },
      { mode =   'n',        keys = '<C-w>' },
      { mode = { 'n', 'x' }, keys = 's' },
      { mode = { 'n', 'x' }, keys = 'z' },
    },
  })
end)

-- Command line: autocompletion, autocorrection, range autopeek.
later(function() require('mini.cmdline').setup() end)

-- Color scheme utilities. Disabled by default.
-- later(function() require('mini.colors').setup() end)

-- Comment lines with `gc` operator. Uses 'commentstring'.
later(function() require('mini.comment').setup() end)

-- Autohighlight word under cursor. Disabled by default.
-- later(function() require('mini.cursorword').setup() end)

-- Diff hunks vs Git index. Also feeds statusline devinfo.
-- `gh`/`gH` apply/reset hunks; `<Leader>go` toggle overlay.
later(function() require('mini.diff').setup() end)

-- Git integration: `:Git <cmd>`, `<Leader>gs/gd/gL`.
later(function() require('mini.git').setup() end)

-- Highlight TODO/FIXME/NOTE/HACK and hex color strings.
later(function()
  local hipatterns = require('mini.hipatterns')
  local hi_words = MiniExtra.gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      fixme    = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
      hack     = hi_words({ 'HACK', 'Hack', 'hack' },   'MiniHipatternsHack'),
      todo     = hi_words({ 'TODO', 'Todo', 'todo' },   'MiniHipatternsTodo'),
      note     = hi_words({ 'NOTE', 'Note', 'note' },   'MiniHipatternsNote'),
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

-- Smarter `fFtT`: works across lines, highlights matches.
later(function() require('mini.jump').setup() end)


-- Special key mappings: multi-step and combo actions.
later(function()
  require('mini.keymap').setup()
  -- <Tab>/<S-Tab> navigate completion menu
  MiniKeymap.map_multistep('i', '<Tab>',   { 'pmenu_next' })
  MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
  -- <CR> accepts completion or handles pairs; <BS> handles pairs
  MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
  MiniKeymap.map_multistep('i', '<BS>', { 'minipairs_bs' })
end)

-- Text operators: replace (`gr`), duplicate (`gm`), sort (`gs`), evaluate (`g=`).
later(function()
  require('mini.operators').setup()

  -- `(`/`)` swap adjacent function arguments (relies on 'mini.ai' `a` textobject)
  vim.keymap.set('n', '(', 'gxiagxila', { remap = true, desc = 'Swap arg left' })
  vim.keymap.set('n', ')', 'gxiagxina', { remap = true, desc = 'Swap arg right' })
end)

-- Auto-insert and jump over matching pairs. `<C-v>(` for literal insert.
later(function()
  require('mini.pairs').setup({ modes = { command = true } })
end)

-- Fuzzy picker. `<Leader>ff` files, `<Leader>fg` grep, `<Leader>fh` help.
-- See `:h MiniPick-overview` and `:h MiniExtra.pickers`.
later(function() require('mini.pick').setup() end)

-- Snippet management. Expand with `<C-j>`; navigate tabstops with `<C-l>`/`<C-h>`.
later(function()
  local latex_patterns = { 'latex/**/*.json', '**/latex.json' }
  local lang_patterns = {
    tex              = latex_patterns,
    plaintex         = latex_patterns,
    markdown_inline  = { 'markdown.json' },
  }

  local snippets = require('mini.snippets')
  local config_path = vim.fn.stdpath('config')
  snippets.setup({
    snippets = {
      snippets.gen_loader.from_file(
        config_path .. '/snippets/global.json'),
      snippets.gen_loader.from_lang({ lang_patterns = lang_patterns }),
    },
  })

  -- Uncomment to expose snippets as LSP candidates in mini.completion:
  -- MiniSnippets.start_lsp_server()
end)

-- Toggle join/split arguments with `gS`.
later(function() require('mini.splitjoin').setup() end)

-- Surround actions: add (`sa`), delete (`sd`), replace (`sr`), find (`sf`/`sh`).
later(function() require('mini.surround').setup() end)

-- Highlight and trim trailing whitespace. `<Leader>ot` to trim.
later(function() require('mini.trailspace').setup() end)

-- Not included: mini.doc, mini.fuzzy, mini.test (plugin-dev tools).
