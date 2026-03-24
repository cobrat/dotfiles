# history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

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
source $ZSH/oh-my-zsh.sh

# style customization
PROMPT=$'\n''%B[%F{green}%n@%m%f %F{blue}%(4~|%-1~/…/%2~|%~)%f]%b%(#.#.$) '
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# fzf config and preview
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix \
    --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border \
    --color=hl:#2dd4bf"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# zoxide initialize
eval "$(zoxide init zsh)"

# fzf integration
if command -v fzf &>/dev/null; then
    source <(fzf --zsh 2>/dev/null) || {
        source /usr/share/doc/fzf/examples/key-bindings.zsh 2>/dev/null
        source /usr/share/doc/fzf/examples/completion.zsh 2>/dev/null
    }
fi

# alias
alias ls="eza --long --color=always --no-user"
alias l="eza --color=always --no-user"
alias la="eza -la --color=always --no-user"
alias tree="eza --tree --level=3 --all --ignore-glob='.git' --color=always"
alias dtree="eza --tree --level=3 --all --only-dirs \
    --ignore-glob='.git' --color=always"
alias cat="bat"
alias cd="z"
alias lg="lazygit"

