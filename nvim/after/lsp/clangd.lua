-- clangd overrides for C/C++
-- Base config comes from nvim-lspconfig.
return {
  -- Use a 4-space fallback style when the project doesn't provide `.clang-format`.
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    '--fallback-style={BasedOnStyle: LLVM, IndentWidth: 4}',
  },
}
