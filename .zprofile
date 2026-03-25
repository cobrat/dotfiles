typeset -U path PATH

# Environment variables and PATH setup for login shells only.
if [[ "$OSTYPE" == darwin* ]]; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
elif [[ "$OSTYPE" == linux* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

export LANG="en_US.UTF-8"

# Tool-managed PATH additions.
if [[ -f "$HOME/.cargo/env" ]]; then
    source "$HOME/.cargo/env"
fi
