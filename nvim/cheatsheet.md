# Neovim Cheatsheet

Leader: `<Space>`

## Common Vim Keys

### Movement

| Key | Action |
| --- | --- |
| `h` | Move left |
| `j` | Move down |
| `k` | Move up |
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

### LSP Defaults

| Key | Action |
| --- | --- |
| `K` | Hover documentation |
| `<C-]>` | Go to definition |
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

### Editing

| Key | Action |
| --- | --- |
| `<Leader>d` | Delete without yank |

### Splits

| Key | Action |
| --- | --- |
| `<C-h>` | Move to left split |
| `<C-j>` | Move to lower split |
| `<C-k>` | Move to upper split |
| `<C-l>` | Move to right split |
| `<Leader>sv` | Vertical split |
| `<Leader>sh` | Horizontal split |
