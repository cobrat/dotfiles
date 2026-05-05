# dotfiles

Personal dotfiles for macOS and Ubuntu. The repo is deployed by symlinking
selected files and directories into `$HOME`.

## What Is Included

- `zsh/` - Zsh with [Zim](https://github.com/zimfw/zimfw) (`zsh/zimrc` → `~/.config/zsh/zimrc`, **no** built-in Zim prompt); **Starship** is started from `zsh/zshrc` (PATH, mise, zoxide, fzf, eza there). **`~/.zim/`** bootstrap (`degit` as set in `zshrc`).
- `nvim/` - Minimal Neovim config with `<Space>` leader and relative numbers.
- `yazi/` - Yazi config using Neovim as the editor and a Gruvbox flavor.
- `ghostty/` - Ghostty terminal font, theme, window and cursor settings.
- `starship/` - Starship prompt config.
- `zed/` - Zed settings and keymap.
- `.vimrc` - Vim config.
- `.tmux.conf` - tmux config.
- `.githooks/` - Git hooks, including Conventional Commit message checks.

## Usage

Install CLI dependencies first, then deploy the relevant manifest.

### macOS

```sh
./install_mac.sh
./deploy.sh MANIFEST.mac
```

### Ubuntu

```sh
./install_ubuntu.sh
./deploy.sh MANIFEST.ubuntu
```

## Deployment

`deploy.sh` reads a manifest and creates symlinks into `$HOME`. It refuses to
overwrite an existing non-symlink path, so move or remove conflicting files
manually before running it again.

Manifest rows use this format:

```text
source|operation|destination-dir|optional-target-name
```

Only `symlink` is currently supported. The symlink is created at
`$HOME/<destination-dir>/<optional-target-name>`. If `destination-dir` is empty,
the path is `$HOME/<optional-target-name>`; if the name is also omitted, it
defaults to `source` (the first column), so `nvim|symlink|.config` links to
`$HOME/.config/nvim`.

Use `-` as `destination-dir` when the link must sit directly in `$HOME` and the
repo path is not the final name (for example `zsh/zshrc` → `~/.zshrc`):

```text
zsh/zshrc|symlink|-|.zshrc
```

Another example:

```text
starship/starship.toml|symlink|.config|starship.toml
```

links `starship/starship.toml` to `$HOME/.config/starship.toml`.
