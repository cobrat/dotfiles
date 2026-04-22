local Config = require('config.shared')

return {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript', 'javascriptreact', 'javascript.jsx',
    'typescript', 'typescriptreact', 'typescript.tsx',
  },
  init_options = { hostInfo = 'neovim' },
  root_dir = Config.root_dir_with_fallback({
    'tsconfig.json', 'jsconfig.json', 'package.json',
  }),
}
