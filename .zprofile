eval "$(/opt/homebrew/bin/brew shellenv)"

export LANG=en_US.UTF-8

# ------All PATHS------
## Mise
eval "$(/Users/wzh/.local/bin/mise activate zsh)"

## Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
