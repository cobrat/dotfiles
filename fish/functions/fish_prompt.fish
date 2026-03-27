function fish_prompt
    set_color normal
    echo

    set_color --bold green
    printf "[%s@%s " $USER (prompt_hostname)

    set_color blue
    printf "%s" (prompt_pwd)

    set_color normal
    set_color --bold
    printf "]"

    set_color normal
    if fish_is_root_user
        printf '%s' '# '
    else
        printf '%s' '$ '
    end

    set_color normal
end
