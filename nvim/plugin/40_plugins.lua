-- ┌─────────────────────────┐
-- │ Plugins outside of MINI │
-- └─────────────────────────┘

local add = vim.pack.add
local now_if_args, later = Config.now_if_args, Config.later

Config.treesitter_languages = { 'lua', 'vimdoc', 'markdown' }
Config.lsp_servers = { 'lua_ls', 'ruff', 'clangd', 'rust_analyzer' }

-- Tree-sitter ================================================================
-- Fast incremental parsing for syntax highlighting, textobjects, indent.
-- Requires system build tools; see MiniMax README for software requirements.
-- Troubleshoot: `:checkhealth vim.treesitter nvim-treesitter`
now_if_args(function()
  local ts_update = function() vim.cmd('TSUpdate') end
  Config.on_packchanged(
    'nvim-treesitter', { 'install', 'update' }, ts_update, ':TSUpdate')

  add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  })

  local isnt_installed = function(lang)
    local files = vim.api.nvim_get_runtime_file(
      'parser/' .. lang .. '.*', false)
    return #files == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, Config.treesitter_languages)

  vim.api.nvim_create_user_command('TSInstallRequired', function()
    require('nvim-treesitter').install(Config.treesitter_languages)
  end, { desc = 'Install tree-sitter parsers required by this config' })

  if #to_install > 0 then
    Config.new_autocmd('VimEnter', nil, function()
      vim.notify_once(
        string.format(
          'Missing tree-sitter parsers: %s. Run :TSInstallRequired',
          table.concat(to_install, ', ')),
        vim.log.levels.INFO)
    end, 'Report missing tree-sitter parsers')
  end

  -- Enable tree-sitter per filetype
  local filetypes = {}
  for _, lang in ipairs(Config.treesitter_languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      filetypes[ft] = true
    end
  end
  local ts_start = function(ev)
    vim.treesitter.start(ev.buf)
    -- Use tree-sitter for folding in TS-enabled filetypes
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
  end
  Config.new_autocmd('FileType', vim.tbl_keys(filetypes), ts_start, 'Start tree-sitter')
end)

-- Language servers ===========================================================
-- Use nvim-lspconfig for server defaults, Mason for installation.
-- Override individual servers in 'after/lsp/' and keep only diffs there.
Config.now(function()
  add({
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
  })

  require('mason').setup()
  require('mason-lspconfig').setup({
    -- Mason installs the allowlist; actual LSP enabling stays on native Nvim APIs.
    ensure_installed = Config.lsp_servers,
    automatic_enable = false,
  })
  vim.lsp.enable(Config.lsp_servers)
end)

-- Formatting =================================================================
-- External formatters via conform.nvim. `<Leader>lf` to format.
Config.now(function()
  add({ 'https://github.com/stevearc/conform.nvim' })
  require('conform').setup({
    default_format_opts = {
      lsp_format = 'fallback', -- use LSP if no dedicated formatter
    },
    formatters_by_ft = { lua = { 'stylua' } },
  })
end)

-- Honorable mentions =========================================================

-- Color schemes with full mini.nvim highlight support:
Config.now(function()
  add({ 'https://github.com/ellisonleao/gruvbox.nvim' })
  require('gruvbox').setup({
    contrast         = 'hard',  -- '' | 'hard' | 'soft'
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
end)
