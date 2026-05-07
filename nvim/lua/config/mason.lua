require('mason').setup({
  ui = { border = 'rounded' },
  -- Gentler CPU / disk when several tools install or upgrade at once.
  max_concurrent_installers = 2,
})

require('mason-tool-installer').setup({
  -- Delay ensure_installed until Mason UI shows (ms).
  start_delay = 3000,
  ensure_installed = {
    'bash-language-server',
    'json-lsp',
    'lua-language-server',
    'pyright',
    'stylua',
    'taplo',
    'typescript-language-server',
    'yaml-language-server',
  },
  auto_update = false,
  run_on_start = true,
})
