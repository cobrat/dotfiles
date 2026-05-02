# dotfiles

Personal dotfiles for macOS and Ubuntu. The repo is deployed by symlinking
selected files and directories into `$HOME`.

## What Is Included

- `fish/` - Fish shell setup, PATH entries, aliases, fzf, zoxide and starship.
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

Only `symlink` is currently supported. For example:

```text
starship/starship.toml|symlink|.config|starship.toml
```

links `starship/starship.toml` to `$HOME/.config/starship.toml`.
