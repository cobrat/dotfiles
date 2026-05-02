# dotfiles

Personal configuration files for macOS and Ubuntu.

## Contents

- **nvim** — Neovim config (`init.lua`)
- **helix** — Helix editor config
- **starship** — Shell prompt config
- **yazi** — Terminal file manager config
- **wezterm** — WezTerm terminal config
- **zed** — Zed editor settings and keymap
- **.zshrc / .zprofile** — Zsh shell config
- **.vimrc** — Vim config
- **.tmux.conf** — Tmux config

## Usage

### macOS

```sh
./install_mac.sh       # install dependencies
./deploy.sh MANIFEST.mac
```

### Ubuntu

```sh
./install_ubuntu.sh    # install dependencies
./deploy.sh MANIFEST.ubuntu
```

`deploy.sh` reads a manifest file and creates symlinks from this repo into `$HOME`.
