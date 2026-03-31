# Neovim Cheatsheet

`<Leader>` = `<Space>`

---

## Navigation

### Cursor Movement (centered)
| Key | Action |
|-----|--------|
| `j` / `k` | Down / Up (always centered) |
| `{` / `}` | Paragraph backward / forward |
| `<C-d>` / `<C-u>` | Half-page down / up |
| `n` / `N` | Next / previous search match |
| `w` / `b` / `e` | Word forward / backward / end |
| `0` / `^` / `$` | Line start (col 0) / first char / end |
| `gg` / `G` | File start / end |
| `%` | Jump to matching bracket |
| `H` / `M` / `L` | Screen top / middle / bottom |

### Window Navigation (mini.basics)
| Key | Action |
|-----|--------|
| `<C-h/j/k/l>` | Move to window left/down/up/right |
| `<C-w>s` / `<C-w>v` | Split horizontal / vertical |
| `<C-w>q` | Close window |
| `<C-w>+` / `<C-w>-` | Resize height (submode: repeat `+`/`-`) |

### Marks & Jumps
| Key | Action |
|-----|--------|
| `ma` | Set mark `a` |
| `` `a `` | Jump to mark `a` (exact position) |
| `'a` | Jump to mark `a` (line) |
| `<C-o>` / `<C-i>` | Jump backward / forward in jumplist |

---

## Editing

### Basic (mini.basics)
| Key | Action |
|-----|--------|
| `<C-s>` | Save file |
| `go` / `gO` | Add empty line below / above |
| `gy` / `gY` | Yank to system clipboard |
| `gp` / `gP` | Paste from system clipboard |
| `[p` / `]p` | Paste above / below current line |
| `u` / `<C-r>` | Undo / Redo |
| `.` | Repeat last change |

### Insert Mode Navigation (mini.basics)
| Key | Action |
|-----|--------|
| `<M-h/j/k/l>` | Move cursor (insert/command mode) |

### Text Objects (mini.ai)
| Object | Around / Inside |
|--------|----------------|
| `w` | Word |
| `s` | Sentence |
| `p` | Paragraph |
| `(` `)` `b` | Parentheses |
| `[` `]` | Square brackets |
| `{` `}` | Curly braces |
| `<` `>` | Angle brackets |
| `"` `'` `` ` `` | Quotes |
| `t` | HTML/XML tag |
| `f` | Function call |
| `a` | Function argument |
| `F` | Function definition (tree-sitter) |
| `B` | Whole buffer |

Prefix with `a` (around) or `i` (inside). Use `n`/`l` suffix for next/last:
`vin(` = select inside next parentheses

### Surround (mini.surround)
| Key | Action |
|-----|--------|
| `sa{motion}{char}` | Add surround |
| `sd{char}` | Delete surround |
| `sr{old}{new}` | Replace surround |
| `sf{char}` | Find surround (right) |
| `sh{char}` | Find surround (left) |

#### Markdown links (buffer-local)
| Key | Action |
|-----|--------|
| `saiwL` | Add link around word |
| `sdL` | Delete link |
| `srLL` | Replace link URL |

### Operators (mini.operators)
| Key | Action |
|-----|--------|
| `gr{motion}` | Replace with register |
| `gm{motion}` | Duplicate |
| `gs{motion}` | Sort |
| `g={motion}` | Evaluate (Lua expression) |
| `(` / `)` | Swap argument left / right |

### Comment (mini.comment)
| Key | Action |
|-----|--------|
| `gc{motion}` | Toggle comment |
| `gcc` | Toggle comment on line |

### Split/Join (mini.splitjoin)
| Key | Action |
|-----|--------|
| `gS` | Toggle split / join arguments |

---

## Completion (mini.completion)

| Key | Action |
|-----|--------|
| `<Tab>` / `<S-Tab>` | Next / previous item in menu |
| `<C-n>` / `<C-p>` | Next / previous item |
| `<CR>` | Accept completion |
| `<C-e>` | Abort completion |
| `<C-space>` | Trigger completion manually |

### Snippets (mini.snippets)
| Key | Action |
|-----|--------|
| `<C-j>` | Expand snippet |
| `<C-l>` | Next tabstop |
| `<C-h>` | Previous tabstop |

---

## File Explorer (mini.files)

| Key | Action |
|-----|--------|
| `<Leader>ed` | Open explorer (cwd) |
| `<Leader>ef` | Open explorer at current file |
| `l` / `<CR>` | Enter directory / open file |
| `h` | Go up to parent directory |
| `<Esc>` | Close explorer |
| `=` | Sync changes (rename/delete/create) |
| `g?` | Show help |
| `'c` | Bookmark: config dir |
| `'p` | Bookmark: plugins dir |
| `'w` | Bookmark: working directory |

---

## Fuzzy Find (mini.pick) — `<Leader>f`

| Key | Action |
|-----|--------|
| `<Leader>ff` | Files |
| `<Leader>fg` | Live grep |
| `<Leader>fG` | Grep word under cursor |
| `<Leader>fb` | Buffers |
| `<Leader>fh` | Help tags |
| `<Leader>fH` | Highlight groups |
| `<Leader>fl` | Lines (all buffers) |
| `<Leader>fL` | Lines (current buffer) |
| `<Leader>fr` | Resume last picker |
| `<Leader>f/` | Search (`/`) history |
| `<Leader>f:` | Command (`:`) history |
| `<Leader>fd` | Diagnostics (workspace) |
| `<Leader>fD` | Diagnostics (buffer) |
| `<Leader>fR` | LSP references |
| `<Leader>fs` | LSP workspace symbols (live) |
| `<Leader>fS` | LSP document symbols |

#### Inside picker
| Key | Action |
|-----|--------|
| `<C-n>` / `<C-p>` | Next / previous item |
| `<CR>` | Confirm |
| `<Esc>` / `<C-c>` | Close |
| `<Tab>` | Mark item |
| `<C-l>` | Show info |

---

## Buffer — `<Leader>b`

| Key | Action |
|-----|--------|
| `<Leader>ba` | Alternate buffer (`b#`) |
| `<Leader>bd` | Delete buffer (keep window) |
| `<Leader>bD` | Delete buffer (force) |
| `<Leader>bw` | Wipeout buffer |
| `<Leader>bW` | Wipeout buffer (force) |
| `<Leader>bs` | New scratch buffer |
| `[b` / `]b` | Previous / next buffer (mini.bracketed) |

---

## Git — `<Leader>g`

| Key | Action |
|-----|--------|
| `<Leader>gc` | Commit |
| `<Leader>gC` | Commit amend |
| `<Leader>gd` | Diff (unstaged) |
| `<Leader>gD` | Diff current file |
| `<Leader>ga` | Diff staged |
| `<Leader>gA` | Diff staged current file |
| `<Leader>gl` | Log |
| `<Leader>gL` | Log current file |
| `<Leader>gs` | Show at cursor (mini.git) |
| `<Leader>go` | Toggle diff overlay (mini.diff) |
| `gh` / `gH` | Apply / reset hunk (mini.diff) |
| `[h` / `]h` | Previous / next hunk (mini.bracketed) |

#### Pick git (under `<Leader>f`)
| Key | Action |
|-----|--------|
| `<Leader>fc` | Commits (all) |
| `<Leader>fC` | Commits (current file) |
| `<Leader>fm` | Modified hunks (all) |
| `<Leader>fM` | Modified hunks (buffer) |
| `<Leader>fa` | Staged hunks (all) |
| `<Leader>fA` | Staged hunks (buffer) |

---

## LSP — `<Leader>l`

| Key | Action |
|-----|--------|
| `<Leader>la` | Code actions |
| `<Leader>ld` | Diagnostic popup |
| `<Leader>lf` | Format |
| `<Leader>lh` | Hover |
| `<Leader>li` | Implementation |
| `<Leader>lr` | Rename |
| `<Leader>lR` | References |
| `<Leader>ls` | Go to definition |
| `<Leader>lt` | Type definition |
| `[d` / `]d` | Previous / next diagnostic |

LSP setup notes:
- `plugin/40_plugins.lua`: installs `nvim-lspconfig`,
  `mason.nvim`, `mason-lspconfig.nvim`
- `Config.lsp_servers`: Mason-managed servers to install and enable
- `Config.treesitter_languages`: expected tree-sitter parsers
- `Config.root_dir_with_fallback()`: lets servers attach on single files
- `ensure_installed`: Mason-managed servers to auto-install
- `automatic_enable = false`: Mason only installs; enabling is explicit via
  `vim.lsp.enable(Config.lsp_servers)`
- `after/lsp/*.lua`: per-server diffs; base config is from `nvim-lspconfig`

LSP / Mason commands:
| Command | Action |
|-----|--------|
| `:Mason` | Open Mason UI |
| `:checkhealth vim.lsp` | Show enabled/active LSP status |
| `:lsp enable <name>` | Enable an LSP config manually |
| `:lsp disable <name>` | Disable an LSP config manually |
| `:lsp restart <name>` | Restart a running LSP client |

---

## Explore / Edit Config — `<Leader>e`

| Key | Action |
|-----|--------|
| `<Leader>ed` | File explorer (cwd) |
| `<Leader>ef` | File explorer (current file) |
| `<Leader>ei` | Edit `init.lua` |
| `<Leader>ek` | Edit keymaps config |
| `<Leader>em` | Edit mini config |
| `<Leader>en` | Show notification history |
| `<Leader>eo` | Edit options config |
| `<Leader>ep` | Edit plugins config |
| `<Leader>eq` | Toggle quickfix list |
| `<Leader>eQ` | Toggle location list |

---

## Other — `<Leader>o`

| Key | Action |
|-----|--------|
| `<Leader>or` | Resize window to default width |
| `<Leader>ot` | Trim trailing whitespace |
| `<Leader>oz` | Zoom window toggle |

---

## Brackets Navigation (mini.bracketed) — `[` / `]`

| Key | Action |
|-----|--------|
| `[b` / `]b` | Buffer |
| `[d` / `]d` | Diagnostic |
| `[f` / `]f` | File (on disk) |
| `[h` / `]h` | Git hunk |
| `[i` / `]i` | Indent change |
| `[j` / `]j` | Jump (jumplist) |
| `[l` / `]l` | Location list |
| `[q` / `]q` | Quickfix |
| `[t` / `]t` | Tree-sitter node |
| `[u` / `]u` | Undo history |
| `[x` / `]x` | Conflict marker |
| `[y` / `]y` | Yank history |
| `[p` / `]p` | Paste above / below |

---

## Jump (mini.jump)

Enhanced `fFtT` — works across lines, highlights matches.

| Key | Action |
|-----|--------|
| `f{char}` | Jump forward to char |
| `F{char}` | Jump backward to char |
| `t{char}` | Jump forward before char |
| `T{char}` | Jump backward before char |

Repeat with `;` / `,`.

---

## Toggles (mini.basics) — `\`

| Key | Action |
|-----|--------|
| `\b` | Background light/dark |
| `\c` | Cursor line |
| `\C` | Cursor column |
| `\d` | Diagnostics |
| `\h` | Search highlight |
| `\i` | Indent scope line |
| `\l` | List (show whitespace) |
| `\n` | Line numbers |
| `\r` | Relative numbers |
| `\s` | Spell check |
| `\w` | Wrap |

---

## Registers & Macros

| Key | Action |
|-----|--------|
| `"ay` | Yank into register `a` |
| `"ap` | Paste from register `a` |
| `"+y` | Yank to system clipboard |
| `"+p` | Paste from system clipboard |
| `q{a}` | Record macro into register `a` |
| `q` | Stop recording |
| `@{a}` | Play macro `a` |
| `@@` | Repeat last macro |

---

## z commands (mini.clue)

| Key | Action |
|-----|--------|
| `zz` | Center cursor |
| `zt` / `zb` | Cursor to top / bottom |
| `za` / `zo` / `zc` | Toggle / open / close fold |
| `zR` / `zM` | Open all / close all folds |
| `z=` | Spelling suggestions |
| `zg` / `zw` | Add word to / mark as bad |

---

## Markdown (buffer-local)

| Key | Action |
|-----|--------|
| `saiwL` | Wrap word in markdown link |
| `sdL` | Remove markdown link |
| `srLL` | Replace link URL |

---

## Command Line (mini.cmdline)

Autocomplete and history navigation available in `:` mode.

| Key | Action |
|-----|--------|
| `<Tab>` / `<S-Tab>` | Next / previous completion |
| `<C-n>` / `<C-p>` | History next / previous |
| `<C-r>{reg}` | Insert register content |
