-- LANGUAGE SERVER PROTOCOL

-- Defaults merged into every server config below.
vim.lsp.config('*', {
    root_markers = { '.git' },
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.diagnostic.config({
    virtual_text  = true,
    severity_sort = true,
    float         = {
        style  = 'minimal',
        border = 'rounded',
        source = 'if_many',
        header = '',
        prefix = '',
    },
})

local orig = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts            = opts or {}
    opts.border     = opts.border or 'rounded'
    opts.max_width  = opts.max_width or 80
    opts.max_height = opts.max_height or 24
    opts.wrap       = opts.wrap ~= false
    return orig(contents, syntax, opts, ...)
end

-- clear = true so re-sourcing (<leader>rl) replaces old autocmds
local lsp_augroup = vim.api.nvim_create_augroup('my.lsp', { clear = true })

vim.api.nvim_create_autocmd('LspAttach', {
    group = lsp_augroup,
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        local buf    = args.buf
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end

        map('n', 'K', vim.lsp.buf.hover, 'Hover')
        map('n', 'gd', vim.lsp.buf.definition, 'Go to definition')
        map('n', 'gD', vim.lsp.buf.declaration, 'Go to declaration')
        map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
        map('n', 'go', vim.lsp.buf.type_definition, 'Go to type definition')
        map('n', 'gr', vim.lsp.buf.references, 'References')
        map('n', 'gs', vim.lsp.buf.signature_help, 'Signature help')
        map('n', 'gl', vim.diagnostic.open_float, 'Diagnostics float')
        map('n', '<leader>cr', vim.lsp.buf.rename, 'Rename symbol')
        map({ 'n', 'x' }, '<leader>cf', function() vim.lsp.buf.format({ async = true }) end, 'Format (LSP)')
        map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')

        if client:supports_method('textDocument/documentHighlight') then
            local highlight_augroup = vim.api.nvim_create_augroup('my.lsp.highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                buffer = buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                buffer = buf,
                group = highlight_augroup,
                callback = vim.lsp.buf.clear_references,
            })
        end
    end,
})

-- luals settings for editing this config itself; the library is kept narrow
-- (VIMRUNTIME + config dir) so cold-start indexing stays fast
vim.lsp.config['luals'] = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = { globals = { 'vim' } },
            workspace = {
                checkThirdParty = false,
                library = { vim.env.VIMRUNTIME, vim.fn.stdpath('config') },
            },
            telemetry = { enable = false },
        },
    },
}

vim.lsp.config['rust_analyzer'] = {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = { 'Cargo.toml', 'rust-project.json', '.git' },
    settings = {
        ['rust-analyzer'] = {
            cargo = { allFeatures = true },
            formatting = {
                command = { "rustfmt" }
            },
        },
    },
}

-- C / C++ via clangd
vim.lsp.config['clangd'] = {
    cmd = {
        'clangd',
        -- '--background-index',
        -- '--clang-tidy',
        -- '--header-insertion=never',
        -- '--completion-style=detailed',
        -- '--query-driver=/nix/store/*-gcc-*/bin/gcc*,/nix/store/*-clang-*/bin/clang*,/run/current-system/sw/bin/cc*',
    },
    filetypes = { 'c', 'cpp' },
    root_markers = { 'compile_commands.json', '.clangd', 'configure.ac', 'Makefile', '.git' },
    -- init_options = {
    --     fallbackFlags = { '-std=c23' }, -- Default to C23
    -- },
}

vim.lsp.config['jsonls'] = {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    root_markers = { 'package.json', '.git', 'config.jsonc' },
}

vim.lsp.config['gopls'] = {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_markers = { 'go.mod', 'go.work', '.git' },
    settings = {
        gopls = {
            analyses = {
                unusedparams = false,
                ST1003 = false,
                ST1000 = false,
            },
            staticcheck = true,
        },
    },
}

vim.lsp.config['pyright'] = {
    cmd = { 'pyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', '.git' },
}

vim.lsp.config['bashls'] = {
    cmd = { 'bash-language-server', 'start' },
    filetypes = { 'sh', 'bash' },
    root_markers = { '.git' },
}

vim.lsp.config['yamlls'] = {
    cmd = { 'yaml-language-server', '--stdio' },
    filetypes = { 'yaml', 'yaml.docker-compose', 'yaml.github' },
    root_markers = { '.git' },
}

vim.filetype.add({
    extension = {
        h = 'c',
    },
})

-- Enable servers whose binary is on PATH. The binary is read from each
-- config's cmd, so the name list is the only thing to maintain here (single
-- source of truth, no cmd/binary pairs to keep in sync).
local servers = {
    'luals', 'clangd', 'jsonls', 'yamlls', 'gopls', 'rust_analyzer',
    'pyright', 'bashls',
}

for _, name in ipairs(servers) do
    local cmd = vim.lsp.config[name].cmd
    if type(cmd) == 'table' and vim.fn.executable(cmd[1]) == 1 then
        vim.lsp.enable(name)
    end
end
