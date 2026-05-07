vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/ellisonleao/gruvbox.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  {
    src = 'https://github.com/Saghen/blink.cmp',
    version = vim.version.range('1'),
  },
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/nvim-mini/mini.surround',
}, {
  confirm = false,
  load = true,
})
