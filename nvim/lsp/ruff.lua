return {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_dir = Config.root_dir_with_fallback({
    'pyproject.toml', 'ruff.toml', '.ruff.toml',
  }),
}
