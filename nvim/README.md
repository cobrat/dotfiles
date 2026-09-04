# Neovim Keybinds

A reference for the custom keybinds in this configuration. `leader` is mapped to `<Space>`.

## Contents

- [Configuration Structure](#configuration-structure)
- [Keybinds](#keybinds)
  - [Files and Editing](#files-and-editing)
  - [Movement and Scrolling](#movement-and-scrolling)
  - [Quickfix and Location List](#quickfix-and-location-list)
  - [Clipboard and Registers](#clipboard-and-registers)
  - [Git](#git)
  - [Visual Mode](#visual-mode)
  - [LSP](#lsp)
  - [Formatting](#formatting)
  - [Telescope](#telescope)
  - [Harpoon](#harpoon)
  - [Miscellaneous](#miscellaneous)
  - [Text Objects](#text-objects)
- [LSP Servers](#lsp-servers)
- [Tree-sitter](#tree-sitter)

## Configuration Structure

| File                        | Responsibility                                   |
|-----------------------------|--------------------------------------------------|
| `lua/config/core.lua`       | Editor options and general keymaps               |
| `lua/config/theme.lua`      | Colorscheme and statusline highlight tints       |
| `lua/config/plugins.lua`    | Plugin installation and configuration            |
| `lua/config/lsp.lua`        | Diagnostics, LSP behavior, and language servers  |
| `lua/config/treesitter.lua` | Parsers, highlighting, and text objects          |
| `after/ftplugin/*.lua`      | Filetype-local overrides                         |

## Keybinds

### Files and Editing

| Mode    | Key         | Action                                        |
|---------|-------------|-----------------------------------------------|
| `n`     | `<leader>e` | Open an Oil file explorer buffer              |
| `n`     | `J`         | Join lines, keeping the cursor in place       |
| `n`     | `Q`         | Disable Ex mode                               |
| `n`/`v` | `<leader>d` | Delete into the black-hole register (no yank) |
| `n`     | `]h` / `[h` | Jump to next / previous git hunk              |

### Movement and Scrolling

| Mode | Key     | Action                                            |
|------|---------|---------------------------------------------------|
| `n`  | `<C-d>` | Scroll half-page down, keeping the cursor centered |
| `n`  | `<C-u>` | Scroll half-page up, keeping the cursor centered   |
| `n`  | `n`     | Next search result, keeping the cursor centered    |
| `n`  | `N`     | Previous search result, keeping the cursor centered |

### Quickfix and Location List

| Mode | Key         | Action                                       |
|------|-------------|----------------------------------------------|
| `n`  | `<C-j>`     | Next quickfix entry, keeping it centered     |
| `n`  | `<C-k>`     | Previous quickfix entry, keeping it centered |
| `n`  | `<leader>j` | Next location entry, keeping it centered     |
| `n`  | `<leader>k` | Previous location entry, keeping it centered |
| `n`  | `<leader>co`| Open the quickfix window                     |
| `n`  | `<leader>cl`| Close the quickfix window                    |

### Clipboard and Registers

| Mode | Key         | Action                                                      |
|------|-------------|-------------------------------------------------------------|
| `n`  | `<leader>y` | Yank motion target into the system clipboard (even on SSH)  |
| `v`  | `<leader>y` | Yank selection into the system clipboard (even on SSH)      |
| `x`  | `<leader>p` | Paste over selection without overwriting the clipboard      |

### Git

| Mode | Key         | Action                                       |
|------|-------------|----------------------------------------------|
| `n`  | `]h` / `[h` | Jump to next / previous git hunk (gitsigns)  |
| `n`  | `<leader>hp`| Preview the git hunk under the cursor        |
| `n`  | `<leader>hb`| Blame the current line (author and date)     |

### Visual Mode

| Mode | Key | Action                 |
|------|-----|------------------------|
| `v`  | `J` | Move selection down    |
| `v`  | `K` | Move selection up      |

### LSP

Buffer-local mappings, active when an LSP server is attached.

| Mode | Key          | Action                                 |
|------|--------------|----------------------------------------|
| `n`  | `K`          | Show hover information                 |
| `n`  | `gd`         | Go to definition                       |
| `n`  | `gD`         | Go to declaration                      |
| `n`  | `gi`         | Go to implementation                   |
| `n`  | `go`         | Go to type definition                  |
| `n`  | `gr`         | Show references                        |
| `n`  | `gs`         | Show signature help                    |
| `n`  | `gl`         | Show diagnostics in a floating window  |
| `n`  | `<leader>cr` | Rename symbol                          |
| `n`  | `<leader>ca` | Show code actions                      |

### Formatting

| Mode    | Key          | Action         |
|---------|--------------|----------------|
| `n`/`x` | `<leader>cf` | Format (LSP)   |

### Telescope

| Mode | Key         | Action                                             |
|------|-------------|----------------------------------------------------|
| `n`  | `<leader>ff`| Find files                                         |
| `n`  | `<leader>fo`| Open recent files                                  |
| `n`  | `<leader>fb`| Open buffer list                                   |
| `n`  | `<leader>fg`| Prompt for text and grep the working directory     |
| `n`  | `<leader>fs`| Grep the word under the cursor                     |
| `n`  | `<leader>fc`| Grep the current file name (without extension)     |
| `n`  | `<leader>fq`| Open the quickfix list                             |
| `n`  | `<leader>fh`| Open help tags                                     |
| `n`  | `<leader>fm`| Browse man pages                                   |
| `n`  | `<leader>fi`| Find files in the Neovim config directory          |

### Harpoon

| Mode | Key         | Action                                  |
|------|-------------|-----------------------------------------|
| `n`  | `<leader>a` | Add the current file to the Harpoon list|
| `n`  | `<C-e>`     | Toggle the Harpoon quick menu           |
| `n`  | `<C-n>`     | Go to the next Harpoon mark             |
| `n`  | `<C-p>`     | Go to the previous Harpoon mark         |
| `n`  | `<leader>fl`| Open the Harpoon window with Telescope  |

### Miscellaneous

| Mode | Key         | Action                                                        |
|------|-------------|---------------------------------------------------------------|
| `n`  | `<leader>s` | Replace all instances of the word under the cursor on the line|
| `n`  | `<leader>u` | Toggle Undotree                                               |
| `n`  | `<leader>th`| Toggle the sticky context header (treesitter-context)         |

### Text Objects

| Mode    | Key | Action                |
|---------|-----|-----------------------|
| `x`/`o` | `af`| Select around function|
| `x`/`o` | `if`| Select inside function|

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
