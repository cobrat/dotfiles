vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/williamboman/mason.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  {
    src = 'https://github.com/Saghen/blink.cmp',
    version = vim.version.range('1'),
  },
  'https://github.com/ellisonleao/gruvbox.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/stevearc/oil.nvim',
}, {
  confirm = false,
  load = true,
})

require('gruvbox').setup({
  contrast = 'hard',
  transparent_mode = true,
  italic = {
    strings = false,
    comments = false,
    folds = false,
  },
  overrides = {
    htmlItalic = { italic = false },
    htmlBoldItalic = { italic = false },
  },
})
vim.cmd.colorscheme('gruvbox')

local border = { border = 'rounded' }
require('oil').setup({
  columns = { 'icon', 'permissions', 'size', { 'mtime', format = '%Y-%m-%d %H:%M' } },
  float = border,
  confirmation = border,
  progress = border,
  lsp_file_methods = { enabled = true },
})

require('lualine').setup({
  options = {
    theme = 'gruvbox',
    section_separators = '',
    component_separators = '',
  },
})

require('fzf-lua').setup({
  fzf_colors = true,
  git = {
    files = { git_icons = true, file_icons = true },
    status = { git_icons = true, file_icons = true },
    hunks = { git_icons = true },
  },
  lsp = {
    file_icons = true,
  },
})
