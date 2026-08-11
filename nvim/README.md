# Neovim Keybinds Documentation

This document provides a simple and organized overview of all the custom keybinds defined in my Neovim configuration.

## Configuration Structure

| File | Responsibility |
|------|----------------|
| `lua/config/core.lua` | Editor options and general keymaps |
| `lua/config/plugins.lua` | Plugin installation and configuration |
| `lua/config/lsp.lua` | Diagnostics, LSP behavior, and language servers |
| `lua/config/treesitter.lua` | Parsers, highlighting, and text objects |
| `lua/config/editing.lua` | Documentation generation and quick formatting |
| `lua/config/ui.lua` | Sticky code context |
| `after/ftplugin/*.lua` | Filetype-local overrides |

## General Keybinds

| Mode | Key             | Action                                                                                      |
|------|-----------------|---------------------------------------------------------------------------------------------|
| `n`  | `<leader>e`     | Open an Oil file explorer buffer                                                            |
| `n`  | `J`             | Join lines while keeping the cursor in place                                                |
| `n`  | `<C-d>`         | Scroll half-page down and keep the cursor centered                                          |
| `n`  | `<C-u>`         | Scroll half-page up and keep the cursor centered                                            |
| `n`  | `n`             | Move to next search result and keep it centered                                             |
| `n`  | `N`             | Move to previous search result and keep it centered                                         |
| `n`  | `Q`             | Disable Ex mode                                                                             |
| `n`  | `<C-j>`         | Jump to next quickfix entry and keep it centered                                            |
| `n`  | `<C-k>`         | Jump to previous quickfix entry and keep it centered                                        |
| `n`  | `<leader>k`     | Jump to next location entry and keep it centered                                            |
| `n`  | `<leader>j`     | Jump to previous location entry and keep it centered                                        |
| `i`  | `<C-c>`         | Exit insert mode (acts like `Esc`)                                                          |
| `n`  | `<leader>x`     | Make current file executable (`chmod +x`)                                                   |
| `n`  | `<leader>u`     | Toggle Undotree                                                                             |
| `n`  | `<leader>rl`    | Reload the Neovim config (`~/.config/nvim/init.lua`)                                        |
| `n`  | `<leader><leader>` | Source the current file (`:so`)                                                          |

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

| Mode | Key             | Action                                                                                      |
|------|-----------------|---------------------------------------------------------------------------------------------|
| `n`  | `<leader>cc`    | Run `php-cs-fixer` to lint and format PHP files                                             |
| `n`  | `<F3>`          | Format code (`LSP`)                                                                         |

---

## Telescope Keybinds

| Mode | Key             | Action                                                                                      |
|------|-----------------|---------------------------------------------------------------------------------------------|
| `n`  | `<leader>ff`    | Find files                                                                                  |
| `n`  | `<leader>fg`    | Prompt for text and grep the current working directory                                      |
| `n`  | `<leader>fo`    | Open recent files                                                                           |
| `n`  | `<leader>fq`    | Open quickfix list                                                                          |
| `n`  | `<leader>fh`    | Open help tags                                                                              |
| `n`  | `<leader>fb`    | Open buffer list                                                                            |
| `n`  | `<leader>fs`    | Grep current string                                                                         |
| `n`  | `<leader>fc`    | Grep instances of the current file name without the extension                               |
| `n`  | `<leader>fi`    | Find files in Neovim configuration directory (`~/.config/nvim/`)                            |

---

## Harpoon Integration

| Mode | Key             | Action                                                                                      |
|------|-----------------|---------------------------------------------------------------------------------------------|
| `n`  | `<leader>a`     | Add current file to Harpoon list                                                            |
| `n`  | `<C-e>`         | Toggle Harpoon quick menu                                                                   |
| `n`  | `<leader>fl`    | Open Harpoon window with Telescope                                                          |
| `n`  | `<C-p>`         | Go to previous Harpoon mark                                                                 |
| `n`  | `<C-n>`         | Go to next Harpoon mark                                                                     |

---

## LSP Keybinds

| Mode      | Key        | Action                                                                                      |
|-----------|------------|---------------------------------------------------------------------------------------------|
| `n`       | `K`        | Show hover information                                                                      |
| `n`       | `gd`       | Go to definition                                                                            |
| `n`       | `gD`       | Go to declaration                                                                           |
| `n`       | `gi`       | Go to implementation                                                                        |
| `n`       | `go`       | Go to type definition                                                                       |
| `n`       | `gr`       | Show references                                                                             |
| `n`       | `gs`       | Show signature help                                                                         |
| `n`       | `gl`       | Show diagnostics in a floating window                                                       |
| `n`       | `<F2>`     | Rename symbol                                                                               |
| `n`, `x`  | `<F3>`     | Format code asynchronously                                                                 |
| `n`       | `<F4>`     | Show code actions                                                                           |

---

## Miscellaneous

| Mode | Key             | Action                                                                                      |
|------|-----------------|---------------------------------------------------------------------------------------------|
| `n`  | `<leader>dg`    | Generate a documentation comment for the current function                                   |
| `n`  | `<leader>s`     | Replace all instances of the word under the cursor on the current line                      |

---

# LSP Servers

LSP configuration lives in `lua/config/lsp.lua` and uses Neovim's native
`vim.lsp.config()` interface. Server executables are installed and managed
outside Neovim; Mason is not used.

Configured servers: Lua, CSS, PHP, TypeScript, Zig, Nix, Rust, C/C++, C3, D,
JSON, Haskell, Go, and Templ.
