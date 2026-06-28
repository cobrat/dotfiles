# dotfiles

Personal dotfiles for macOS and Ubuntu. The repo is deployed by symlinking
selected files and directories into `$HOME`.

## What Is Included

- `zsh/` - Minimal Zsh without a framework: `zprofile` keeps login-shell PATH usable, `zshrc` handles interactive history, built-in completion, mise, zoxide, fzf, eza aliases, yazi helpers, and Starship.
- `helix/` - Helix editor config with relative line numbers, GitHub Dark Dimmed theme, hidden-file picker, indent guides, soft wrap, and visible bufferline.
- `yazi/` - Yazi with `[0,1,1]` layout, mtime line mode, hidden files shown, Flexoki Dark flavor (`ya pkg`), flat statusline, and Helix opener. After deploy run `ya pkg install`.
- `ghostty/` - Ghostty terminal font, theme, window and cursor settings.
- `starship/` - Starship prompt config.
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

### Linux VPS: Helix + tmux Only

Bootstrap directly on a fresh machine:

```sh
curl -fsSL https://raw.githubusercontent.com/cobrat/dotfiles/main/install_vps_hx_tmux.sh | bash
```

Or run the script directly if the file is already present:

```sh
./install_vps_hx_tmux.sh
```

The VPS script installs `tmux` and `hx`, then downloads only `.tmux.conf`,
`helix/config.toml`, and `helix/languages.toml` into `$HOME`. Existing target
files are backed up with a timestamp suffix before the downloaded files are
installed.

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
defaults to `source` (the first column), so `yazi|symlink|.config` links to
`$HOME/.config/yazi`.

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
