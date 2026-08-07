# dotfiles

Personal dotfiles for macOS, Ubuntu, and lightweight VPS setup.

## Contents

- `zsh/` - Zsh config.
- `helix/` - Helix editor config.
- `yazi/` - Yazi file manager config.
- `ghostty/` - Ghostty terminal config for macOS.
- `starship/` - Starship prompt config.
- `.tmux.conf` - tmux config.

## Install

macOS:

```sh
./install_mac.sh
./deploy.sh MANIFEST.mac
```

Ubuntu:

```sh
./install_ubuntu.sh
./deploy.sh MANIFEST.ubuntu
```

VPS with only Helix and tmux:

```sh
curl -fsSL https://raw.githubusercontent.com/cobrat/dotfiles/main/install_vps_hx_tmux.sh | bash
```

## Deploy

`deploy.sh` creates symlinks from this repo into `$HOME` according to a
manifest file.

Manifest format:

```text
source|operation|destination-dir|optional-target-name
```

Example:

```text
zsh/zshrc|symlink|-|.zshrc
helix|symlink|.config
```
