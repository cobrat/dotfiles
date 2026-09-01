# Neovim Keybinds Documentation

This document provides a simple and organized overview of all the custom keybinds defined in my Neovim configuration.

## Configuration Structure

| File                        | Responsibility                                   |
|-----------------------------|--------------------------------------------------|
| `lua/config/core.lua`       | Editor options and general keymaps               |
| `lua/config/theme.lua`      | Colorscheme and statusline highlight tints       |
| `lua/config/plugins.lua`    | Plugin installation and configuration            |
| `lua/config/lsp.lua`        | Diagnostics, LSP behavior, and language servers  |
| `lua/config/treesitter.lua` | Parsers, highlighting, and text objects          |
| `after/ftplugin/*.lua`      | Filetype-local overrides                         |

## General Keybinds

| Mode    | Key             | Action                                                                                   |
|---------|-----------------|------------------------------------------------------------------------------------------|
| `n`     | `<leader>e`     | Open an Oil file explorer buffer                                                         |
| `n`     | `J`             | Join lines while keeping the cursor in place                                             |
| `n`     | `<C-d>`         | Scroll half-page down and keep the cursor centered                                       |
| `n`     | `<C-u>`         | Scroll half-page up and keep the cursor centered                                         |
| `n`     | `n`             | Move to next search result and keep it centered                                          |
| `n`     | `N`             | Move to previous search result and keep it centered                                      |
| `n`     | `Q`             | Disable Ex mode                                                                          |
| `n`     | `<C-j>`         | Jump to next quickfix entry and keep it centered                                         |
| `n`     | `<C-k>`         | Jump to previous quickfix entry and keep it centered                                     |
| `n`     | `<leader>j`     | Jump to next location entry and keep it centered                                         |
| `n`     | `<leader>k`     | Jump to previous location entry and keep it centered                                     |
| `n`     | `<leader>cl`    | Close the quickfix window                                                                |
| `n`     | `<leader>co`    | Open the quickfix window                                                                 |
| `n`/`v` | `<leader>d`     | Delete into the black-hole register (no yank)                                            |
| `n`     | `<leader>y`     | Yank motion target into the system clipboard (even on SSH)                               |
| `n`     | `<leader>li`    | Open the LSP health report (checkhealth vim.lsp)                                         |
| `n`     | `<leader>mm`    | Run make in the current directory                                                        |
| `n`     | `<leader>u`     | Toggle Undotree                                                                          |
| `n`     | `]h` / `[h`     | Jump to next / previous git hunk (gitsigns buffers)                                      |
| `n`     | `<leader>hp`    | Preview the git hunk under the cursor                                                    |
| `n`     | `<leader>hb`    | Blame the current line (git author and date)                                             |

---

## Visual Mode Keybinds

| Mode | Key             | Action                                                                                      |
|------|-----------------|---------------------------------------------------------------------------------------------|
| `v`  | `J`             | Move selected block down                                                                    |
| `v`  | `K`             | Move selected block up                                                                      |
| `x`  | `<leader>p`     | Paste without overwriting clipboard                                                         |
| `v`  | `<leader>y`     | Yank into system clipboard (even on SSH)                                                    |

---

## Linting and Formatting

| Mode    | Key          | Action              |
|---------|--------------|---------------------|
| `n`/`x` | `<leader>cf` | Format code (`LSP`) |

---

## Telescope Keybinds

| Mode | Key             | Action                                                                                      |
|------|-----------------|---------------------------------------------------------------------------------------------|
| `n`  | `<leader>ff`    | Find files                                                                                  |
| `n`  | `<leader>fg`    | Prompt for text and grep the current working directory                                      |
| `n`  | `<leader>fo`    | Open recent files                                                                           |
| `n`  | `<leader>fq`    | Open quickfix list                                                                          |
| `n`  | `<leader>fh`    | Open help tags                                                                              |
| `n`  | `<leader>fm`    | Browse man pages                                                                            |
| `n`  | `<leader>fb`    | Open buffer list                                                                            |
| `n`  | `<leader>fs`    | Grep current string                                                                         |
| `n`  | `<leader>fc`    | Grep instances of the current file name without the extension                               |
| `n`  | `<leader>fi`    | Find files in the Neovim configuration directory                                            |

---

## Harpoon Integration

| Mode | Key             | Action                                                                                      |
|------|-----------------|---------------------------------------------------------------------------------------------|
| `n`  | `<leader>a`     | Toggle current file in Harpoon list (add or remove)                                         |
| `n`  | `<C-e>`         | Toggle Harpoon quick menu                                                                   |
| `n`  | `<leader>fl`    | Open Harpoon window with Telescope                                                          |
| `n`  | `<C-p>`         | Go to previous Harpoon mark                                                                 |
| `n`  | `<C-n>`         | Go to next Harpoon mark                                                                     |

---

## LSP Keybinds

| Mode      | Key        | Action                                                                                   |
|-----------|------------|------------------------------------------------------------------------------------------|
| `n`       | `K`        | Show hover information                                                                   |
| `n`       | `gd`       | Go to definition                                                                         |
| `n`       | `gD`       | Go to declaration                                                                        |
| `n`       | `gi`       | Go to implementation                                                                     |
| `n`       | `go`       | Go to type definition                                                                    |
| `n`       | `gr`       | Show references                                                                          |
| `n`       | `gs`       | Show signature help                                                                      |
| `n`       | `gl`       | Show diagnostics in a floating window                                                    |
| `n`       | `<F2>`     | Rename symbol                                                                            |
| `n`       | `<F4>`     | Show code actions                                                                        |

---

## Miscellaneous

| Mode | Key             | Action                                                                                      |
|------|-----------------|---------------------------------------------------------------------------------------------|
| `n`  | `<leader>th`    | Toggle sticky context header (treesitter-context)                                           |
| `n`  | `<leader>s`     | Replace all instances of the word under the cursor on the current line                      |

---

## Text Objects

| Mode    | Key           | Action                                                                                     |
|---------|---------------|--------------------------------------------------------------------------------------------|
| `x`/`o` | `af`          | Select around function                                                                     |
| `x`/`o` | `if`          | Select inside function                                                                     |

---

## LSP Servers

LSP configuration lives in `lua/config/lsp.lua` and uses Neovim's native
`vim.lsp.config()` interface. Server executables are installed and managed
outside Neovim; Mason is not used.

Configured servers: Lua, C/C++, JSON, YAML, Rust, Go, Python, and Bash (shell).

Server binaries are looked up on `PATH`; a server is enabled only if its
binary exists. The name list at the bottom of `lsp.lua` drives this, and
binaries are derived from each config's `cmd` (single source of truth).

## Tree-sitter

Parsers are auto-installed on startup (`treesitter.lua`) and cover every
LSP language above plus editing basics (bash/sh, yaml, markdown, json, vim,
query). Filetype fallback: `sh` uses the `bash` parser.
