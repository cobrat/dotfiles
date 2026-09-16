-- LANGUAGE SERVER PROTOCOL

vim.lsp.config('*', {
    root_markers = { '.git' },
})

vim.diagnostic.config({
    -- inline text on every line, including the cursor line; the float is manual
    virtual_text  = { prefix = '>' },
    severity_sort = true,
    float         = {
        style  = 'minimal',
        source = 'if_many',
        header = '',
        prefix = '',
    },
})

-- centered jumps; count keeps 3]d working
vim.keymap.set('n', ']d', '<Cmd>lua vim.diagnostic.jump({ count = vim.v.count1 })<CR>zz',
    { desc = 'Next diagnostic, centered' })
vim.keymap.set('n', '[d', '<Cmd>lua vim.diagnostic.jump({ count = -vim.v.count1 })<CR>zz',
    { desc = 'Previous diagnostic, centered' })

local orig = vim.lsp.util.open_floating_preview
---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
    opts            = opts or {}
    -- the runtime sets no default max height, so a long hover would fill the screen
    opts.max_height = opts.max_height or 24
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
        -- references: native grr or <leader>fr; a `gr` map would shadow the
        -- native gr* prefix and cost a timeoutlen wait on every press
        map('n', 'gs', vim.lsp.buf.signature_help, 'Signature help')
        -- manual float for the diagnostics of the current line (native <C-w>d
        -- does the same and works without a client)
        map('n', 'gl', vim.diagnostic.open_float, 'Diagnostics float')
        map('n', '<leader>cr', vim.lsp.buf.rename, 'Rename symbol')
        map({ 'n', 'x' }, '<leader>cf', function() vim.lsp.buf.format({ async = true }) end, 'Format (LSP)')
        map('n', '<leader>ca', vim.lsp.buf.code_action, 'Code action')

        -- the menu itself comes from 'autocomplete' + 'complete' (core.lua); this
        -- enables LSP item conversion and the <C-y> side effects (snippets, edits)
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
        end

        -- inlay hints are off by default in 0.12
        if client:supports_method('textDocument/inlayHint') then
            map('n', '<leader>ti', function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }),
                    { bufnr = buf })
            end, 'Toggle inlay hints')
        end

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

-- narrow library keeps cold-start indexing fast
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
    cmd = { 'clangd' },
    filetypes = { 'c', 'cpp' },
    root_markers = { 'compile_commands.json', '.clangd', 'configure.ac', 'Makefile', '.git' },
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

-- .h is always cpp in Neovim (g:c_syntax_for_h would force c for every
-- header), so sniff for C++-only constructs and default to c
-- ponytail: strongest signals only; a header using just <optional>/override
-- still lands in C. Add patterns back if that shows up in practice.
local cpp_only = {
    '%f[%w]class%f[%W]', '%f[%w]template%f[%W]', '%f[%w]namespace%f[%W]',
    '%f[%w]constexpr%f[%W]', '%f[%w]nullptr%f[%W]', '%f[%w]typename%f[%W]',
    '%f[%w]virtual%f[%W]', '%f[%w]override%f[%W]', '::',
    '#include%s*<[%w_]*vector%f[%W]', '#include%s*<[%w_]*iostream%f[%W]',
}

vim.filetype.add({
    extension = {
        h = function(_, bufnr)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, 0, 200, false)) do
                for _, pat in ipairs(cpp_only) do
                    if line:find(pat) then return 'cpp' end
                end
            end
            return 'c'
        end,
    },
})

-- enable servers whose binary is on PATH; the binary comes from the config's cmd
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
