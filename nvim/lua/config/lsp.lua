vim.lsp.log.set_level('ERROR')

vim.diagnostic.config({
  virtual_text = false,
  float = { border = 'rounded' },
})

require('mason').setup({ ui = { border = 'rounded' } })

require('mason-tool-installer').setup({
  ensure_installed = {
    'bash-language-server',
    'clangd',
    'json-lsp',
    'lua-language-server',
    'pyright',
    'rust-analyzer',
    'taplo',
    'typescript-language-server',
    'yaml-language-server',
  },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
      codeLens = { enable = false },
      hint = { enable = false },
    },
  },
})

vim.lsp.enable({
  'bashls',
  'clangd',
  'jsonls',
  'lua_ls',
  'pyright',
  'rust_analyzer',
  'taplo',
  'ts_ls',
  'yamlls',
})

require('blink.cmp').setup({
  keymap = {
    preset = 'super-tab',
    ['<C-Space>'] = false,
    ['<C-x><C-o>'] = { 'show', 'fallback' },
  },
  completion = {
    documentation = { auto_show = false },
    list = {
      selection = {
        preselect = function(ctx)
          return not require('blink.cmp').snippet_active({ direction = 1 })
        end,
        auto_insert = true,
      },
    },
    menu = { border = 'rounded' },
  },
  sources = { default = { 'lsp', 'path', 'buffer' } },
  cmdline = { enabled = false },
})
