-- ruff config for Python (linting + formatting)
-- Source: https://docs.astral.sh/ruff/editors/
-- Requires: ruff >= 0.4.0 (built-in language server via `ruff server`)
return {
  settings = {
    ruff = {
      lineLength = 100,
    },
  },
}
