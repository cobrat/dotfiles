-- Markdown-specific settings (applied on every filetype change to 'markdown')

-- Enable spelling and visual wrap
vim.cmd('setlocal spell wrap')

-- Fold with tree-sitter
vim.cmd('setlocal foldmethod=expr foldexpr=v:lua.vim.treesitter.foldexpr()')

-- Disable built-in `gO` in favor of 'mini.basics'
vim.keymap.del('n', 'gO', { buffer = 0 })

-- Markdown link surrounding for 'mini.surround':
--   `saiwL` + link + <CR>  add link
--   `sdL`                  delete link
--   `srLL` + link + <CR>   replace link
vim.b.minisurround_config = {
  custom_surroundings = {
    L = {
      input = { '%[().-()%]%(.-%)' },
      output = function()
        local link = require('mini.surround').user_input('Link: ')
        return { left = '[', right = '](' .. link .. ')' }
      end,
    },
  },
}
