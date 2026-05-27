-- vim.pack (0.12+); plugin revisions pinned in nvim-pack-lock.json.
vim.pack.add({
  'https://github.com/ellisonleao/gruvbox.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/mbbill/undotree',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons', -- lualine + oil icons
  'https://github.com/stevearc/oil.nvim',
}, {
  confirm = false,
  load = true,
})

require('gruvbox').setup({
  contrast = 'hard',
  transparent_mode = true, -- terminal background shows through (Ghostty theme).
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

local rounded = { border = 'rounded' }
require('oil').setup({
  -- Filename column is always shown; do not put "name" in columns (oil errors).
  columns = {
    'icon',
    'permissions',
    'size',
    { 'mtime', format = '%Y-%m-%d %H:%M' },
  },
  float = rounded,
  confirmation = rounded,
  progress = rounded,
  lsp_file_methods = { enabled = false }, -- no LSP stack in this config yet.
})

require('lualine').setup({
  options = {
    theme = 'gruvbox',
    section_separators = '',
    component_separators = '',
  },
})

require('fzf-lua').setup({ fzf_colors = true })
