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
- [Python、C 和 C++ 开发](#pythonc-和-c-开发)
- [Tree-sitter](#tree-sitter)
- [Markdown](#markdown)

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

C/C++ is formatted by clangd through clang-format, whose style comes from the
dotfiles' `.clang-format` (linked to `~/.clang-format`): clangd exposes no
style setting, and `--fallback-style` accepts predefined names only.
Python 使用 Ruff 格式化。按 `<Space>cf` 手动格式化。

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
| `n`  | `<leader>tm`| Toggle Markdown rendering                                    |

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

## Python、C 和 C++ 开发

使用现有原生补全菜单：`<C-n>` / `<C-p>` 选择候选项，`<C-y>` 确认。
`gd` 跳转到定义，`K` 显示文档，`<Space>cr` 重命名，`<Space>ca` 显示代码操作。
用 `:checkhealth vim.lsp` 检查语言服务状态。

### macOS 工具

以下工具只需安装一次，Neovim 启动时不会运行安装命令：

```sh
# 尚未安装 Apple 命令行工具时执行：
xcode-select --install

brew install uv cmake ninja
uv tool install pyright
uv tool install ruff
```

确保 `~/.local/bin` 在 `PATH` 中。Apple 命令行工具提供 `clang`、`clang++`
和 `clangd`。C/C++ 使用 clangd 内置的格式化功能，无需单独安装 `clang-format`。

### Python

Pyright 提供补全、跳转和基本类型检查。Ruff 提供 lint 诊断、格式化、导入整理
和修复操作。可在项目的 `pyproject.toml`、`pyrightconfig.json` 或 `ruff.toml`
中调整相应工具的设置。

创建虚拟环境，并安装项目依赖：

```sh
uv venv
# 使用 uv 管理、含 pyproject.toml 的项目：
uv sync
# 或安装 requirements.txt 中的依赖：
uv pip install -r requirements.txt
nvim main.py
```

Pyright 按以下顺序选择解释器：显式设置的 `python.pythonPath`，已激活的
`VIRTUAL_ENV` 或 `CONDA_PREFIX`，项目根目录的 `.venv/bin/python` 或
`venv/bin/python`。否则由 Pyright 从 `PATH` 选择解释器。切换环境后重启
Neovim。用 `:terminal uv run python main.py` 运行代码；也可先激活环境，再用
`:terminal python main.py` 运行。

### C 和 C++

clangd 提供补全、跳转、诊断、clang-tidy 检查和格式化。为使 clangd 获得正确的
头文件路径、宏定义和语言标准，项目应提供 `compile_commands.json`。
CMake 项目可以这样配置：

```sh
cmake -S . -B build -G Ninja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
cmake --build build
ln -s build/compile_commands.json compile_commands.json
nvim src/main.cpp
```

仅在根目录没有编译数据库时创建该链接。也可在项目的 `.clangd` 中指定目录：

```yaml
CompileFlags:
  CompilationDatabase: build
```

Make 项目可用 Bear 等工具生成编译数据库。单文件可用
`:terminal clang -Wall -Wextra -g main.c -o /tmp/main` 或
`:terminal clang++ -std=c++20 -Wall -Wextra -g main.cpp -o /tmp/main` 编译，
再用 `:terminal /tmp/main` 运行。

项目可在 `.clang-format` 中设置格式化规则。配置也会用 CMake 和 Meson 文件
识别项目根目录。`.h` 文件沿用现有的内容识别规则，选择 C 或 C++；需要时用
`:setfiletype cpp` 指定为 C++。

参考：[Ruff 编辑器配置](https://docs.astral.sh/ruff/editors/setup/)、
[Pyright 设置](https://github.com/microsoft/pyright/blob/main/docs/settings.md)、
[clangd 配置](https://clangd.llvm.org/installation)。

## Tree-sitter

Parsers are auto-installed on startup (`treesitter.lua`) and cover every
LSP language above plus editing basics (bash/sh, yaml, markdown, json, vim,
query). Filetype fallback: `sh` uses the `bash` parser.

## Markdown

`render-markdown.nvim` renders Markdown by default in all modes, including
the cursor line. Headings use `H1` through `H6` with three theme colors;
only level 1 has a full-width background. Code blocks fit their content with
one space of padding on each side and show language names without icons.
Tables use thin, rounded borders. Quotes use a muted vertical line, and
callouts use text labels such as `[NOTE]` with semantic colors. Links keep
source syntax. Markdown colors follow the active colorscheme.

Use `<leader>tm` (Space, t, m) or `:RenderMarkdown toggle` to switch between
rendered Markdown and source text.
