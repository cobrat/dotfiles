if #vim.api.nvim_list_uis() == 0 then
  return
end

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
