-- Svelte language server overrides.
-- Base config comes from nvim-lspconfig.
return {
  -- Fall back to the file's directory so standalone Svelte files
  -- can still attach.
  root_dir = Config.root_dir_with_fallback({
    'svelte.config.js',
    'svelte.config.cjs',
    'svelte.config.mjs',
    'svelte.config.ts',
    'package.json',
    '.git',
  }),
}
