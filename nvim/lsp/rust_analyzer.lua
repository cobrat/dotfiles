local Config = require('config.shared')

return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_dir = Config.root_dir_with_fallback({
    'Cargo.toml', 'rust-project.json',
  }),
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
        extraArgs = { '--all-targets', '--all-features' },
      },
      cargo = { allFeatures = true },
    },
  },
}
