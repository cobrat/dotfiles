-- ~/.config/nvim-new/lsp/pyright.lua
---@type vim.lsp.Config
return {
    cmd = { "pyright-langserver", "--stdio" }, -- Command to start the server
    filetypes = { "python" }, -- Supported filetypes
    root_markers = { -- Files used to detect project root
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
        ".git",
    },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true, -- Automatically search for modules in workspace
                useLibraryCodeForTypes = true, -- Use library code for type information
                diagnosticMode = "workspace", -- Analyze all files in the workspace
                typeCheckingMode = "basic", -- Basic type checking (can be "strict")
            },
        },
    },
}
