if test -d /opt/homebrew/bin
    fish_add_path --move /opt/homebrew/bin /opt/homebrew/sbin
end

if test -d $HOME/.local/bin
    fish_add_path --move $HOME/.local/bin
end

if test -d $HOME/.cargo/bin
    fish_add_path --move $HOME/.cargo/bin
end

if test -d $HOME/.local/share/bob/nvim-bin
    fish_add_path --move $HOME/.local/share/bob/nvim-bin
end

set -gx LANG en_US.UTF-8

# Syntax highlighting colors
set -g fish_color_command green
set -g fish_color_param normal
set -g fish_color_keyword blue
set -g fish_color_quote yellow
set -g fish_color_error red --bold
set -g fish_color_comment brblack
set -g fish_color_operator cyan
set -g fish_color_escape magenta
set -g fish_color_autosuggestion brblack
set -g fish_color_valid_path --underline

if status is-interactive
    if command -q mise
        mise activate fish | source
    end

    if command -q zoxide
        zoxide init fish | source
        alias j="z"
    end

    if command -q fzf
        set -e FZF_DEFAULT_COMMAND
        set -e FZF_CTRL_T_COMMAND
        set -e FZF_ALT_C_COMMAND
        set -e FZF_DEFAULT_OPTS
        set -e FZF_CTRL_T_OPTS
        set -e FZF_ALT_C_OPTS

        if command -q fd
            set -gx FZF_DEFAULT_COMMAND \
                "fd --hidden --strip-cwd-prefix --exclude .git"
            set -gx FZF_ALT_C_COMMAND \
                "fd --type=d --hidden --strip-cwd-prefix --exclude .git"
        end

        set -gx FZF_DEFAULT_OPTS \
            "--height 50% --layout=default --border --color=hl:#2dd4bf"

        if command -q bat
            set -gx FZF_CTRL_T_OPTS \
                "--preview 'bat --color=always -n --line-range :500 {}'"
        else
            set -gx FZF_CTRL_T_OPTS "--preview 'sed -n \"1,500p\" {}'"
        end

        if command -q eza
            set -gx FZF_ALT_C_OPTS \
                "--preview 'eza --tree --color=always {} | head -200'"
        else
            set -gx FZF_ALT_C_OPTS \
                "--preview 'find {} -maxdepth 3 -print | head -200'"
        end

        fzf --fish | source
    end

    if command -q eza
        alias ls="eza --long --color=always --no-user"
        alias l="eza --color=always --no-user"
        alias la="eza -la --color=always --no-user"

        function tree
            eza --tree --level=3 --all --ignore-glob='.git' \
                --color=always $argv
        end

        function dtree
            eza --tree --level=3 --all --only-dirs \
                --ignore-glob='.git' --color=always $argv
        end
    end

    if command -q lazygit
        alias lg="lazygit"
    end
end
