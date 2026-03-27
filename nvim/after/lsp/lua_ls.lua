-- lua-language-server config for Neovim Lua development.
-- Source: https://github.com/LuaLS/lua-language-server
-- Used by `:h vim.lsp.enable()` / `:h vim.lsp.config()`.
return {
  on_attach = function(client, _)
    -- Reduce trigger characters for better 'mini.completion' experience
    client.server_capabilities.completionProvider.triggerCharacters =
      { '.', ':', '#', '(' }
  end,
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      workspace = {
        ignoreSubmodules = true,
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
}
