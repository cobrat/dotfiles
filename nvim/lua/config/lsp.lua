-- Server definitions: nvim-lspconfig (runtime lsp/*.lua).
-- Customizations only here.

-- Less RPC log I/O than default WARN (see :help lsp-log).
vim.lsp.log.set_level('ERROR')

-- Do not use nvim_get_runtime_file('', true) for workspace.library: it indexes
-- every runtimepath entry and slows lua-language-server.
-- Add paths in .luarc.json for plugin-heavy projects.
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      -- Fewer LSP round-trips than upstream defaults; re-enable if needed.
      codeLens = { enable = false },
      hint = { enable = false },
    },
  },
})

vim.lsp.enable({
  'bashls',
  'jsonls',
  'lua_ls',
  'pyright',
  'taplo',
  'ts_ls',
  'yamlls',
})
