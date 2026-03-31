-- jsonls overrides for JSON.
-- Base config comes from nvim-lspconfig.
return {
  settings = {
    json = {
      schemas = {
        {
          description = 'Tauri v2 config',
          fileMatch = { 'tauri.conf.json', 'tauri.*.conf.json' },
          url = 'https://schema.tauri.app/config/2',
        },
      },
      validate = { enable = true },
    },
  },
}
