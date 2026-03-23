-- ============================================================================
-- == BASIC CONFIGS ==
-- ============================================================================

vim.opt.termguicolors = true
vim.cmd.colorscheme("habamax")

-- -- Floating Windows --
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#444444", bg = "none" })

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
	cmdheight = 1,
	completeopt = "menuone,noinsert,noselect",
	showmode = false,
	pumheight = 10,
	pumblend = 10,
	winblend = 0,
	conceallevel = 0,
	concealcursor = "",
	synmaxcol = 300,
	backup = false,
	writebackup = false,
	swapfile = false,
	undofile = true,
	updatetime = 200,
	timeoutlen = 400,
	selection = "inclusive",
	mouse = "a",
	modifiable = true,
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

local function git_branch()
	local dict = vim.b.gitsigns_status_dict
	if not dict or not dict.head or dict.head == "" then
		return ""
	end
	local res = string.format(" [%s", dict.head)
	if (dict.added or 0) > 0 then
		res = res .. " +" .. dict.added
	end
	if (dict.changed or 0) > 0 then
		res = res .. " ~" .. dict.changed
	end
	if (dict.removed or 0) > 0 then
		res = res .. " -" .. dict.removed
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
end, { expr = true, silent = true, desc = "Down (wrap-aware)" })
vim.keymap.set("n", "k", function()
	return vim.v.count == 0 and "gk" or "k"
end, { expr = true, silent = true, desc = "Up (wrap-aware)" })

vim.keymap.set("n", "<leader>c", ":nohlsearch<CR>", {
	desc = "Clear search highlights",
})
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up" })

-- Visual mode paste (don't overwrite register)
vim.keymap.set("x", "p", '"_dP', { desc = "Paste without yanking" })
vim.keymap.set({ "n", "v" }, "<leader>x", '"_d', {
	desc = "Delete without yanking",
})

-- -- Buffer Ops --
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", {
	desc = "Previous buffer",
})
-- plugin: mini.bufremove
vim.keymap.set("n", "<leader>bd", function()
	require("mini.bufremove").delete(0, false)
end, { desc = "Delete buffer" })
-- plugin: conform.nvim
vim.keymap.set("n", "<leader>bf", function()
	require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format buffer" })

-- -- Window Ops --
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move right" })
vim.keymap.set("n", "<leader>sv", ":vsplit<CR>", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>sh", ":split<CR>", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>wc", ":close<CR>", { desc = "Close window" })
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>")
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>")
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>")
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>")

-- -- Indent --
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- -- File & Toggle --
vim.keymap.set("n", "<leader>fp", function()
	local path = vim.fn.expand("%:p")
	vim.fn.setreg("+", path)
	print("file:", path)
end, { desc = "Copy file path" })
vim.keymap.set("n", "<leader>td", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })
-- plugin: mini.files
vim.keymap.set("n", "<leader>e", function()
	if not require("mini.files").close() then
		require("mini.files").open(vim.api.nvim_buf_get_name(0))
	end
end, { desc = "Explorer" })

-- fzf-lua
vim.keymap.set("n", "<leader>ff", function()
	require("fzf-lua").files()
end, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", function()
	require("fzf-lua").live_grep()
end, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", function()
	require("fzf-lua").buffers()
end, { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fx", function()
	require("fzf-lua").diagnostics_document()
end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>fz", function()
	require("fzf-lua").blines()
end, { desc = "Fuzzy lines" })
vim.keymap.set("n", "<leader>fo", function()
	require("fzf-lua").oldfiles()
end, { desc = "Old files" })

-- -- Git (Mini.diff & FZF) --
-- plugin: fzf-lua
vim.keymap.set("n", "<leader>gs", function()
	require("fzf-lua").git_status()
end, { desc = "Git status" })
-- plugin: mini.diff
vim.keymap.set("n", "]h", function()
	require("mini.diff").goto_hunk("next")
end, { desc = "Next hunk" })
vim.keymap.set("n", "[h", function()
	require("mini.diff").goto_hunk("prev")
end, { desc = "Prev hunk" })
vim.keymap.set("n", "<leader>hp", function()
	require("mini.diff").toggle_overlay(0)
end, { desc = "Toggle hunk overlay" })

-- -- LSP & Diagnostic --
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {
	desc = "Prev diagnostic",
})
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {
	desc = "Next diagnostic",
})
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, {
	desc = "Line diagnostics",
})

vim.keymap.set("n", "Q", "<nop>")

-- ============================================================================
-- == AUTOCMDS ==
-- ============================================================================

local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })

-- -- Diagnostics Float --
vim.api.nvim_create_autocmd("CursorHold", {
	group = augroup,
	callback = function()
		if vim.bo.buftype ~= "" then return end
		vim.diagnostic.open_float(nil, {
			focusable = false,
			close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
			border = "single",
			source = "always",
			prefix = " ",
			scope = "cursor",
		})
	end,
})

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
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.spell = true
	end,
})

-- ============================================================================
-- == PLUGINS ==
-- ============================================================================

local plugins = {
	"https://www.github.com/echasnovski/mini.nvim",
	"https://www.github.com/ibhagwan/fzf-lua",
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
	"fzf-lua",
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
		{ mode = "n", keys = "z" },
		{ mode = "x", keys = "z" },
	},
	clues = {
		miniclue.gen_clues.builtin_completion(),
		miniclue.gen_clues.registers(),
		miniclue.gen_clues.windows(),
		miniclue.gen_clues.z(),
		{ mode = "n", keys = "<leader>b", desc = "Buffer" },
		{ mode = "n", keys = "<leader>f", desc = "Find/LSP" },
		{ mode = "n", keys = "<leader>g", desc = "Git" },
		{ mode = "n", keys = "<leader>h", desc = "Hunk" },
		{ mode = "n", keys = "<leader>l", desc = "LSP" },
		{ mode = "n", keys = "<leader>s", desc = "Split" },
		{ mode = "n", keys = "<leader>t", desc = "Toggle" },
		{ mode = "n", keys = "<leader>w", desc = "Window" },
	},
	window = { config = { border = "single" }, delay = 300 },
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
require("mini.files").setup({
	content = {
		filter = nil,
		prefix = function(fs_entry) return "", "" end,
		sort = nil,
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
require("mini.operators").setup({
	evaluate = { prefix = "g=" },
	exchange = { prefix = "gx" },
	multiply = { prefix = "gm" },
	replace = { prefix = "gr" },
	sort = { prefix = "gs" },
})

-- -- Treesitter --
-- Use manual treesitter start to avoid nvim-treesitter.configs dependency.
local ensure_installed = {
	"vim", "vimdoc", "rust", "c", "cpp", "go", "html", "css",
	"javascript", "json", "markdown", "typescript", "vue",
	"svelte", "bash", "lua", "python",
}

-- Try to load nvim-treesitter if available for management
local has_ts, ts_install = pcall(require, "nvim-treesitter.install")
if has_ts and ts_install.commands and ts_install.commands.TSUpdate then
	local has_ts_config, ts_config = pcall(require, "nvim-treesitter.config")
	local already_installed = {}
	if has_ts_config and ts_config.get_installed_parsers then
		already_installed = ts_config.get_installed_parsers()
	end

	local to_install = {}
	for _, parser in ipairs(ensure_installed) do
		if not vim.tbl_contains(already_installed, parser) then
			table.insert(to_install, parser)
		end
	end
	if #to_install > 0 then
		ts_install.commands.TSUpdate.run(to_install)
	end
end

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("TSConfig", { clear = true }),
	callback = function(args)
		local lang = vim.treesitter.language.get_lang(args.match)
		if lang and args.match ~= "minifiles" then
			vim.treesitter.start(args.buf)
		end
	end,
})

-- -- FZF-lua --
require("fzf-lua").setup({
	winopts = { preview = { layout = "vertical" } },
})

-- -- Git (Mini.diff) --
-- Diff already setup in mini section

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
	local opts = { buffer = ev.buf }
	vim.keymap.set("n", "gd", function()
		require("fzf-lua").lsp_definitions({ jump_to_single_result = true })
	end, opts)
	vim.keymap.set("n", "gr", function()
		require("fzf-lua").lsp_references()
	end, opts)
	vim.keymap.set("n", "gi", function()
		require("fzf-lua").lsp_implementations()
	end, opts)
	vim.keymap.set("n", "gt", function()
		require("fzf-lua").lsp_typedefs()
	end, opts)
	vim.keymap.set("n", "<leader>ls", function()
		require("fzf-lua").lsp_document_symbols()
	end, opts)
	vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
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
		javascript = { "prettier_d" },
		typescript = { "prettier_d" },
	},
})
