-- Brief flash on yank; documented stable API (0.11+).
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
})

-- External file changes on BufEnter/FocusGained (no CursorHold polling).
vim.api.nvim_create_autocmd(
  { 'BufEnter', 'FocusGained' },
  { command = 'checktime' }
)

-- Trim trailing whitespace on save. keeppatterns preserves @/; winsaveview
-- preserves both cursor and topline so the screen doesn't jump.
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(event)
    if not vim.bo[event.buf].modifiable then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})
