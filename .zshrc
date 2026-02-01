# oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""

# zsh plugins
plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# style customization
# PROMPT='%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}$%b '
PROMPT='%F{blue}%n@%m%f %F{magenta}%1~%f $ '
ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# fzf config and prview
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
export FZF_DEFAULT_OPTS="--height 50% --layout=default --border --color=hl:#2dd4bf"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# zoxide initialize
eval "$(zoxide init zsh)"

# fzf integration
if command -v fzf &>/dev/null; then
    if fzf --zsh &>/dev/null; then
        eval "$(fzf --zsh)"
    else
        [[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
        [[ -f /usr/share/doc/fzf/examples/completion.zsh ]] && source /usr/share/doc/fzf/examples/completion.zsh
    fi
fi

# alias
alias ls="eza --long --color=always --no-user"
alias tree="tree -L 3 -a -I '.git' --charset X "
alias dtree="tree -L 3 -a -d -I '.git' --charset X "
alias lg="lazygit"

typeset -U PATH
