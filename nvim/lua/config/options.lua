local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = 'yes'
opt.showmode = false -- lualine shows mode
opt.termguicolors = true
opt.winborder = 'rounded'
opt.linebreak = true
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
opt.smartcase = true
opt.inccommand = 'split'

if vim.fn.executable('rg') == 1 then
  opt.grepprg = 'rg --vimgrep'
  opt.grepformat = '%f:%l:%c:%m'
end

opt.splitbelow = true
opt.splitright = true
opt.updatetime = 250
opt.timeoutlen = 300
opt.completeopt = 'menu,menuone,noselect'
opt.wildmode = 'longest:full,full'

vim.api.nvim_create_autocmd('TextYankPost', { callback = vim.hl.hl_op })

vim.api.nvim_create_autocmd(
  { 'BufEnter', 'FocusGained' },
  { command = 'checktime' }
)

vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(event)
    if not vim.bo[event.buf].modifiable or vim.bo[event.buf].filetype == 'markdown' then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})
