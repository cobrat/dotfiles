-- rust-analyzer overrides for Rust.
-- Base config comes from nvim-lspconfig.
return {
  -- Fall back to the file's directory so standalone Rust files can still attach.
  root_dir = Config.root_dir_with_fallback({
    'Cargo.toml',
    'rust-project.json',
    '.git',
  }),
  -- These are editor/workflow preferences; project-specific build config should
  -- still live in Cargo.toml, rust-toolchain.toml, etc.
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
