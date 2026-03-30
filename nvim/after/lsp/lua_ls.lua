-- lua-language-server overrides for Neovim Lua development.
-- Base config comes from nvim-lspconfig.
return {
  on_attach = function(client, _)
    -- Reduce trigger characters for better 'mini.completion' experience.
    client.server_capabilities.completionProvider.triggerCharacters =
      { '.', ':', '#', '(' }
  end,
  settings = {
    Lua = {
      workspace = {
        ignoreSubmodules = true,
      },
    },
  },
}
