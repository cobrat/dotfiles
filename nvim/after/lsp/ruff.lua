-- Ruff overrides for Python.
-- Base config comes from nvim-lspconfig.
return {
  -- Fall back to the file's directory so standalone Python files still attach.
  root_dir = Config.root_dir_with_fallback({
    'pyproject.toml',
    'ruff.toml',
    '.ruff.toml',
    '.git',
  }),
}
