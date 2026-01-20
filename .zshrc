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
PROMPT='%{$fg[magenta]%}%~%{$fg[red]%} %{$reset_color%}$%b '

# fzf config and prview
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

export FZF_CTRL_T_OPTS="--preview 'bat --color=always -n --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --icons=always --tree --color=always {} | head -200'"

# initialize
eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

# alias
alias ls="eza --long --color=always --no-user"
alias tree="tree -L 3 -a -I '.git' --charset X "
alias dtree="tree -L 3 -a -d -I '.git' --charset X "
alias lg="lazygit"

typeset -U PATH
