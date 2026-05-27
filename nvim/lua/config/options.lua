local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = 'yes'
-- scrolloff=0: no forced scroll near EOF (removes last-lines "snap"). Middle of
-- file loses extra context above/below cursor; gj/gk handle wrap (keymaps).
opt.scrolloff = 0
opt.scrolloffpad = 0
opt.showmode = false -- lualine shows mode; hide the built-in --INSERT-- line.
opt.termguicolors = true
opt.winborder = 'rounded'
opt.wrap = true
opt.linebreak = true -- wrap at word boundaries, not mid-word.
opt.breakindent = true
opt.colorcolumn = '80'

-- Editing
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true
opt.mouse = 'a'
opt.confirm = true
opt.undofile = true
opt.swapfile = false

-- Search
opt.ignorecase = true
opt.smartcase = true -- upper-case in pattern disables ignorecase.
opt.inccommand = 'split' -- live substitute preview in a split.

if vim.fn.executable('rg') == 1 then
  opt.grepprg = 'rg --vimgrep'
  opt.grepformat = '%f:%l:%c:%m'
end

opt.splitbelow = true
opt.splitright = true
opt.updatetime = 250
opt.timeoutlen = 300
-- popup: info docs float; fuzzy: fuzzy match in built-in completion (0.11+).
opt.completeopt = 'menu,menuone,noselect,popup,fuzzy'
opt.wildmode = 'longest:full,full'
