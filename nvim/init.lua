-- Neovim configuration entry
-- Requires Neovim 0.12+ (uses vim.pack, vim.lsp.config, winborder, etc.).
--
-- Layout:
-- ├ init.lua            Startup entry point (this file)
-- ├ lua/config/         Required explicitly below (controlled order)
-- ├── options.lua       Built-in options + autocmds
-- ├── keymaps.lua       Key mappings
-- ├── plugins.lua       mini.nvim + third-party plugins
-- └ lsp/                Per-server native LSP configs

-- Plugin manager: built-in `vim.pack`. Lockfile: 'nvim-pack-lock.json'.
-- `:lua vim.pack.update()` to update, `:write` to confirm.

-- Set leader before any mapping can be evaluated.
vim.g.mapleader = ' '

-- Disable netrw: file explorer is provided by mini.files.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_remote_plugins = 1

-- Global config table shared across scripts
_G.Config = {}

-- mini.nvim powers several UI/editing modules configured in `config.plugins`.
vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

-- Defer work until after startup.
Config.later = vim.schedule

-- LSP `root_dir` with fallback to the file's directory so a standalone
-- source file still attaches. Used by several `lsp/*.lua` configs.
Config.root_dir_with_fallback = function(markers)
  local all = vim.list_extend({ '.git' }, markers)
  return function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, all)
    on_dir(root or vim.fs.dirname(fname))
  end
end

-- Autocommand helper. See `:h autocommand`.
local gr = vim.api.nvim_create_augroup('custom-config', {})
Config.new_autocmd = function(event, pattern, callback, desc)
  vim.api.nvim_create_autocmd(event, {
    group = gr, pattern = pattern, callback = callback, desc = desc,
  })
end

-- Load configuration modules in explicit order.
require('config.options')
require('config.keymaps')
require('config.plugins')
