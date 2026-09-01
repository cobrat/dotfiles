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
        local map    = function(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = buf }) end

        map('n', 'K', vim.lsp.buf.hover)
        map('n', 'gd', vim.lsp.buf.definition)
        map('n', 'gD', vim.lsp.buf.declaration)
        map('n', 'gi', vim.lsp.buf.implementation)
        map('n', 'go', vim.lsp.buf.type_definition)
        map('n', 'gr', vim.lsp.buf.references)
        map('n', 'gs', vim.lsp.buf.signature_help)
        map('n', 'gl', vim.diagnostic.open_float)
        map('n', '<F2>', vim.lsp.buf.rename)
        map({ 'n', 'x' }, '<leader>cf', function() vim.lsp.buf.format({ async = true }) end)
        map('n', '<F4>', vim.lsp.buf.code_action)

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

-- luals needs the big settings table; build it (and scan the runtime tree)
-- only when the binary exists, so startup skips the work otherwise
if vim.fn.executable('lua-language-server') == 1 then
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
    vim.lsp.enable('luals')
end

vim.lsp.config['cssls'] = {
    cmd = { 'vscode-css-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less' },
    root_markers = { 'package.json', '.git' },
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
}

vim.lsp.config['phpls'] = {
    cmd = { 'intelephense', '--stdio' },
    filetypes = { 'php' },
    root_markers = { 'composer.json', '.git' },
    settings = {
        intelephense = {
            files = {
                maxSize = 5000000, -- default 5MB
            },
        },
    },
}

vim.lsp.config['ts_ls'] = {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = {
        'javascript', 'javascriptreact',
        'typescript', 'typescriptreact',
    },
    root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
    settings = {
        completions = {
            completeFunctionCalls = true,
        },
    },
}

vim.lsp.config['zls'] = {
    cmd = { 'zls' },
    filetypes = { 'zig', 'zir' },
    root_markers = { 'zls.json', 'build.zig', '.git' },
    settings = {
        zls = {
            enable_build_on_save = true,
            build_on_save_step = "install",
            warn_style = false,
            enable_snippets = true,
        }
    }
}

vim.lsp.config['nil_ls'] = {
    cmd = { 'nil' },
    filetypes = { 'nix' },
    root_markers = { 'flake.nix', 'default.nix', '.git' },
    settings = {
        ['nil'] = {
            formatting = {
                command = { "alejandra" }
            }
        }
    }
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
    filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
    root_markers = { 'compile_commands.json', '.clangd', 'configure.ac', 'Makefile', '.git' },
    -- init_options = {
    --     fallbackFlags = { '-std=c23' }, -- Default to C23
    -- },
}

vim.lsp.config['c3lsp'] = {
    cmd = { 'c3-lsp' },
    filetypes = { 'c3' },
    root_markers = { 'project.json', '.git' },
}

vim.lsp.config['serve_d'] = {
    cmd = { 'serve-d' },
    filetypes = { 'd' },
    root_markers = { 'dub.sdl', 'dub.json', '.git' },
}

vim.lsp.config['jsonls'] = {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    root_markers = { 'package.json', '.git', 'config.jsonc' },
}

vim.lsp.config['hls'] = {
    cmd = { 'haskell-language-server-wrapper', '--lsp' },
    filetypes = { 'haskell', 'lhaskell' },
    root_markers = { 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml', '.git' },
    settings = {
        haskell = {
            formattingProvider = 'fourmolu',
            plugin = {
                semanticTokens = { globalOn = false }
            },
        },
    },
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

vim.lsp.config['templ'] = {
    cmd = { 'templ', 'lsp' },
    filetypes = { 'templ' },
    root_markers = { 'go.mod', '.git' },
}

vim.filetype.add({
    extension = {
        h = 'c',
        c3 = 'c3',
        d = 'd',
        templ = 'templ',
    },
})

-- Enable servers whose binary is on PATH; explicit list avoids the private
-- _configs table. Keep in sync with the configs above.
local servers = {
    cssls         = 'vscode-css-language-server',
    phpls         = 'intelephense',
    ts_ls         = 'typescript-language-server',
    zls           = 'zls',
    nil_ls        = 'nil',
    rust_analyzer = 'rust-analyzer',
    clangd        = 'clangd',
    c3lsp         = 'c3-lsp',
    serve_d       = 'serve-d',
    jsonls        = 'vscode-json-language-server',
    hls           = 'haskell-language-server-wrapper',
    gopls         = 'gopls',
    templ         = 'templ',
}

for name, bin in pairs(servers) do
    if vim.fn.executable(bin) == 1 then
        vim.lsp.enable(name)
    end
end
