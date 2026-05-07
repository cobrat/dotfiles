require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    changedelete = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '^' },
    untracked = { text = '+' },
  },
  -- Inline virtual diff at cursor hunk.
  -- Clears on cursor move / leaving buffer.
  word_diff = false,
  on_attach = function(bufnr)
    vim.keymap.set('n', '<Leader>gh', function()
      require('gitsigns').preview_hunk_inline()
    end, {
      buffer = bufnr,
      desc = 'Gitsigns: inline hunk preview',
    })

    vim.keymap.set('n', '<Leader>gn', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        require('gitsigns').nav_hunk('next')
      end
    end, {
      buffer = bufnr,
      desc = 'Next hunk or vimdiff change',
    })

    vim.keymap.set('n', '<Leader>gp', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        require('gitsigns').nav_hunk('prev')
      end
    end, {
      buffer = bufnr,
      desc = 'Previous hunk or vimdiff change',
    })
  end,
})
