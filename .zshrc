# history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$HOME/.zsh_history"
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY

# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

# zsh plugins
plugins=(
    git
    colored-man-pages
    zsh-autosuggestions
    zsh-syntax-highlighting
)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
    source "$ZSH/oh-my-zsh.sh"
fi

# style customization
PROMPT=$'\n''%B[%F{green}%n@%m%f '\
    '%F{blue}%(4~|%-1~/.../%2~|%~)%f]%b%(#.#.$) '

if (( ${+ZSH_HIGHLIGHT_STYLES} )); then
    ZSH_HIGHLIGHT_STYLES[comment]='fg=242'
fi

# Runtime tool hooks for interactive shells.
if command -v mise &>/dev/null; then
    eval "$(mise activate zsh)"
fi

# zoxide initialize
if command -v zoxide &>/dev/null; then
    eval "$(zoxide init zsh)"
fi

# fzf integration
if command -v fzf &>/dev/null; then
    unset FZF_DEFAULT_COMMAND
    unset FZF_CTRL_T_COMMAND
    unset FZF_ALT_C_COMMAND
    unset FZF_DEFAULT_OPTS
    unset FZF_CTRL_T_OPTS
    unset FZF_ALT_C_OPTS

    if command -v fd &>/dev/null; then
        export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix "\
            "--exclude .git"
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND="fd --type=d --hidden "\
            "--strip-cwd-prefix --exclude .git"
    fi

    export FZF_DEFAULT_OPTS="--height 50% --layout=default --border "\
        "--color=hl:#2dd4bf"

    if command -v bat &>/dev/null; then
        export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n "\
            "--line-range :500 {}'"
    else
        export FZF_CTRL_T_OPTS="--preview 'sed -n \"1,500p\" {}'"
    fi

    if command -v eza &>/dev/null; then
        export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} "\
            "| head -200'"
    else
        export FZF_ALT_C_OPTS="--preview 'find {} -maxdepth 3 -print "\
            "| head -200'"
    fi

    source <(fzf --zsh 2>/dev/null) || {
        source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null
        source /usr/share/doc/fzf/examples/completion.zsh 2>/dev/null
    }
fi

# alias
if command -v eza &>/dev/null; then
    alias ls="eza --long --color=always --no-user"
    alias l="eza --color=always --no-user"
    alias la="eza -la --color=always --no-user"
    alias tree=\
        "eza --tree --level=3 --all --ignore-glob='.git' --color=always"
    alias dtree=\
        "eza --tree --level=3 --all --only-dirs --ignore-glob='.git' "\
        "--color=always"
fi

if command -v zoxide &>/dev/null; then
    alias j="z"
fi

if command -v lazygit &>/dev/null; then
    alias lg="lazygit"
fi

# External dependencies used here:
# oh-my-zsh, fzf, fd, bat, eza, zoxide, mise, lazygit
