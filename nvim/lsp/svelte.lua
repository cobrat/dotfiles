local Config = require('config.shared')

return {
  cmd = { 'svelteserver', '--stdio' },
  filetypes = { 'svelte' },
  root_dir = Config.root_dir_with_fallback({
    'svelte.config.js', 'svelte.config.cjs',
    'svelte.config.mjs', 'svelte.config.ts',
    'package.json',
  }),
}
