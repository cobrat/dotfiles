-- ~/.config/nvim/lua/plugins/no-icons.lua
return {
  -- LazyVim 全局图标配置
  {
    "LazyVim/LazyVim",
    opts = {
      icons = {
        misc = { dots = "..." },
        ft = { octo = "" },
        dap = {
          Stopped = { ">", "DiagnosticWarn", "DapStoppedLine" },
          Breakpoint = "B",
          BreakpointCondition = "C",
          BreakpointRejected = { "R", "DiagnosticError" },
          LogPoint = "L",
        },
        diagnostics = {
          Error = "E:",
          Warn = "W:",
          Hint = "H:",
          Info = "I:",
        },
        git = {
          added = "+",
          modified = "~",
          removed = "-",
        },
        kinds = {},
      },
    },
  },

  -- lazy.nvim UI 图标
  {
    "folke/lazy.nvim",
    opts = {
      ui = {
        icons = {
          cmd = "[cmd]",
          config = "[cfg]",
          event = "[event]",
          ft = "[ft]",
          init = "[init]",
          import = "[import]",
          keys = "[keys]",
          lazy = "[lazy]",
          loaded = "[+]",
          not_loaded = "[-]",
          plugin = "[plugin]",
          runtime = "[runtime]",
          require = "[require]",
          source = "[source]",
          start = "[start]",
          task = "[done]",
          list = { "*", "-", "-", "-" },
        },
      },
    },
  },

  -- lualine 配置
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.options.icons_enabled = false
      opts.options.section_separators = { left = "", right = "" }
      opts.options.component_separators = { left = "", right = "" }

      opts.sections.lualine_c = {
        LazyVim.lualine.root_dir(),
        {
          "diagnostics",
          symbols = { error = "E:", warn = "W:", info = "I:", hint = "H:" },
        },
        {
          "filetype",
          icon_only = false,
          separator = "",
          padding = { left = 1, right = 0 },
        },
        { LazyVim.lualine.pretty_path() },
      }

      opts.sections.lualine_x = {
        {
          "diff",
          symbols = { added = "+", modified = "~", removed = "-" },
          source = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
              return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
              }
            end
          end,
        },
      }

      opts.sections.lualine_y = {
        {
          function()
            return vim.fn.line(".") .. "/" .. vim.fn.line("$")
          end,
          padding = { left = 1, right = 1 },
        },
      }

      opts.sections.lualine_z = { "location" }

      return opts
    end,
  },

  -- bufferline 配置
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
        offsets = {},
      },
    },
  },

  -- snacks.nvim 配置
  {
    "snacks.nvim",
    opts = {
      dashboard = { enabled = false },
      input = { icon = "" },
      explorer = {
        icons = {
          files = { enabled = false },
        },
      },
      picker = {
        icons = {
          files = { enabled = false },
        },
        formatters = {
          file = {
            filename_first = false,
            icon_enabled = false,
          },
        },
        sources = {
          explorer = {
            layout = { auto_hide = { "input" } },
          },
        },
      },
      toggle = {
        icon = { enabled = "[x]", disabled = "[ ]" },
      },
      lazygit = {
        config = {
          gui = { nerdFontsVersion = "" },
        },
      },
    },
  },

  -- which-key 配置
  {
    "folke/which-key.nvim",
    opts = {
      icons = {
        breadcrumb = ">>",
        separator = "->",
        group = "+",
        mappings = false,
      },
    },
  },

  -- noice.nvim 配置
  {
    "folke/noice.nvim",
    opts = {
      lsp = {
        progress = { enabled = false },
      },
    },
  },

  -- 禁用 mini.icons
  { "nvim-mini/mini.icons", enabled = false },
}
