-- ============================================================================
-- == BASIC CONFIGS ==
-- ============================================================================

vim.opt.termguicolors = true
vim.cmd.colorscheme("habamax")

-- -- Transparent Background --
local function set_transparent_bg()
    local groups = {
        "Normal", "NormalNC", "NormalFloat", "FloatBorder",
        "SignColumn", "LineNr", "CursorLineNr",
        "EndOfBuffer",
    }
    for _, g in ipairs(groups) do
        vim.api.nvim_set_hl(0, g, { bg = "none" })
    end
    vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#444444", bg = "none" })
end

set_transparent_bg()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_transparent_bg })

-- -- Core Options --
local options = {
	number = true,
	relativenumber = true,
	cursorline = true,
	wrap = true,
	scrolloff = 10,
	sidescrolloff = 10,
	colorcolumn = "80",
	tabstop = 4,
	shiftwidth = 4,
	expandtab = true,
	smartindent = true,
	ignorecase = true,
	smartcase = true,
	hlsearch = true,
	signcolumn = "yes",
	completeopt = "menuone,noinsert,noselect",
	showmode = false,
	pumheight = 10,
	pumblend = 10,
	synmaxcol = 300,
	backup = false,
	writebackup = false,
	swapfile = false,
	undofile = true,
	updatetime = 200,
	timeoutlen = 400,
	mouse = "a",
	splitbelow = true,
	splitright = true,
	wildmode = "longest:full,full",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- -- UI Decor --
vim.opt.fillchars = {
	eob = " ",
	fold = " ",
	foldopen = "-",
	foldsep = "|",
	foldclose = "+",
}

vim.opt.clipboard:append("unnamedplus")
vim.opt.diffopt:append("linematch:60")

vim.opt.guicursor = table.concat({
	"n-v-c:block",
	"i-ci-ve:block",
	"r-cr:hor20",
	"o:hor50",
	"a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
	"sm:block-blinkwait175-blinkoff150-blinkon175",
}, ",")

-- -- Folding --
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99

-- ============================================================================
-- == STATUSLINE ==
-- ============================================================================

-- -- Statusline --
local function git_branch()
	local summary = vim.b.minidiff_summary
	if not summary or not summary.source_name then
		return ""
	end
	local res = string.format(" [%s", summary.source_name)
	if (summary.add or 0) > 0 then
		res = res .. " +" .. summary.add
	end
	if (summary.change or 0) > 0 then
		res = res .. " ~" .. summary.change
	end
	if (summary.delete or 0) > 0 then
		res = res .. " -" .. summary.delete
	end
	return res .. "]"
end

local cached_size = "0B"
local function update_file_size()
	local size = vim.fn.getfsize(vim.fn.expand("%"))
	if size <= 0 then
		cached_size = "0B"
		return
	end
	local units = { "B", "K", "M", "G" }
	local i = 1
	while size > 1024 and i < #units do
		size = size / 1024
		i = i + 1
	end
	cached_size = string.format("%.1f%s", size, units[i])
end

local sl_modes = {
	n = "--NORMAL--",
	i = "--INSERT--",
	v = "--VISUAL--",
	V = "--V-LINE--",
	["\22"] = "--V-BLOCK--",
	c = "--COMMAND--",
	R = "--REPLACE--",
	t = "--TERMINAL--",
}

_G.sl_status = function()
	local m = vim.api.nvim_get_mode().mode
	local mode_tag = sl_modes[m] or ("--" .. m:upper() .. "--")
	local branch = git_branch()

	return string.format(
		" %s %%f%%h%%m%%r (%s) %s %%= Line:%%-4l Col:%%-3c %%P ",
		mode_tag,
		cached_size,
		branch
	)
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "BufWritePost" }, {
	callback = function()
		if vim.bo.filetype == "minifiles" then
			vim.opt_local.statusline = ""
			return
		end
		update_file_size()
		vim.opt_local.statusline = "%!v:lua.sl_status()"
	end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	callback = function()
		vim.opt_local.statusline = "  %f %h%m%r %= %l:%c  "
	end,
})

-- ============================================================================
-- == GLOBAL KEYMAPS ==
-- ============================================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- -- Navigation --
vim.keymap.set("n", "j", function()
	return vim.v.count == 0 and "gj" or "j"
end, { expr = true, silent = true, desc = "Down" })
vim.keymap.set("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up" })

vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", { desc = "Clear" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Up" })

-- Visual mode paste (don't overwrite register)
vim.keymap.set("x", "p", '"_dP', { desc = "Paste" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', { desc = "Delete" })

-- -- Buffer Ops --
vim.keymap.set("n", "<leader>bb", "<C-^>", { desc = "Alt" })
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Prev" })
-- plugin: mini.bufremove
vim.keymap.set("n", "<leader>bd", function()
	require("mini.bufremove").delete(0, false)
end, { desc = "Del" })
-- plugin: conform.nvim
vim.keymap.set("n", "<leader>bf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format" })

-- -- Window Ops --
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Right" })
vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", { desc = "V-Split" })
vim.keymap.set("n", "<leader>wh", ":split<CR>", { desc = "H-Split" })
vim.keymap.set("n", "<leader>wc", ":close<CR>", { desc = "Close" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "H-Grow" })
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "H-Shrink" })
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>",
	{ desc = "V-Shrink" })
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "V-Grow" })

-- -- Indent --
vim.keymap.set("v", "<", "<gv", { desc = "Unindent" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent" })

-- -- File --
vim.keymap.set("n", "<leader>fp", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "Path" })
vim.keymap.set("n", "<leader>lt", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle Diag" })
-- plugin: mini.files
vim.keymap.set("n", "<leader>e", function()
	if not require("mini.files").close() then
		require("mini.files").open(vim.api.nvim_buf_get_name(0))
	end
end, { desc = "Explorer" })

-- mini.pick / mini.extra
vim.keymap.set("n", "<leader>ff", function()
	require("mini.pick").builtin.files()
end, { desc = "File" })
vim.keymap.set("n", "<leader>fg", function()
	require("mini.pick").builtin.grep_live()
end, { desc = "Grep" })
vim.keymap.set("n", "<leader>fb", function()
	require("mini.pick").builtin.buffers()
end, { desc = "Buf" })
vim.keymap.set("n", "<leader>fx", function()
	require("mini.extra").pickers.diagnostic({ scope = "current" })
end, { desc = "Diag" })
vim.keymap.set("n", "<leader>fz", function()
	require("mini.extra").pickers.buf_lines()
end, { desc = "Line" })
vim.keymap.set("n", "<leader>fo", function()
	require("mini.extra").pickers.oldfiles()
end, { desc = "Old" })

-- -- Git (Mini.diff & Mini.extra) --
-- plugin: mini.extra
vim.keymap.set("n", "<leader>gs", function()
	require("mini.extra").pickers.git_hunks()
end, { desc = "Hunks" })
-- plugin: mini.diff
vim.keymap.set("n", "<leader>gn", function()
	require("mini.diff").goto_hunk("next")
end, { desc = "Next" })
vim.keymap.set("n", "<leader>gp", function()
	require("mini.diff").goto_hunk("prev")
end, { desc = "Prev" })
vim.keymap.set("n", "<leader>gh", function()
	require("mini.diff").toggle_overlay(0)
end, { desc = "Hunk" })

-- -- LSP & Diagnostic --
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next" })
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line" })

vim.keymap.set("n", "Q", "<nop>")

-- ============================================================================
-- == AUTOCMDS ==
-- ============================================================================

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- -- Utility --
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	callback = function()
		vim.hl.on_yank()
	end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
	group = augroup,
	callback = function()
		if vim.fn.getcmdwintype() == "" then
			vim.cmd("checktime")
		end
	end,
})

-- -- Cursor Pos --
vim.api.nvim_create_autocmd("BufReadPost", {
	group = augroup,
	callback = function()
		local last_pos = vim.api.nvim_buf_get_mark(0, '"')
		local count = vim.api.nvim_buf_line_count(0)
		if last_pos[1] > 0 and last_pos[1] <= count then
			pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
		end
	end,
})

-- -- Filetype Specific --
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "markdown", "text", "gitcommit" },
	callback = function()
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- ============================================================================
-- == PLUGINS ==
-- ============================================================================

local plugins = {
	"https://www.github.com/echasnovski/mini.nvim",
	{
		src = "https://github.com/nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	"https://www.github.com/neovim/nvim-lspconfig",
	"https://github.com/williamboman/mason-lspconfig.nvim",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/stevearc/conform.nvim",
	{ src = "https://github.com/saghen/blink.cmp", version = "1.*" },
}
vim.pack.add(plugins)

for _, p in ipairs({
	"nvim-treesitter",
	"mini.nvim",
	"nvim-lspconfig",
	"mason-lspconfig.nvim",
	"mason.nvim",
	"conform.nvim",
	"blink.cmp",
}) do
	vim.cmd("packadd " .. p)
end

-- ============================================================================
-- == PLUGIN CONFIGS ==
-- ============================================================================

-- -- Mini (Modules) --
local miniclue = require("mini.clue")
miniclue.setup({
	triggers = {
		{ mode = "n", keys = "<leader>" },
		{ mode = "x", keys = "<leader>" },
		{ mode = "n", keys = "g" },
		{ mode = "x", keys = "g" },
		{ mode = "n", keys = "'" },
		{ mode = "n", keys = "`" },
		{ mode = "x", keys = "'" },
		{ mode = "x", keys = "`" },
		{ mode = "n", keys = '"' },
		{ mode = "x", keys = '"' },
		{ mode = "n", keys = "<C-w>" },
		{ mode = "n", keys = "[" },
		{ mode = "n", keys = "]" },
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
	},
	clues = {
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
		{ mode = "n", keys = "<leader>b", desc = "Buffer" },
		{ mode = "n", keys = "<leader>f", desc = "Find" },
		{ mode = "n", keys = "<leader>g", desc = "Git" },
		{ mode = "n", keys = "<leader>l", desc = "LSP" },
		{ mode = "n", keys = "<leader>w", desc = "Window" },
		-- Custom g-clues
		{ mode = "n", keys = "gd", desc = "Def" },
		{ mode = "n", keys = "gr", desc = "Ref/Repl" },
		{ mode = "n", keys = "gi", desc = "Impl" },
		{ mode = "n", keys = "gt", desc = "TypeDef" },
		{ mode = "n", keys = "g=", desc = "Eval" },
		{ mode = "n", keys = "gx", desc = "Xchange" },
		{ mode = "n", keys = "gm", desc = "Mult" },
		{ mode = "n", keys = "gs", desc = "Sort" },
	},
	window = { config = { border = "single", width = "auto" }, delay = 300 },
})

require("mini.ai").setup({})
require("mini.move").setup({})
require("mini.surround").setup({
	mappings = {
		add = "sa", delete = "sd", find = "sf", find_left = "sF",
		highlight = "sh", replace = "sr", update_n_lines = "sn",
	},
})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({
	draw = { delay = 100, priority = 2 },
	symbol = "|",
	options = { try_as_border = true },
})
require("mini.pairs").setup({})
require("mini.trailspace").setup({})
require("mini.bufremove").setup({})
require("mini.pick").setup({})
require("mini.extra").setup({})
require("mini.files").setup({
	content = {
		prefix = function(fs_entry) return "", "" end,
	},
	windows = { preview = true, width_preview = 80 },
	options = { use_as_default_explorer = true },
})
require("mini.diff").setup({
	view = {
		style = "sign",
		signs = { add = "+", change = "~", delete = "-" },
	},
})

-- -- Hunk Colors (Link to theme) --
vim.api.nvim_set_hl(0, "MiniDiffSignAdd", { fg = "#77cc77", bg = "none" })
vim.api.nvim_set_hl(0, "MiniDiffSignChange", { fg = "#cccc77", bg = "none" })
vim.api.nvim_set_hl(0, "MiniDiffSignDelete", { fg = "#cc7777", bg = "none" })

-- -- Mini (Operators) --
require("mini.operators").setup({
	evaluate = { prefix = "g=", desc = "Eval" },
	exchange = { prefix = "gx", desc = "Xchange" },
	multiply = { prefix = "gm", desc = "Mult" },
	replace = { prefix = "gr", desc = "Repl" },
	sort = { prefix = "gs", desc = "Sort" },
})

-- -- Treesitter --
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TSConfig", { clear = true }),
	callback = function(args)
		local ok, lang = pcall(vim.treesitter.language.get_lang, args.match)
		if ok and lang and args.match ~= "minifiles" then
			pcall(vim.treesitter.start, args.buf, lang)
		end
	end,
})

-- -- LSP --
local servers = { "lua_ls", "pyright", "bashls", "ts_ls", "gopls", "clangd" }
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = servers,
})
vim.diagnostic.config({
	virtual_text = { prefix = "*", spacing = 4 },
	signs = false,
	float = { border = "single" },
})

local function on_attach(ev)
	vim.keymap.set("n", "gd", function()
		require("mini.extra").pickers.lsp({ scope = "definition" })
	end, { buffer = ev.buf, desc = "Def" })
	vim.keymap.set("n", "gr", function()
		require("mini.extra").pickers.lsp({ scope = "reference" })
	end, { buffer = ev.buf, desc = "Ref" })
	vim.keymap.set("n", "gi", function()
		require("mini.extra").pickers.lsp({ scope = "implementation" })
	end, { buffer = ev.buf, desc = "Impl" })
	vim.keymap.set("n", "gt", function()
		require("mini.extra").pickers.lsp({ scope = "type_definition" })
	end, { buffer = ev.buf, desc = "TypeDef" })
	vim.keymap.set("n", "<leader>ls", function()
		require("mini.extra").pickers.lsp({ scope = "document_symbol" })
	end, { buffer = ev.buf, desc = "Syms" })
	vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action,
		{ buffer = ev.buf, desc = "Action" })
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename,
		{ buffer = ev.buf, desc = "Rename" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover,
		{ buffer = ev.buf, desc = "Hover" })
end
vim.api.nvim_create_autocmd("LspAttach", { callback = on_attach })

-- -- Completion (Blink) --
require("blink.cmp").setup({
	keymap = { preset = "super-tab" },
	appearance = { nerd_font_variant = "none" },
	sources = { default = { "lsp", "path", "buffer" } },
})

-- -- LSP Servers --
for _, s in ipairs(servers) do
	local cfg = { capabilities = require("blink.cmp").get_lsp_capabilities() }
	if s == "lua_ls" then
		cfg.settings = { Lua = { diagnostics = { globals = { "vim" } } } }
	end
	vim.lsp.config(s, cfg)
end
vim.lsp.enable(servers)

-- -- Formatting (Conform) --
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
	},
})
