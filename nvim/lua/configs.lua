-- ~/.config/nvim-new/lua/configs.lua
local opt = vim.opt

-- UI and Appearance
-- opt.guicursor = "i:block" -- Use block cursor in insert mode
opt.termguicolors = true -- Enable true colors support
-- opt.colorcolumn = "80" -- Vertical ruler at column 80
opt.signcolumn = "yes:1" -- Always show the sign column
opt.cursorline = true -- Highlight the current line
-- opt.winborder = "rounded" -- Use rounded borders for windows
vim.cmd.colorscheme("tokyonight-night")

-- Line Numbers and Layout
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.numberwidth = 2 -- Width of the line number column
opt.wrap = true -- Enable line wrapping
opt.scrolloff = 8 -- Keep 8 lines above and below the cursor

-- Search and Patterns
opt.ignorecase = true -- Ignore case in search patterns
opt.smartcase = true -- Override ignorecase if search contains uppercase
opt.hlsearch = false -- Disable highlighting of search results
opt.inccommand = "nosplit" -- Preview substitutions incrementally
opt.completeopt = { "menuone", "popup", "noinsert" } -- Completion menu behavior

-- Indentation and Tabs
opt.autoindent = true -- Enable auto indentation
opt.expandtab = true -- Use spaces instead of tabs
opt.tabstop = 4 -- Number of spaces for a tab
opt.softtabstop = 4 -- Number of spaces for a tab when editing
opt.shiftwidth = 4 -- Number of spaces for autoindent
opt.shiftround = true -- Round indent to multiple of shiftwidth

-- File and Backup
-- opt.swapfile = false -- Disable swap files
-- opt.undofile = true -- Enable persistent undo
-- opt.undodir = os.getenv('HOME') .. '/.vim/undodir' -- Directory for undo files

-- Whitespace Characters
opt.list = true -- Show whitespace characters
opt.listchars = "tab: ,multispace:|   ,eol:󰌑" -- Symbols for invisible characters

-- Filetype Settings
vim.cmd.filetype("plugin indent on") -- Enable filetype detection, plugins, and indentation

-- Netrw Settings
vim.g.netrw_liststyle = 1 -- Use the long listing view
vim.g.netrw_sort_by = "size" -- Sort files by size
