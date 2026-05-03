vim.pack.add({
  'https://github.com/ellisonleao/gruvbox.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/stevearc/oil.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/numToStr/Comment.nvim',
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/kylechui/nvim-surround',
}, {
  confirm = false,
  load = true,
})

-- Theme

require('gruvbox').setup({
  contrast = 'hard',
  transparent_mode = true,
  italic = {
    strings = false,
    emphasis = true,
    comments = false,
    operators = false,
    folds = false,
  },
  overrides = {
    htmlItalic = { italic = false },
    htmlBoldItalic = { italic = false },
  },
})

vim.o.background = 'dark'
vim.cmd.colorscheme('gruvbox')

-- Treesitter

local treesitter_langs = {
  'bash',
  'json',
  'lua',
  'markdown',
  'python',
  'toml',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

require('nvim-treesitter').setup()
require('nvim-treesitter').install(treesitter_langs)

local ts_fts = vim.deepcopy(treesitter_langs)
vim.list_extend(ts_fts, { 'sh' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = ts_fts,
  callback = function()
    vim.treesitter.start()
    local ie = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.bo.indentexpr = ie
  end,
})

-- Plugin setup

require('oil').setup({
  columns = {},
  float = {
    border = 'rounded',
    max_height = 0.8,
    max_width = 0.8,
    padding = 2,
  },
  keymaps = {
    ['g?'] = 'actions.show_help',
    ['h'] = { 'actions.parent', mode = 'n' },
    ['l'] = {
      mode = 'n',
      desc = 'Enter directory under cursor',
      callback = function()
        local e = require('oil').get_cursor_entry()
        if e and e.type == 'directory' then
          require('oil').select()
        end
      end,
    },
  },
  view_options = {
    show_hidden = true,
  },
})

vim.api.nvim_create_autocmd('VimEnter', {
  nested = true,
  once = true,
  callback = function()
    if vim.fn.argc() ~= 1 then
      return
    end
    local a0 = vim.fn.argv(0)
    local dir
    if vim.fn.isdirectory(a0) == 1 then
      dir = vim.fs.normalize(vim.fn.fnamemodify(a0, ':p'))
    elseif vim.bo.filetype == 'oil' and vim.startswith(a0, 'oil://') then
      local d = require('oil').get_current_dir()
      if d then
        dir = vim.fs.normalize(d)
      end
    end
    if not dir then
      return
    end
    local bg_win = vim.api.nvim_get_current_win()
    require('oil').open_float(dir)
    vim.schedule(function()
      if vim.api.nvim_win_is_valid(bg_win) then
        vim.api.nvim_win_call(bg_win, function()
          vim.cmd.enew()
        end)
      end
    end)
  end,
})

require('fzf-lua').setup({
  defaults = {
    color_icons = false,
    file_icons = false,
    git_icons = false,
  },
  fzf_colors = true,
  winopts = {
    preview = {
      default = 'bat',
    },
  },
})

require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    changedelete = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '^' },
    untracked = { text = '+' },
  },
})

require('Comment').setup()
require('nvim-autopairs').setup()
require('nvim-surround').setup()
