function dtree
    if not command -q eza
        echo "dtree: eza is not installed" >&2
        return 127
    end

    eza --tree --level=3 --all --only-dirs \
        --ignore-glob='.git' --color=always $argv
end
