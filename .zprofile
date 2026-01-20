eval "$(/opt/homebrew/bin/brew shellenv)"

export LANG=en_US.UTF-8

# ------All PATHS------
## Mise
eval "$(/Users/wzh/.local/bin/mise activate zsh)"

## Rust
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

## Conda (Miniconda)
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    fi
fi
unset __conda_setup
