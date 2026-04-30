function tree
    if command -q eza
        eza --tree --level=3 --all --ignore-glob='.git' \
            --color=always $argv
    else if command -q tree
        command tree $argv
    else
        echo "tree: eza is not installed" >&2
        return 127
    end
end
