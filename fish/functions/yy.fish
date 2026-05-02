function yy
    if not command -q yazi
        echo "yy: yazi is not installed" >&2
        return 127
    end

    set -l cwd_file (mktemp -t yazi-cwd.XXXXXX)
    yazi $argv --cwd-file="$cwd_file"

    set -l cwd (command cat "$cwd_file")
    command rm -f "$cwd_file"

    if test -n "$cwd"; and test "$cwd" != "$PWD"
        cd "$cwd"
    end
end
