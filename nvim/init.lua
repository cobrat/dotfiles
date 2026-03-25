-- ============================================================================
-- == BOOTSTRAP & PERFORMANCE ==
-- ============================================================================

vim.g.start_time = vim.uv.hrtime()
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        local ms = (vim.uv.hrtime() - vim.g.start_time) / 1e6
        vim.notify(
            string.format("Start Time: %.2f ms", ms),
            vim.log.levels.INFO
        )
    end,
})

-- ============================================================================
-- == BASIC CONFIGS ==
-- ============================================================================

vim.opt.termguicolors = true
vim.cmd.colorscheme("habamax")

-- -- Transparent Background --
local function set_transparent_bg()
    local groups = {
        "Normal", "NormalNC", "NormalFloat",
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
	numberwidth = 4,
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
	signcolumn = "no",
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
	redrawtime = 2000,
	maxmempattern = 5000,
	showcmd = false,
	cmdheight = 1,
	formatoptions = vim.opt.formatoptions
		- "a"
		- "t"
		+ "c"
		+ "q"
		- "o"
		+ "r"
		+ "n"
		+ "j"
		- "2",
	sessionoptions = "blank,buffers,curdir,folds,help," ..
		"tabpages,winsize,winpos,terminal,localoptions",
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

local function update_number_mode(win)
	win = win or 0
	if not vim.api.nvim_win_is_valid(win) then
		return
	end

	local buf = vim.api.nvim_win_get_buf(win)
	local bt = vim.bo[buf].buftype
	local ft = vim.bo[buf].filetype
	if bt ~= "" or ft == "minifiles" then
		vim.wo[win].relativenumber = false
		return
	end

	vim.wo[win].relativenumber = vim.api.nvim_win_get_width(win) >= 100
end

local function buf_file_size(buf)
	buf = buf or 0
	if vim.bo[buf].buftype ~= "" then
		return "--"
	end

	local name = vim.api.nvim_buf_get_name(buf)
	if name == "" then
		return "--"
	end

	local size = vim.fn.getfsize(name)
	if size <= 0 then
		return "0B"
	end

	local units = { "B", "K", "M", "G" }
	local i = 1
	while size > 1024 and i < #units do
		size = size / 1024
		i = i + 1
	end
	return string.format("%.1f%s", size, units[i])
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
	"a:blinkwait700-blinkoff400-blinkon250-" ..
		"Cursor/lCursor",
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
	local ok, summary = pcall(function()
		return vim.b.minidiff_summary
	end)
	if not ok or not summary or not summary.source_name then
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
		" %s %%f%%h%%m%%r (%s) %s %%= " ..
		"Line:%%-4l Col:%%-3c %%P ",
		mode_tag,
		buf_file_size(0),
		branch
	)
end

local function set_statusline(active)
	if vim.bo.filetype == "minifiles" then
		vim.opt_local.statusline = ""
		return
	end

	if active then
		vim.opt_local.statusline = "%!v:lua.sl_status()"
	else
		vim.opt_local.statusline = "  %f %h%m%r %= %l:%c  "
	end
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "WinEnter" }, {
	callback = function()
		set_statusline(true)
	end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
	callback = function()
		set_statusline(false)
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
	require("conform").format({
		async = true,
		lsp_fallback = true
	}, function(err)
		if err then
			vim.notify("格式化失败: " .. err, vim.log.levels.ERROR)
		else
			vim.notify("格式化完成", vim.log.levels.INFO)
		end
	end)
end, { desc = "Format" })

-- -- Window Ops --
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Right" })
vim.keymap.set("n", "<leader>wv", ":vsplit<CR>", { desc = "V-Split" })
vim.keymap.set("n", "<leader>wh", ":split<CR>", { desc = "H-Split" })
vim.keymap.set("n", "<leader>wc", ":close<CR>", { desc = "Close" })

-- Resize keys (with fallback for tmux/terminal envs)
local is_tmux = vim.env.TMUX ~= nil
if is_tmux then
	vim.keymap.set("n", "<leader>rk", ":resize +2<CR>", { desc = "H-Grow" })
	vim.keymap.set("n", "<leader>rj", ":resize -2<CR>", { desc = "H-Shrink" })
	vim.keymap.set("n", "<leader>rh", ":vertical resize -2<CR>",
		{ desc = "V-Shrink" })
	vim.keymap.set("n", "<leader>rl", ":vertical resize +2<CR>",
		{ desc = "V-Grow" })
else
	vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", { desc = "H-Grow" })
	vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", { desc = "H-Shrink" })
	vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>",
		{ desc = "V-Shrink" })
	vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>",
		{ desc = "V-Grow" })
end

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

local function lsp_picker(scope)
	return function()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		if vim.tbl_isempty(clients) then
			vim.notify("No active LSP for current buffer", vim.log.levels.WARN)
			return
		end
		require("mini.extra").pickers.lsp({ scope = scope })
	end
end

vim.keymap.set("n", "gd", lsp_picker("definition"), { desc = "Def" })
vim.keymap.set("n", "gr", lsp_picker("reference"), { desc = "Refs" })
vim.keymap.set("n", "gi", lsp_picker("implementation"), { desc = "Impl" })
vim.keymap.set("n", "gt", lsp_picker("type_definition"), { desc = "Type" })

-- -- LSP & Diagnostic --
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next" })
vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Line" })

vim.keymap.set("n", "q", "<nop>")
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

vim.api.nvim_create_autocmd({
	"BufEnter",
	"BufWinEnter",
	"VimResized",
	"WinEnter",
}, {
	group = augroup,
	callback = function(args)
		update_number_mode(args.win)
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

-- -- Web Languages Indent (2 spaces) --
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = {
			"javascript", "typescript", "json", "yaml",
			"html", "css", "vue", "svelte",
		},
	callback = function()
		vim.opt_local.tabstop = 2
		vim.opt_local.shiftwidth = 2
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
		{ mode = "n", keys = "gr", desc = "Refs" },
		{ mode = "n", keys = "gi", desc = "Impl" },
		{ mode = "n", keys = "gt", desc = "Type" },
		{ mode = "n", keys = "gR", desc = "Repl" },
		{ mode = "n", keys = "gm", desc = "Mult" },
		{ mode = "n", keys = "gx", desc = "Swap" },
		{ mode = "n", keys = "gs", desc = "Sort" },
	},
	window = {
		config = { border = "single", width = 26, height = 12 },
		delay = 300,
		scroll_down = "<C-d>",
		scroll_up = "<C-u>",
	},
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
		prefix = function(_) return "", "" end,
	},
	windows = { preview = true, width_preview = 80 },
	options = { use_as_default_explorer = true },
})
require("mini.diff").setup({
	view = {
		style = "number",
	},
})

-- -- Mini (Operators) --
require("mini.operators").setup({
	evaluate = { prefix = "g=", desc = "Eval" },
	exchange = { prefix = "gx", desc = "Xchange" },
	multiply = { prefix = "gm", desc = "Mult" },
	replace = { prefix = "gR", desc = "Repl" },
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
local servers = {
	"lua_ls",
	"pyright",
	"bashls",
	"ts_ls",
	"gopls",
	"clangd",
	"rust_analyzer",
}
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
	vim.keymap.set("n", "<leader>ls", function()
		require("mini.extra").pickers.lsp({ scope = "document_symbol" })
	end, { buffer = ev.buf, desc = "Syms" })
	vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action,
		{ buffer = ev.buf, desc = "Action" })
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename,
		{ buffer = ev.buf, desc = "Rename" })
	vim.keymap.set("n", "K", vim.lsp.buf.hover,
		{ buffer = ev.buf, desc = "Hover" })
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
		{ buffer = ev.buf, desc = "Decl" })
end
vim.api.nvim_create_autocmd("LspAttach", { callback = on_attach })

-- -- Completion (Blink) --
require("blink.cmp").setup({
	keymap = { preset = "super-tab" },
	appearance = { nerd_font_variant = "none" },
	sources = { default = { "lsp", "path", "buffer" } },
})

-- -- LSP Servers --
vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})
vim.lsp.config("lua_ls", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})
vim.lsp.config("rust_analyzer", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
			},
		},
	},
})
vim.lsp.enable(servers)

-- -- Formatting (Conform) --
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "black" },
		javascript = { "prettierd" },
		typescript = { "prettierd" },
		rust = { "rustfmt" },
	},
})
