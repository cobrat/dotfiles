-- clangd config for C/C++
-- Source: https://clangd.llvm.org
return {
  cmd = {
    'clangd',
    '--background-index',
    '--clang-tidy',
    '--fallback-style={BasedOnStyle: LLVM, IndentWidth: 4}',
  },
}
