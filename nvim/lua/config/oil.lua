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
