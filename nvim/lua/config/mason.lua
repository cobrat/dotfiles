require('mason').setup({
  ui = { border = 'rounded' },
  -- Gentler CPU / disk when several tools install or upgrade at once.
  max_concurrent_installers = 2,
})

require('mason-tool-installer').setup({
  -- Defer ensure_installed until the UI is up (ms). LSP still finds tools on PATH once done.
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
