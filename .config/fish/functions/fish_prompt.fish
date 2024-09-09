function fish_prompt
    if not set -q VIRTUAL_ENV_DISABLE_PROMPT
        set -g VIRTUAL_ENV_DISABLE_PROMPT true
    end
    set_color -o green
    printf '%s@%s' $USER (prompt_hostname)
    set_color -o normal

    printf ':'

    set_color -o yellow
    printf '%s' (prompt_pwd)
    set_color -o normal

    # Line 2
    echo
    if test -n "$VIRTUAL_ENV"
        printf "(%s) " (set_color blue)(basename $VIRTUAL_ENV)(set_color normal)
    end
    printf '↪ '
    set_color normal
end
