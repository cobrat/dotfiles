vim.g.have_nerd_font = false

local opt = vim.opt

-- UI

opt.cmdheight = 1
opt.cursorline = true
opt.number = true
opt.relativenumber = true
-- Large value keeps cursor line vertically centered; see :help 'scrolloff'.
opt.scrolloff = 999
opt.scrolloffpad = 1
opt.showmode = false
opt.signcolumn = 'yes'
opt.smoothscroll = true
opt.termguicolors = true
opt.winborder = 'rounded'
opt.wrap = true
opt.colorcolumn = '80'

-- Hybrid line numbers + signs; plain digits (no printf %4d — it pads with
-- spaces and widens the gutter next to signs).
opt.statuscolumn = '%s %{v:virtnum ? "" : (v:relnum == 0 ? v:lnum : v:relnum)} '

-- Editing

opt.autoread = true
opt.autowrite = true
opt.backup = false
opt.clipboard = 'unnamedplus'
opt.confirm = true
opt.expandtab = true
opt.jumpoptions = 'view'
opt.mouse = 'a'
opt.shiftwidth = 4
opt.smartindent = true
opt.swapfile = false
opt.tabstop = 4
opt.undofile = true
opt.virtualedit = 'block'

-- Search

opt.grepformat = '%f:%l:%c:%m'
opt.grepprg = 'rg --vimgrep'
opt.hlsearch = true
opt.ignorecase = true
opt.inccommand = 'split'
opt.incsearch = true
opt.smartcase = true

-- Windows and timing

opt.diffopt:append({ 'algorithm:histogram', 'indent-heuristic' })
opt.splitbelow = true
opt.splitright = true
opt.timeoutlen = 500
opt.updatetime = 250

-- Diagnostics

vim.diagnostic.config({
  -- Do not refresh diagnostics on every insert-mode change (explicit default).
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.INFO] = 'I',
      [vim.diagnostic.severity.HINT] = 'H',
    },
  },
  virtual_text = false,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Reload files changed outside Neovim.

vim.api.nvim_create_autocmd({
  'BufEnter',
  'CursorHold',
  'FocusGained',
}, {
  command = 'checktime',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'oil',
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
    vim.opt_local.statuscolumn = ''
  end,
})
