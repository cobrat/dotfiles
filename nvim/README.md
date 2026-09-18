# Neovim Keybinds

A reference for the custom keybinds in this configuration. `leader` is mapped to `<Space>`.

## Contents

- [Configuration Structure](#configuration-structure)
- [Keybinds](#keybinds)
  - [Files and Editing](#files-and-editing)
  - [Movement and Scrolling](#movement-and-scrolling)
  - [Flash](#flash)
  - [Quickfix and Location List](#quickfix-and-location-list)
  - [Clipboard and Registers](#clipboard-and-registers)
  - [Git](#git)
  - [Visual Mode](#visual-mode)
  - [LSP](#lsp)
  - [Diagnostics](#diagnostics)
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

## Keybinds

### Files and Editing

| Mode    | Key         | Action                                        |
|---------|-------------|-----------------------------------------------|
| `n`     | `<leader>e` | Open an Oil file explorer buffer              |
| `n`     | `J`         | Join lines, keeping the cursor in place       |
| `n`     | `Q`         | Disable Ex mode                               |
| `n`/`v` | `<leader>d` | Delete into the black-hole register (no yank) |

### Movement and Scrolling

| Mode   | Key       | Action                                              |
|--------|-----------|-----------------------------------------------------|
| `n`    | `<C-d>`   | Scroll half-page down, keeping the cursor centered  |
| `n`    | `<C-u>`   | Scroll half-page up, keeping the cursor centered    |
| `n`    | `n`       | Next search result, keeping the cursor centered     |
| `n`    | `N`       | Previous search result, keeping the cursor centered |

### Flash

[flash.nvim](https://github.com/folke/flash.nvim) labels every match, so a
position is two or three keys away instead of a full search.

| Mode          | Key       | Action                                            |
|---------------|-----------|---------------------------------------------------|
| `n`/`x`/`o`   | `s`       | Jump to a labelled match (works across windows)   |
| `n`/`x`/`o`   | `S`       | Select a tree-sitter node by label                |
| `c`           | `<C-s>`   | Toggle labels while typing a `/` search           |

flash also owns `;` and `,` (next / previous match of the current jump),
which only act while a flash jump is active. `f`/`t` stay plain motions:
label mode is deliberately off (`modes.char.jump_labels`). Inside a
telescope results window, `s` (normal) and `<C-s>` (insert) jump a label.

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

Plain `y`/`p` use the system clipboard (`clipboard=unnamedplus`).

| Mode | Key         | Action                                                      |
|------|-------------|-------------------------------------------------------------|
| `v`  | `<leader>p` | Paste over selection without overwriting the clipboard      |

### Git

| Mode | Key         | Action                                       |
|------|-------------|----------------------------------------------|
| `n`  | `]h` / `[h` | Jump to next / previous git hunk (gitsigns)  |
| `n`  | `<leader>hp`| Preview the git hunk under the cursor        |
| `n`  | `<leader>hb`| Blame the current line (author and date)     |
| `n`  | `<leader>hs`| Stage the hunk under the cursor              |
| `n`  | `<leader>hr`| Reset the hunk under the cursor              |
| `n`  | `<leader>hu`| Undo the last staged hunk                    |
| `n`  | `<leader>hd`| Diff the current buffer against the index    |

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
| `n`  | `gs`         | Show signature help                    |
| `n`  | `<leader>cr` | Rename symbol                          |
| `n`  | `<leader>ca` | Show code actions                      |
| `n`  | `<leader>ti` | Toggle inlay hints (server-supported)  |

References use the native `grr` or `<leader>fr` (see Telescope). `gr` itself
is left unmapped so the native `grn`/`gra`/`grr`/`gri`/`grt` family answers
immediately instead of waiting out `timeoutlen`.

### Diagnostics

| Mode   | Key    | Action                                                            |
|--------|--------|-------------------------------------------------------------------|
| `n`    | `]d`   | Next diagnostic, keeping the cursor centered                      |
| `n`    | `[d`   | Previous diagnostic, keeping the cursor centered                  |
| `n`    | `gl`   | Show the diagnostic under the cursor in a float (needs a client)  |

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
| `n`  | `<leader>fd`| Browse symbols in the current file (LSP)           |
| `n`  | `<leader>fw`| Browse symbols in the workspace (LSP)              |
| `n`  | `<leader>fr`| Browse references to the symbol under the cursor   |
| `n`  | `<leader>fD`| Browse diagnostics                                 |

### Harpoon

| Mode | Key         | Action                                  |
|------|-------------|-----------------------------------------|
| `n`  | `<leader>a` | Add the current file to the Harpoon list|
| `n`  | `<C-e>`     | Toggle the Harpoon quick menu           |
| `n`  | `<C-n>`     | Go to the next Harpoon mark             |
| `n`  | `<C-p>`     | Go to the previous Harpoon mark         |

### Miscellaneous

| Mode | Key         | Action                                                        |
|------|-------------|---------------------------------------------------------------|
| `n`  | `<leader>s` | Replace all instances of the word under the cursor on the line|
| `n`  | `<leader>u` | Browse undo history with a diff preview (telescope-undo)      |
| `n`  | `<leader>th`| Toggle the sticky context header (treesitter-context)         |

`<leader>s` is a leaf mapping, not a prefix: nothing is mapped under
`<leader>s*`, so no key below it has to wait out `timeoutlen`.

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
