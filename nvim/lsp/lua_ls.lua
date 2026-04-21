local runtime_library = vim.api.nvim_get_runtime_file('', true)

return {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = {
    '.luarc.json', '.luarc.jsonc',
    '.luacheckrc', '.stylua.toml', 'stylua.toml',
    'selene.toml', 'selene.yml',
    '.git',
  },
  on_attach = function(client, _)
    -- Narrow trigger chars; avoids autotrigger firing on every space/operator.
    client.server_capabilities.completionProvider.triggerCharacters =
      { '.', ':', '#', '(' }
  end,
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
        ignoreSubmodules = true,
        library = runtime_library,
      },
    },
  },
}
