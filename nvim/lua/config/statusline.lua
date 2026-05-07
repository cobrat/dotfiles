-- Between current/total line; alternatives: ∶ · – | : → ~
local LINE_SEP = '∶'

local function line_cur_total()
  local cur = vim.fn.line('.')
  local last = vim.fn.line('$')
  if last < 1 then
    return ''
  end
  local w = #tostring(last)
  local fmt = 'L %0' .. w .. 'd' .. LINE_SEP .. '%0' .. w .. 'd'
  return string.format(fmt, cur, last)
end

local function col_cursor()
  local c = vim.fn.virtcol('.')
  return string.format('C %02d', c)
end

require('lualine').setup({
  options = {
    theme = 'gruvbox',
    icons_enabled = false,
    globalstatus = true,
    component_separators = '',
    section_separators = '',
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = { 'filename' },
    lualine_x = { 'encoding', 'fileformat' },
    lualine_y = { col_cursor },
    lualine_z = { line_cur_total },
  },
})
