# Neovim Cheatsheet

`<Leader>` = `<Space>`. Sections: **Built-in** (vanilla Neovim), **Custom**
(from `lua/config/keymaps.lua`), **mini.nvim** (enabled modules).

---

## Motion

| Key | Action |
|-----|--------|
| `h` / `j` / `k` / `l` | Left / Down / Up / Right |
| `w` / `b` / `e` | Word forward / back / end |
| `0` / `^` / `$` | Line start / first non-blank / end |
| `{` / `}` | Paragraph back / forward |
| `gg` / `G` | File start / end |
| `H` / `M` / `L` | Screen top / middle / bottom |
| `<C-d>` / `<C-u>` | Half-page down / up |
| `<C-f>` / `<C-b>` | Full page down / up |
| `%` | Match bracket |
| `f{c}` / `F{c}` | Jump to char forward / back (line-local) |
| `t{c}` / `T{c}` | Jump before char forward / back |
| `;` / `,` | Repeat last `f/F/t/T` / reverse |
| `n` / `N` | Next / previous search match |
| `*` / `#` | Search word under cursor forward / back |
| `<C-o>` / `<C-i>` | Jumplist back / forward |
| `<C-l>` | Clear search highlight (and redraw) |

---

## Edit

| Key | Action |
|-----|--------|
| `i` / `a` / `I` / `A` | Insert before / after / line-start / line-end |
| `o` / `O` | Open line below / above |
| `r{c}` / `R` | Replace char / enter replace mode |
| `x` / `X` | Delete char forward / back |
| `dd` / `yy` / `cc` | Delete / yank / change line |
| `D` / `Y` / `C` | Same, from cursor to EOL |
| `p` / `P` | Paste after / before |
| `u` / `<C-r>` | Undo / redo |
| `.` | Repeat last change |
| `<` / `>` (visual) | Outdent / indent |
| `~` | Toggle case |

### Text objects (pair with `d` / `c` / `y` / `v`)

| Key | Object |
|-----|--------|
| `iw` / `aw` | Inside / around word |
| `is` / `as` | Sentence |
| `ip` / `ap` | Paragraph |
| `i"` / `a"` | Inside / around quotes (also `'`, `` ` ``) |
| `i(` / `a(` | Parens (also `{`, `[`, `<`) |
| `it` / `at` | HTML/XML tag |

---

## Visual mode

| Key | Action |
|-----|--------|
| `v` / `V` / `<C-v>` | Char / line / block visual |
| `gv` | Re-select last selection |
| `o` | Move to other end of selection |

---

## Window & Buffer

| Key | Action |
|-----|--------|
| `<C-w>s` / `<C-w>v` | Split horizontal / vertical |
| `<C-w>h/j/k/l` | Move to window left/down/up/right |
| `<C-w>q` | Close window |
| `<C-w>+` / `<C-w>-` | Resize height |
| `<C-w>>` / `<C-w><` | Resize width |
| `<C-^>` | Alternate buffer |
| `:b {name}` | Switch to buffer by name (Tab completes) |

---

## Folds (indent-based, see `options.lua`)

| Key | Action |
|-----|--------|
| `za` / `zo` / `zc` | Toggle / open / close |
| `zR` / `zM` | Open all / close all |

---

## Registers & Macros

| Key | Action |
|-----|--------|
| `"ay` / `"ap` | Yank / paste register `a` |
| `"+y` / `"+p` | System clipboard |
| `q{a}` … `q` | Record macro `a`, then stop |
| `@{a}` / `@@` | Play macro / repeat last |

---

## Custom — normal/visual

| Key | Action |
|-----|--------|
| `K` | Diagnostic float on diagnostic line, else LSP hover |

### Insert

| Key | Action |
|-----|--------|
| `<Tab>` / `<S-Tab>` | Next / previous completion item (when popup open) |
| `<C-y>` | Accept completion |
| `<C-e>` | Cancel completion |

---

## Custom `<Leader>`

Leader = `<Space>`. Categories: `b` buffer, `e` explore, `f` find,
`g` git, `l` language.

### Buffer — `<Leader>b`

| Key | Action |
|-----|--------|
| `<Leader>bd` | Delete buffer (keep window) |
| `<Leader>bw` | Wipeout buffer |

### Explore — `<Leader>e`

| Key | Action |
|-----|--------|
| `<Leader>ee` | File explorer at cwd (mini.files) |
| `<Leader>ef` | File explorer at current file |
| `<Leader>em` | Show `:messages` history |
| `<Leader>eq` | Toggle quickfix list |
| `<Leader>el` | Toggle location list |

### Find — `<Leader>f` (mini.pick)

| Key | Action |
|-----|--------|
| `<Leader>ff` | Files |
| `<Leader>fg` | Live grep (needs `ripgrep`) |
| `<Leader>fb` | Buffers |
| `<Leader>fh` | Help tags |
| `<Leader>fr` | Resume last picker |

More pickers: `:Pick <Tab>` (git_commits, git_hunks, diagnostic, …).

### Git — `<Leader>g`

| Key | Action |
|-----|--------|
| `<Leader>go` | Toggle diff overlay (mini.diff) |
| `<Leader>gs` | Show at cursor (mini.git) — n, x |

Direct commands: `:Git <subcmd>` for commit, diff, log, etc.

### Language — `<Leader>l`

| Key | Action |
|-----|--------|
| `<Leader>la` | Code action — n, x |
| `<Leader>ld` | Go to definition |
| `<Leader>lf` | Format (conform.nvim) — n, x |
| `<Leader>li` | Go to implementation |
| `<Leader>lr` | Rename symbol |
| `<Leader>lt` | Type definition |

`K` still shows diagnostic details on a flagged line, or hover otherwise.
Native LSP defaults also still work: `gra` code action, `grn` rename,
`grr` references, `gri` implementation.

---

## mini.nvim

### mini.files — `<Leader>ee` / `<Leader>ef`

| Key | Action |
|-----|--------|
| `l` / `L` | Enter directory / open file |
| `h` | Up one directory |
| `q` | Close |
| `=` | Sync pending edits (rename, delete, create) |
| `g?` | Help |
| `'p` | Bookmark: plugins dir |
| `'w` | Bookmark: working directory |

### mini.pick (inside picker)

| Key | Action |
|-----|--------|
| `<C-n>` / `<C-p>` | Next / prev |
| `<CR>` | Confirm |
| `<Esc>` / `<C-c>` | Close |
| `<Tab>` | Mark item |
| `<C-l>` | Show info |

### mini.surround

| Key | Action |
|-----|--------|
| `sa{motion}{char}` | Add surround |
| `sd{char}` | Delete surround |
| `sr{old}{new}` | Replace surround |
| `sf{char}` / `sh{char}` | Find surround right / left |

### mini.operators

| Key | Action |
|-----|--------|
| `gr{motion}` | Replace with register |
| `gm{motion}` | Duplicate |
| `gs{motion}` | Sort |
| `g={motion}` | Evaluate (Lua) |

### mini.diff

| Key | Action |
|-----|--------|
| `gh` / `gH` | Apply / reset hunk |
| `<Leader>go` | Toggle overlay |

Signs in gutter: `+` add, `~` change, `-` delete.

### mini.hipatterns

Highlights `TODO`, `FIXME`, `HACK`, `NOTE`, and hex colors (`#rrggbb`).

---

## LSP commands (ex-mode)

| Command | Action |
|-----|--------|
| `:Mason` | Open Mason UI |
| `:checkhealth vim.lsp` | LSP status |
| `:lsp enable <name>` | Enable an LSP config |
| `:lsp disable <name>` | Disable an LSP config |
| `:lsp restart <name>` | Restart a running client |

Per-server configs live in `lsp/*.lua`.

---

## Diagnostics

Configured in `lua/config/options.lua`:

- No gutter signs, no virtual lines.
- `●`-style end-of-line marker for WARN+.
- Underline on all severities.
- Not updated while in insert mode.
- Press `K` on a flagged line to view the full message.

---

## Command line

| Key | Action |
|-----|--------|
| `<Tab>` / `<S-Tab>` | Next / prev completion (fuzzy, pum) |
| `<C-n>` / `<C-p>` | History next / prev |
| `<C-r>{reg}` | Insert register contents |
