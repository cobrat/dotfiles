-- ~/.config/nvim/lua/lsp.lua
vim.lsp.enable({
  "bashls",
  "lua_ls",
  "clangd",
  "pyright",
  "rust-analyzer",
})
vim.diagnostic.config({ virtual_text = true })
