-- Plugins (mini.nvim + third-party setup)

local add = vim.pack.add
local later = Config.later

-- mini.nvim ==================================================================
-- See `:h mini.nvim-general-principles`.

-- Statusline: [mode] [branch +~-] filename ⋯ [size] [Ln,Col]
local function git_section()
  local str = vim.b.minigit_summary_string or ''
  local branch = str:match('^%S+') or ''
  if branch == '' then return '' end
  if #branch > 12 and branch:match('^%x+$') then branch = branch:sub(1, 8) end
  local d = vim.b.minidiff_summary
  local parts = { branch }
  if d then
    if (d.add    or 0) > 0 then parts[#parts+1] = '+' .. d.add    end
    if (d.change or 0) > 0 then parts[#parts+1] = '~' .. d.change end
    if (d.delete or 0) > 0 then parts[#parts+1] = '-' .. d.delete end
  end
  return table.concat(parts, ' ')
end

local function file_size()
  local size = math.max(vim.fn.line2byte(vim.fn.line('$') + 1) - 1, 0)
  if size < 1024 then return size .. 'B' end
  if size < 1048576 then return string.format('%.1fK', size / 1024) end
  return string.format('%.1fM', size / 1048576)
end

require('mini.statusline').setup({
  use_icons = false,
  content = {
    active = function()
      local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
      local filename = MiniStatusline.section_filename({ trunc_width = 140 })
      local location = MiniStatusline.section_location({ trunc_width = 75 })

      return MiniStatusline.combine_groups({
        { hl = mode_hl,                  strings = { mode } },
        { hl = 'MiniStatuslineDevinfo',  strings = { git_section() } },
        '%<',
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=',
        { hl = 'MiniStatuslineFileinfo', strings = { file_size() } },
        { hl = mode_hl,                  strings = { location } },
      })
    end,
  },
})

-- File explorer (Miller columns). `l`/`h` navigate in/out, `g?` for help.
-- Manipulate by editing buffer text, then `=` to sync.
later(function()
  require('mini.files').setup({ content = { prefix = function() end } })

  -- Bookmarks available inside explorer (press `'p`, `'w`).
  local add_marks = function()
    MiniFiles.set_bookmark('p',
      vim.fs.joinpath(vim.fn.stdpath('data'), 'site/pack/core/opt'),
      { desc = 'Plugins' })
    MiniFiles.set_bookmark(
      'w', vim.fn.getcwd, { desc = 'Working directory' })
  end
  Config.new_autocmd(
    'User', 'MiniFilesExplorerOpen', add_marks, 'Add bookmarks')

  -- Open explorer when launched with a directory arg.
  local arg0 = vim.fn.argv(0) --[[@as string]]
  if arg0 ~= '' and vim.fn.isdirectory(arg0) == 1 then
    MiniFiles.open(vim.fn.fnamemodify(arg0, ':p'))
  end
end)

-- Extra mini.nvim functionality used by other modules (pickers, highlighters).
later(function() require('mini.extra').setup() end)

-- Diff hunks vs Git index. Also feeds statusline devinfo.
-- `gh`/`gH` apply/reset hunks; `<Leader>go` toggle overlay.
later(function()
  require('mini.diff').setup({
    view = {
      style = 'sign',
      signs = { add = '+', change = '~', delete = '-' },
    },
  })
end)

-- Git integration: `:Git <cmd>`, `<Leader>gs/gd`.
later(function() require('mini.git').setup() end)

-- Highlight TODO/FIXME/NOTE/HACK and hex color strings.
later(function()
  local hipatterns = require('mini.hipatterns')
  local hi_words = MiniExtra.gen_highlighter.words
  hipatterns.setup({
    highlighters = {
      fixme = hi_words(
        { 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
      hack  = hi_words(
        { 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
      todo  = hi_words(
        { 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
      note  = hi_words(
        { 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })
end)

-- Text operators:
-- replace (`gr`), duplicate (`gm`), sort (`gs`), evaluate (`g=`).
later(function() require('mini.operators').setup() end)

-- Fuzzy picker. `<Leader>ff` files, `<Leader>fg` grep, `<Leader>fh` help.
-- See `:h MiniPick-overview` and `:h MiniExtra.pickers`.
later(function() require('mini.pick').setup() end)

-- Surround actions:
-- add (`sa`), delete (`sd`), replace (`sr`), find (`sf`/`sh`).
later(function() require('mini.surround').setup() end)

-- Third-party plugins ========================================================

local treesitter_languages = {
  'lua', 'vimdoc', 'markdown', 'rust',
  'javascript', 'typescript', 'svelte',
  'html', 'css', 'json', 'toml',
}
local lsp_servers = {
  'lua_ls', 'ruff', 'clangd', 'rust_analyzer', 'svelte',
  'ts_ls', 'html', 'cssls', 'jsonls', 'taplo',
}

-- Tree-sitter ================================================================
-- Fast incremental parsing for syntax highlighting and folding.
-- Missing configured parsers are installed automatically on first use.
-- Troubleshoot: `:checkhealth vim.treesitter nvim-treesitter`

later(function()
  -- Run :TSUpdate automatically after install/update.
  Config.new_autocmd('PackChanged', '*', function(ev)
    if ev.data.spec.name ~= 'nvim-treesitter' then return end
    if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end
    if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
    vim.cmd('TSUpdate')
  end, ':TSUpdate')

  add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })

  local installed_cache = {}
  local function is_installed(lang)
    if installed_cache[lang] then return true end
    local ok = #vim.api.nvim_get_runtime_file(
      'parser/' .. lang .. '.*',
      false
    ) > 0
    if ok then installed_cache[lang] = true end
    return ok
  end

  local function enable_treesitter(bufnr)
    local ok = pcall(vim.treesitter.start, bufnr)
    if not ok then return end

    -- Folding is window-local, so apply it to every window showing the buffer.
    for _, win in ipairs(vim.fn.win_findbuf(bufnr)) do
      vim.api.nvim_win_call(win, function()
        vim.opt_local.foldmethod = 'expr'
        vim.opt_local.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
      end)
    end
  end

  -- Enable tree-sitter per filetype
  local filetypes = {}
  local pending_bufs = {}
  local install_tasks = {}
  local missing_reported = {}
  for _, lang in ipairs(treesitter_languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      filetypes[ft] = true
    end
  end
  local ts_start = function(ev)
    local ft = vim.bo[ev.buf].filetype
    local lang = vim.treesitter.language.get_lang(ft) or ft
    if not is_installed(lang) then
      pending_bufs[lang] = pending_bufs[lang] or {}
      pending_bufs[lang][ev.buf] = true

      if install_tasks[lang] then return end

      if not missing_reported[lang] then
        missing_reported[lang] = true
        vim.notify_once(
          string.format('Installing tree-sitter parser: %s', lang),
          vim.log.levels.INFO
        )
      end

      install_tasks[lang] = require('nvim-treesitter').install({ lang })
      install_tasks[lang]:await(function(err, ok)
        install_tasks[lang] = nil
        if err or not ok then return end

        installed_cache[lang] = true

        local bufs = pending_bufs[lang] or {}
        pending_bufs[lang] = nil
        vim.schedule(function()
          for bufnr in pairs(bufs) do
            if vim.api.nvim_buf_is_valid(bufnr) then
              local buf_ft = vim.bo[bufnr].filetype
              local buf_lang =
                vim.treesitter.language.get_lang(buf_ft) or buf_ft
              if buf_lang == lang then
                enable_treesitter(bufnr)
              end
            end
          end
        end)
      end)
      return
    end

    enable_treesitter(ev.buf)
  end
  Config.new_autocmd(
    'FileType',
    vim.tbl_keys(filetypes),
    ts_start,
    'Start tree-sitter'
  )

  -- Trigger for buffers already loaded before this deferred block ran.
  vim.cmd('silent! doautoall FileType')
end)

-- Language servers ===========================================================
-- Full per-server specs live in `lsp/*.lua`. Mason installs binaries.
add({
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
})

-- Setup Mason early so its bin dir is on PATH before installed servers run.
require('mason').setup()

later(function()
  require('mason-lspconfig').setup({
    ensure_installed = lsp_servers,
    -- Let Mason enable only the servers declared by this config. This also
    -- retries current buffers when a server finishes installing.
    automatic_enable = lsp_servers,
  })
end)

-- Formatting =================================================================
-- External formatters via conform.nvim. `<Leader>lf` to format.
later(function()
  add({ 'https://github.com/stevearc/conform.nvim' })

  local prettier = { 'prettierd', 'prettier', stop_after_first = true }
  require('conform').setup({
    default_format_opts = {
      lsp_format = 'fallback', -- use LSP if no dedicated formatter
    },
    formatters_by_ft = {
      lua             = { 'stylua' },
      javascript      = prettier,
      typescript      = prettier,
      javascriptreact = prettier,
      typescriptreact = prettier,
      svelte          = prettier,
      html            = prettier,
      css             = prettier,
      json            = prettier,
      markdown        = prettier,
      python = { 'ruff_format', 'ruff_organize_imports' },
      rust   = { 'rustfmt' },
      sh     = { 'shfmt' },
      toml   = { 'taplo' },
    },
  })
end)

-- Color scheme ===============================================================
add({ 'https://github.com/ellisonleao/gruvbox.nvim' })
require('gruvbox').setup({
  contrast         = 'hard',
  bold             = true,
  transparent_mode = true,
  italic           = {
    strings   = false,
    emphasis  = false,
    comments  = false,
    operators = false,
    folds     = false,
  },
})
vim.cmd('colorscheme gruvbox')
