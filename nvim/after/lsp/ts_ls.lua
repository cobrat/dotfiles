-- ts_ls overrides for TypeScript and JavaScript.
-- Base config comes from nvim-lspconfig.
return {
  -- Fall back to the file's directory so standalone TS/JS files
  -- can still attach.
  root_dir = Config.root_dir_with_fallback({
    'tsconfig.json',
    'jsconfig.json',
    'package.json',
    '.git',
  }),
}
