if [[ "$OSTYPE" == darwin* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ "$OSTYPE" == linux* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

export LANG=en_US.UTF-8

# ------All PATHS------
## Mise
eval "$($HOME/.local/bin/mise activate zsh)"

## Rust
[ -f "$HOME/.cargo/env" ] && 
