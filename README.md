# dotfiles

Personal dotfiles, managed as a git repo and applied via symlinks.

## What's inside

| Path | Applies to |
|---|---|
| `tmux/` | `~/.tmux.conf` — tmux |
| `vim/` | `~/.vimrc` — Vim (links `vim/basic.vim`) |
| `ghostty/` | `~/.config/ghostty/` — Ghostty terminal |
| `nvim/` | `~/.config/nvim/` — Neovim (see `nvim/README.md`) |
| `starship/` | `~/.config/starship.toml` — Starship prompt |
| `yazi/` | `~/.config/yazi/` — Yazi file manager |
| `zsh/` | `~/.zshrc` — Zsh (Starship prompt) |

## Install

```sh
git clone https://github.com/cobrat/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install_mac.sh
```

`install_mac.sh` symlinks each config into `$HOME`. It is **idempotent**: re-running
it is safe. If a destination already exists as a real file/directory, it is
first moved into `backup/<timestamp>/` (relative to `$HOME`) so nothing is ever
lost. The `backup/` folder is git-ignored.

## Update

```sh
cd ~/dotfiles
git pull
./install_mac.sh          # re-run; new/changed files get linked
```

Since configs are symlinked, editing `~/.config/...` is the same as editing the
repo — commit and push from `~/dotfiles`.

## Notes

- **Neovim**: requires Neovim >= 0.11.2 (`vim.pack` / `vim.lsp.config`).
- **Git**: `install_mac.sh` sets `core.hooksPath = .githooks` so the
  Conventional Commits `commit-msg` hook is enforced.
- **Vim**: `basic.vim` is a complete base config, linked directly to `~/.vimrc`
  by `install_mac.sh` (no manual activation needed).
- **Zsh**: `zsh/zshrc` is linked to `~/.zshrc` by `install_mac.sh` and enables
  Starship (replaces Powerlevel10k). Restart your shell after installing.
- **Starship**: `zsh/zshrc` already enables it via
  `eval "$(starship init zsh)"` (replaces Powerlevel10k). The config file is
  linked to `~/.config/starship.toml`.
- **Backups**: replaced files are moved into `backup/<timestamp>/` inside this
  repo (git-ignored); delete them once you're happy with the symlinked setup.
