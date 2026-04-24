# Helix Cheatsheet

Target version: Helix 25.07.1.

This file focuses on default Helix bindings. The current config does not add
custom keymaps.

---

## Core Idea

Helix is selection-first:

1. Move or select text.
2. Run an action on the selection.

Examples:

| Goal | Keys |
|---|---|
| Delete the next word | `w d` |
| Change the current word | `miw c` |
| Delete a full line | `x d` |
| Format the whole file | `% =` |

Key notation:

| Notation | Meaning |
|---|---|
| `Ctrl-x` | Hold Control and press `x` |
| `Alt-x` | Hold Alt or Option and press `x` |
| `Space f` | Press Space, then press `f` |
| `{char}` | Any character, for example `f,` |

---

## Essential Keys

| Key | Action |
|---|---|
| `Esc` | Return to normal mode |
| `i` / `a` | Insert before / after selection |
| `:` | Command prompt |
| `u` / `U` | Undo / redo |
| `Space f` | File picker |
| `Space /` | Global search |
| `Space ?` | Command palette |
| `;` | Collapse selection to cursor |
| `x` | Select current line |
| `%` | Select whole file |

---

## Modes

| Mode | Enter | Exit | Purpose |
|---|---|---|---|
| Normal | default | - | Move, select, edit |
| Insert | `i`, `a`, `I`, `A`, `o`, `O` | `Esc` | Type text |
| Select | `v` | `Esc` or `v` | Extend selections |
| Command | `:` | `Esc` | Run commands |

Minor modes open key menus:

| Key | Mode |
|---|---|
| `g` | Goto |
| `m` | Match and textobject |
| `z` | View |
| `Space` | Space menu |
| `Ctrl-w` | Window menu |

---

## Movement

### Basic Motions

| Key | Action |
|---|---|
| `h` / `j` / `k` / `l` | Left / down / up / right |
| `w` / `b` / `e` | Next word / previous word / word end |
| `W` / `B` / `E` | WORD versions, split only by whitespace |
| `f{char}` / `F{char}` | Find next / previous character |
| `t{char}` / `T{char}` | Till next / previous character |
| `Alt-.` | Repeat the last find or till motion |
| `Ctrl-d` / `Ctrl-u` | Half page down / up |
| `Ctrl-f` / `Ctrl-b` | Page down / up |

Unlike Vim, `f`, `F`, `t`, and `T` are not line-local in Helix.

### Goto Mode

Press `g`, then:

| Key | Action |
|---|---|
| `g` | Go to file start |
| `e` | Go to file end |
| `{number}G` | Go to line number |
| `h` / `l` | Line start / line end |
| `s` | First non-whitespace character |
| `t` / `c` / `b` | Window top / center / bottom |
| `j` / `k` | Move by real text line |
| `f` | Open file path or URL under selection |
| `a` | Go to last accessed file |
| `m` | Go to last modified file |
| `n` / `p` | Next / previous buffer |
| `.` | Go to last modification in current file |
| `w` | Jump with two-character labels |

### Jumplist

| Key | Action |
|---|---|
| `Ctrl-s` | Save current position |
| `Ctrl-o` | Jump backward |
| `Ctrl-i` | Jump forward |
| `Space j` | Open jumplist picker |

---

## Selection

| Key | Action |
|---|---|
| `v` | Enter select mode |
| `x` | Select current line |
| `X` | Extend selection to full line bounds |
| `Alt-x` | Shrink line selection to line bounds |
| `%` | Select whole file |
| `;` | Collapse selections to cursors |
| `Alt-;` | Flip cursor and anchor |
| `Alt-:` | Ensure selections face forward |
| `,` | Keep only primary selection |
| `Alt-,` | Remove primary selection |
| `(` / `)` | Rotate primary selection backward / forward |
| `Alt-(` / `Alt-)` | Rotate selection contents |

---

## Editing

### Insert

| Key | Action |
|---|---|
| `i` | Insert before selection |
| `a` | Append after selection |
| `I` | Insert at line start |
| `A` | Append at line end |
| `o` | Open line below |
| `O` | Open line above |

### Change Text

| Key | Action |
|---|---|
| `d` | Delete selection |
| `Alt-d` | Delete without yanking |
| `c` | Change selection |
| `Alt-c` | Change without yanking |
| `y` | Yank selection |
| `p` / `P` | Paste after / before |
| `R` | Replace selection with yanked text |
| `r{char}` | Replace selected characters |
| `J` | Join selected lines |
| `Alt-J` | Join and select inserted spaces |
| `>` / `<` | Indent / unindent |
| `=` | Format selection |
| `~` | Toggle case |
| `` ` `` | Lowercase |
| `Alt-\`` | Uppercase |
| `Ctrl-a` / `Ctrl-x` | Increment / decrement number |
| `.` | Repeat last insert change |

---

## Clipboard And Registers

The current config sets:

```toml
default-yank-register = "+"
```

That makes normal yank and paste use the system clipboard by default.

| Key | Action |
|---|---|
| `y` | Yank to default register |
| `p` / `P` | Paste after / before |
| `Space y` | Yank to system clipboard |
| `Space p` / `Space P` | Paste from system clipboard |
| `Space R` | Replace with system clipboard |
| `"{reg}` | Select register |

Examples:

| Goal | Keys |
|---|---|
| Yank to register `a` | `"a y` |
| Paste from register `a` | `"a p` |

---

## Text Objects And Surround

Press `m` for match mode.

| Key | Action |
|---|---|
| `mm` | Jump to matching bracket |
| `miw` / `maw` | Inside / around word |
| `miW` / `maW` | Inside / around WORD |
| `mip` / `map` | Inside / around paragraph |
| `mi(` / `ma(` | Inside / around parentheses |
| `mi[` / `ma[` | Inside / around brackets |
| `mi{` / `ma{` | Inside / around braces |
| `mi"` / `ma"` | Inside / around quotes |
| `ms{char}` | Add surround |
| `md{char}` | Delete surround |
| `mr{old}{new}` | Replace surround |

Tree-sitter text objects, when available:

| Key | Action |
|---|---|
| `mif` / `maf` | Inside / around function |
| `mit` / `mat` | Inside / around type or class |
| `mia` / `maa` | Inside / around argument |
| `mic` / `mac` | Inside / around comment |

---

## Search

| Key | Action |
|---|---|
| `/` | Search forward |
| `?` | Search backward |
| `n` / `N` | Next / previous match |
| `*` | Search current selection as a word |
| `Alt-*` | Search current selection literally |
| `s` | Select regex matches inside selection |
| `S` | Split selections by regex |

Common replace flow:

| Goal | Keys |
|---|---|
| Replace in whole file | `% s pattern Enter c replacement Esc` |
| Replace in current line | `x s pattern Enter c replacement Esc` |

---

## Multiple Cursors

| Key | Action |
|---|---|
| `C` | Copy selection to next suitable line |
| `Alt-C` | Copy selection to previous suitable line |
| `s` | Select regex matches inside selection |
| `S` | Split selection by regex |
| `Alt-s` | Split selection into lines |
| `&` | Align selections |
| `,` | Keep only primary selection |

Example:

| Goal | Keys |
|---|---|
| Edit all repeated words on a line | `x s word Enter c new Esc` |
| Align columns | Select lines, `Alt-s`, move to column, `&` |

---

## File And Picker

| Key | Action |
|---|---|
| `Space f` | File picker |
| `Space F` | File picker at current working directory |
| `Space b` | Buffer picker |
| `Space j` | Jumplist picker |
| `Space '` | Last picker |
| `Space /` | Global search |
| `Space s` | Document symbols |
| `Space S` | Workspace symbols |
| `Space d` | Document diagnostics |
| `Space D` | Workspace diagnostics |
| `Space g` | Changed files picker |

Inside pickers:

| Key | Action |
|---|---|
| `Enter` | Open selected item |
| `Esc` | Close picker |
| `Ctrl-s` | Open in horizontal split |
| `Ctrl-v` | Open in vertical split |
| `Tab` | Toggle selection when supported |

---

## Buffers And Windows

### Buffers

| Key | Action |
|---|---|
| `gn` / `gp` | Next / previous buffer |
| `Space b` | Buffer picker |
| `:buffer-close` / `:bc` | Close current buffer |
| `:buffer-close-others` | Close other buffers |
| `:buffer-close-all` | Close all buffers |

### Windows

Press `Ctrl-w`, then:

| Key | Action |
|---|---|
| `s` | Split current buffer horizontally |
| `v` | Split current buffer vertically |
| `n s` | New scratch buffer in horizontal split |
| `n v` | New scratch buffer in vertical split |
| `h` / `j` / `k` / `l` | Move to split |
| `H` / `J` / `K` / `L` | Swap split |
| `w` | Next split |
| `q` | Close split |
| `o` | Keep only current split |
| `t` | Transpose splits |

Commands:

| Command | Action |
|---|---|
| `:vsplit path` / `:vs path` | Open vertical split |
| `:hsplit path` / `:hs path` | Open horizontal split |

---

## View Mode

Press `z`, then:

| Key | Action |
|---|---|
| `z` / `c` / `b` | Center / top / bottom current line |
| `t` / `m` / `b` | Move cursor to screen top / middle / bottom |
| `j` / `k` | Scroll down / up |
| `Ctrl-f` / `Ctrl-b` | Page down / up |
| `Ctrl-d` / `Ctrl-u` | Half page down / up |

Press `Z` for sticky view mode when browsing.

---

## LSP

These require a working language server.

| Key | Action |
|---|---|
| `Space k` | Hover documentation |
| `Space a` | Code action |
| `Space r` | Rename symbol |
| `g d` | Go to definition |
| `g y` | Go to type definition |
| `g i` | Go to implementation |
| `g r` | Go to references |
| `Space s` | Document symbols |
| `Space S` | Workspace symbols |
| `Space d` | Document diagnostics |
| `Space D` | Workspace diagnostics |

Useful commands:

| Command | Action |
|---|---|
| `:lsp-restart` | Restart language servers |
| `:lsp-stop` | Stop language servers |
| `:lsp-workspace-command` | Run workspace command |
| `hx --health rust` | Check Rust setup |
| `hx --health python` | Check Python setup |

---

## Git

Current config enables a `diff` gutter.

| UI | Meaning |
|---|---|
| `+` | Added lines |
| `~` | Modified lines |
| `-` | Deleted lines |

Useful built-ins:

| Key / Command | Action |
|---|---|
| `Space g` | Changed files picker |
| `]g` / `[g` | Next / previous change |
| `]G` / `[G` | Last / first change |
| `:reset-diff-change` | Reset diff change at cursor |

---

## Commands

| Command | Action |
|---|---|
| `:write` / `:w` | Save |
| `:quit` / `:q` | Close current view |
| `:write-quit` / `:wq` | Save and quit |
| `:quit-all` / `:qa` | Quit all |
| `:format` / `:fmt` | Format current file |
| `:reload` | Reload current file from disk |
| `:reload-all` | Reload all files from disk |
| `:config-reload` | Reload Helix config |
| `:config-open` | Open user config |
| `:config-open-workspace` | Open workspace config |
| `:theme` | Show or change theme |
| `:set-language` | Set buffer language |
| `:indent-style 4` | Set indentation to 4 spaces |
| `:line-ending lf` | Set line ending |
| `:tutor` | Open Helix tutor |
| `:log-open` | Open Helix log |

---

## Current Config Summary

| Area | Setting |
|---|---|
| Theme | `gruvbox_dark_hard` |
| Line numbers | Relative |
| Indentation | Four spaces for common languages |
| Clipboard | Default yank register is system clipboard |
| Formatting | Auto format disabled |
| Git | Diff gutter enabled |
| File picker | Hidden files visible |
| Statusline | Mode, file, diagnostics, selections, position |

---

## Troubleshooting

| Symptom | Check |
|---|---|
| LSP does not work | Run `hx --health <language>` |
| Clipboard does not work | Run `hx --health clipboard` |
| Config change not visible | Run `:config-reload` |
| Wrong indentation | Run `:indent-style 4` |
| Too much text selected | Press `;` |
| Need command help | Press `Space ?` |
