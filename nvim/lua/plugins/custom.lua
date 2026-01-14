return {
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "tokyonight-night",
        },
    },
    {
        "nvim-lspconfig",
        opts = {
            inlay_hints = { enabled = false },
        },
    },
    {
        "saghen/blink.cmp",
        opts = function(_, opts)
            opts.keymap = {
                preset = "none",
                ["<CR>"] = { "fallback" },
                ["<Tab>"] = { "select_and_accept", "fallback" },
            }
            opts.completion = {
                ghost_text = { enabled = false },
            }
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = function(_, opts)
            local icons = require("lazyvim.config").icons
            opts.options.section_separators = { left = "", right = "" }
            opts.options.component_separators = { left = "|", right = "|" }
            opts.sections.lualine_a = {
                {
                    "mode",
                    fmt = function(str)
                        return str:sub(1, 1):upper() .. str:sub(2):lower()
                    end,
                },
            }
            opts.sections.lualine_c = {
                LazyVim.lualine.root_dir(),
                {
                    "diagnostics",
                    symbols = {
                        error = icons.diagnostics.Error,
                        warn = icons.diagnostics.Warn,
                        info = icons.diagnostics.Info,
                        hint = icons.diagnostics.Hint,
                    },
                },
                { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
                {
                    function()
                        local path = vim.fn.expand("%:.")
                        if path == "" then
                            return ""
                        end
                        local parts = vim.split(path, "[\\/]")
                        if #parts > 2 then
                            return parts[#parts - 1] .. "/" .. parts[#parts]
                        end
                        return path
                    end,
                },
            }
            opts.sections.lualine_y = {
                {
                    function()
                        local curr = vim.fn.line(".")
                        local total = vim.fn.line("$")
                        return string.format("%d:%d", curr, total)
                    end,
                    padding = { left = 1, right = 1 },
                },
            }
            opts.sections.lualine_z = {
                {
                    function()
                        return string.format("Col:%d", vim.fn.virtcol("."))
                    end,
                    padding = { left = 1, right = 1 },
                },
            }
        end,
    },
}
