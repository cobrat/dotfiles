-- ┌─────────────────────────┐
-- │ Plugins outside of MINI │
-- └─────────────────────────┘

local add = vim.pack.add
local now_if_args, later = Config.now_if_args, Config.later

-- Tree-sitter ================================================================
-- Fast incremental parsing for syntax highlighting, textobjects, indent.
-- Requires system build tools; see MiniMax README for software requirements.
-- Troubleshoot: `:checkhealth vim.treesitter nvim-treesitter`
now_if_args(function()
  local ts_update = function() vim.cmd('TSUpdate') end
  Config.on_packchanged(
    'nvim-treesitter', { 'update' }, ts_update, ':TSUpdate')

  add({
    'https://github.com/nvim-treesitter/nvim-treesitter',
    'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
  })

  -- Languages to install parsers for. Restart once after adding new entries.
  local languages = {
    'lua', 'vimdoc', 'markdown',
    -- Add more; see `:=require('nvim-treesitter').get_available()`
  }
  local isnt_installed = function(lang)
    local files = vim.api.nvim_get_runtime_file(
      'parser/' .. lang .. '.*', false)
    return #files == 0
  end
  local to_install = vim.tbl_filter(isnt_installed, languages)
  if #to_install > 0 then require('nvim-treesitter').install(to_install) end

  -- Enable tree-sitter per filetype
  local filetypes = {}
  for _, lang in ipairs(languages) do
    for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
      table.insert(filetypes, ft)
    end
  end
  local ts_start = function(ev)
    vim.treesitter.start(ev.buf)
    -- Use tree-sitter for folding in TS-enabled filetypes
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr   = 'v:lua.vim.treesitter.foldexpr()'
  end
  Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')
end)

-- Language servers ===========================================================
-- Neovim is the LSP client; servers must be installed separately.
-- Configure servers in 'lsp/' directory. See `:h vim.lsp.enable()`.
now_if_args(function()
  vim.lsp.enable({ 'lua_ls', 'ruff', 'clangd', 'rust_analyzer' })
end)

-- Formatting =================================================================
-- External formatters via conform.nvim. `<Leader>lf` to format.
later(function()
  add({ 'https://github.com/stevearc/conform.nvim' })
  require('conform').setup({
    default_format_opts = {
      lsp_format = 'fallback', -- use LSP if no dedicated formatter
    },
    formatters_by_ft = { lua = { 'stylua' } },
  })
end)

-- Honorable mentions =========================================================

-- mason.nvim: package manager for LSP servers, formatters, linters.
-- now_if_args(function()
--   add({ 'https://github.com/mason-org/mason.nvim' })
--   require('mason').setup()
-- end)

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
