if [[ "$OSTYPE" == darwin* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == linux* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

export LANG=en_US.UTF-8

# ------All PATHS------
## Mise
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
fi

## Rust
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
