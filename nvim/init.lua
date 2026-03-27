-- ┌────────────────────┐
-- │ Welcome to MiniMax │
-- └────────────────────┘
-- NOTE: requires Neovim ≥ v0.12.0-dev-2260+g6b4ec2264e (0.12 dev).
--
-- Config structure:
-- ├ init.lua          Startup entry point (this file)
-- ├ plugin/           Auto-sourced on startup
-- ├── 10_options.lua  Built-in options
-- ├── 20_keymaps.lua  Key mappings
-- ├── 30_mini.lua     mini.nvim configuration
-- ├── 40_plugins.lua  Third-party plugins
-- ├ snippets/         Global snippets
-- ├ after/ftplugin/   Per-filetype overrides
-- ├── lsp/            LSP server configs
-- └── snippets/       High-priority snippets

-- Plugin manager: built-in `vim.pack`. Lockfile: 'nvim-pack-lock.json'.
-- `:lua vim.pack.update()` to update, `:write` to confirm.

-- Global config table shared across scripts
_G.Config = {}

-- mini.nvim: powers most of this config. See 'plugin/30_mini.lua'.
vim.pack.add({ 'https://github.com/nvim-mini/mini.nvim' })

-- Loading helpers. `now` = immediate (startup-critical), `later` = deferred.
-- See `:h MiniMisc.safely()`.
local misc = require('mini.misc')
Config.now = function(f) misc.safely('now', f) end
Config.later = function(f) misc.safely('later', f) end
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later
Config.on_event = function(ev, f) misc.safely('event:' .. ev, f) end
Config.on_filetype = function(ft, f) misc.safely('filetype:' .. ft, f) end

-- Autocommand helper. See `:h autocommand`.
local gr = vim.api.nvim_create_augroup('custom-config', {})
Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = {
    group = gr,
    pattern = pattern,
    callback = callback,
    desc = desc,
  }
  vim.api.nvim_create_autocmd(event, opts)
end

-- vim.pack post-install/update hook. See `:h vim.pack-events`.
Config.on_packchanged = function(plugin_name, kinds, callback, desc)
  local f = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    local match = name == plugin_name
      and vim.tbl_contains(kinds, kind)
    if not match then return end
    if not ev.data.active then vim.cmd.packadd(plugin_name) end
    callback()
  end
  Config.new_autocmd('PackChanged', '*', f, desc)
end
