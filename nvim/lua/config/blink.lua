require('blink.cmp').setup({
  keymap = {
    preset = 'super-tab',
  },
  appearance = {
    nerd_font_variant = 'normal',
  },
  completion = {
    documentation = {
      auto_show = false,
    },
    list = {
      selection = {
        preselect = false,
        auto_insert = false,
      },
    },
    menu = {
      border = 'rounded',
      draw = {
        columns = {
          { 'label', 'label_description', gap = 1 },
          { 'kind' },
        },
      },
    },
  },
  sources = {
    default = { 'lsp', 'path', 'buffer' },
  },
  cmdline = {
    enabled = false,
  },
  fuzzy = {
    implementation = 'prefer_rust_with_warning',
  },
})
