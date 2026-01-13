-- ~/.config/nvim-new/lsp/clangd.lua
---@type vim.lsp.Config
return {
    cmd = {
        "clangd",
        "--background-index", -- Index project code in the background
        "--clang-tidy", -- Enable clang-tidy diagnostics
        "--header-insertion=iwyu", -- Suggest and insert missing headers
        "--completion-style=detailed", -- Show more info in completion menu
        "--function-arg-placeholders", -- Add placeholders for function arguments
        "--fallback-style=llvm", -- Use LLVM style if no .clang-format is found
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" }, -- Supported filetypes
    root_markers = { -- Files used to detect project root
        "compile_commands.json",
        "compile_flags.txt",
        ".git",
    },
}
