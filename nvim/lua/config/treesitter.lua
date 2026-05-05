require('nvim-treesitter').setup()

vim.treesitter.language.register('bash', 'sh')

local treesitter_fts = {
  'bash',
  'json',
  'lua',
  'markdown',
  'python',
  'sh',
  'toml',
  'typescript',
  'vim',
  'vimdoc',
  'yaml',
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = treesitter_fts,
  callback = function()
    if pcall(vim.treesitter.start) then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
