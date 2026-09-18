-- cache Lua bytecode; must run before the first require
vim.loader.enable()

require("config.core")
require("config.theme")
require("config.plugins")
require("config.lsp")
require("config.treesitter")
