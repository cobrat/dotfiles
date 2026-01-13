-- ~/.config/nvim-new/lsp/bash_ls.lua
---@type vim.lsp.Config
return {
    cmd = { 'bash-language-server', 'start' }, -- Command and arguments to start the server
    filetypes = { 'bash', 'sh' }, -- Supported filetypes
    root_markers = { -- Files used to detect the project root
        '.git',
        '.bashrc',
        '.zshrc',
    },
    settings = {
        bash = {
            -- Add specific bash settings here if needed
        },
    },
}
