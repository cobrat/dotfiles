-- ~/.config/nvim-new/lsp/rust_analyzer.lua
---@type vim.lsp.Config
return {
    cmd = { "rust-analyzer" }, -- Command to start the server
    filetypes = { "rust" }, -- Supported filetypes
    root_markers = { "Cargo.toml", "rust-project.json", ".git" }, -- Project root detection
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true, -- Load all cargo features
                loadOutDirsFromCheck = true, -- Support for build.rs produced code
            },
            procMacro = {
                enable = true, -- Enable procedural macro support
            },
            checkOnSave = {
                command = "clippy", -- Use clippy instead of cargo check for better linting
            },
            diagnostics = {
                enable = true, -- Enable inline diagnostics
            },
        },
    },
}
