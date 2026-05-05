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
