return {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  init_options = { provideFormatter = true },
  root_markers = { '.git' },
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
