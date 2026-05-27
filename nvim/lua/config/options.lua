local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = 'yes'
-- Leave scrolloff/scrolloffpad at 0 on purpose: no forced scroll near EOF.
opt.showmode = false -- lualine shows mode; hide the built-in --INSERT-- line.
opt.termguicolors = true
opt.winborder = 'rounded'
opt.linebreak = true -- wrap at word boundaries, not mid-word.
opt.breakindent = true
opt.colorcolumn = '80'

-- Editing
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
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
