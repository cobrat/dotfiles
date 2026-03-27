-- rust-analyzer config for Rust
-- Source: https://rust-analyzer.github.io
return {
  settings = {
    ['rust-analyzer'] = {
      checkOnSave = {
        command = 'clippy',
        extraArgs = { '--all-targets', '--all-features' },
      },
      cargo = { allFeatures = true },
      clippy = {
        allTargets = true,
      },
    },
  },
}
