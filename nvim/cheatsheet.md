# Neovim Cheatsheet

Leader: `<Space>`

## Common Vim Keys

### Movement

| Key | Action |
| --- | --- |
| `h` | Move left |
| `j` | Move down by display line |
| `k` | Move up by display line |
| `l` | Move right |
| `w` | Move to next word |
| `b` | Move to previous word |
| `e` | Move to end of word |
| `0` | Move to line start |
| `^` | Move to first non-blank character |
| `$` | Move to line end |
| `gg` | Go to first line |
| `G` | Go to last line |
| `{` | Move to previous paragraph |
| `}` | Move to next paragraph |
| `%` | Jump to matching pair |
| `<C-d>` | Scroll half page down |
| `<C-u>` | Scroll half page up |

### Editing

| Key | Action |
| --- | --- |
| `i` | Insert before cursor |
| `a` | Insert after cursor |
| `I` | Insert at line start |
| `A` | Insert at line end |
| `o` | Open line below |
| `O` | Open line above |
| `x` | Delete character |
| `dd` | Delete line |
| `yy` | Yank line |
| `p` | Paste after cursor |
| `P` | Paste before cursor |
| `p` | Paste without yanking selection in visual mode |
| `u` | Undo |
| `<C-r>` | Redo |
| `.` | Repeat last change |
| `r` | Replace one character |
| `ciw` | Change inner word |
| `diw` | Delete inner word |
| `yiw` | Yank inner word |

### Visual Mode

| Key | Action |
| --- | --- |
| `v` | Start characterwise visual mode |
| `V` | Start linewise visual mode |
| `<C-v>` | Start blockwise visual mode |
| `>` | Indent selection and keep selection |
| `<` | Unindent selection and keep selection |
| `J` | Move selection down |
| `K` | Move selection up |
| `y` | Yank selection |
| `d` | Delete selection |

### Search

| Key | Action |
| --- | --- |
| `/` | Search forward |
| `?` | Search backward |
| `n` | Next search match |
| `N` | Previous search match |
| `*` | Search word under cursor forward |
| `#` | Search word under cursor backward |
| `<C-l>` | Clear search highlight |

### Windows and Tabs

| Key | Action |
| --- | --- |
| `<C-w>h` | Move to left split |
| `<C-w>j` | Move to lower split |
| `<C-w>k` | Move to upper split |
| `<C-w>l` | Move to right split |
| `<C-w>s` | Horizontal split |
| `<C-w>v` | Vertical split |
| `<C-w>q` | Close current window |
| `<C-w>=` | Equalize split sizes |
| `gt` | Next tab |
| `gT` | Previous tab |

### LSP

| Key | Action |
| --- | --- |
| `K` | Hover documentation |
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gra` | Code action |
| `gri` | Go to implementation |
| `grn` | Rename symbol |
| `grr` | Show references |
| `grt` | Go to type definition |
| `gO` | Document symbols |

## Custom Keys

### Files and Buffers

| Key | Action |
| --- | --- |
| `<Leader>e` | Edit directory with Oil |
| `<Leader>?` | Open cheatsheet |
| `<Leader>ff` | Find files with fzf-lua |
| `<Leader>fg` | Live grep with fzf-lua |
| `<Leader>fb` | Find buffers with fzf-lua |
| `<Leader>fd` | Git hunks in current file (fzf-lua) |
| `[b` | Previous buffer |
| `]b` | Next buffer |
| `<Leader><Leader>` | Alternate buffer |
| `<Leader>bd` | Delete current buffer |

### Oil (defaults)

| Key | Action |
| --- | --- |
| `g?` | Show help |
| `<CR>` | Open file or enter directory |
| `<C-s>` | Open in vertical split |
| `<C-h>` | Open in horizontal split |
| `<C-t>` | Open in new tab |
| `<C-p>` | Preview entry |
| `<C-c>` | Close Oil |
| `<C-l>` | Refresh |
| `-` | Go to parent directory |
| `_` | Open current working directory |
| `` ` `` | Change cwd to current Oil directory |
| `g~` | Change tab cwd to current Oil directory |
| `gs` | Change sort |
| `gx` | Open externally |
| `g.` | Toggle hidden files |
| `g\` | Toggle trash |

### Editing

| Key | Action |
| --- | --- |
| `<Leader>d` | Delete without yank |
| `<Leader>bf` | Format buffer or visual selection |
| `gcc` / `gc`… | Built-in comment toggle (`:help commenting`) |

### mini.surround (defaults)

Normal **`sa`** = surround **add**: **`sa`** + surrounding id + motion (e.g.
**`saiw)`** wraps inner word in `()`). **`sd`** delete, **`sr`** replace.

| Key | Action |
| --- | --- |
| `sa` + id + motion | Add surrounding around motion/textobject |
| `sd` + id | Delete surrounding |
| `sr` + old + new | Replace surrounding |
| `sf` / `sF` + id | Move to surrounding (right / left) |
| `sh` + id | Highlight surrounding briefly |

**Extended search:** insert **`n`** (next) or **`l`** (last) before id — e.g.
`sdnf`, `srlf(`.

**Visual:** `sa` + id around selection.

**Ids:** `)`, `(`, brackets, `t` tag, `f` function call, `?` prompt; see
`:help mini.surround`.

Plugin uses **`s…` maps**; use **`cl`** for built-in substitute (`s`).

### Completion

| Key | Action |
| --- | --- |
| `<Tab>` | Accept or select completion |
| `<S-Tab>` | Select previous completion |

### Git (gitsigns)

| Key | Action |
| --- | --- |
| `<Leader>gh` | Inline preview at cursor hunk |
| `<Leader>gn` | Next hunk (gitsigns) / next vimdiff change |
| `<Leader>gp` | Previous hunk / prev vimdiff change |
