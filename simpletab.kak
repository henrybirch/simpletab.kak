declare-option str-list simpletab_bufnames_to_ignore "*lint-output*" "*debug*"
declare-option str simpletab_default_face "Menu"
declare-option str simpletab_current_buffer_face "PrimaryCursor"

define-command -override simpletab-show-buffers -docstring 'Show a list of buffers.' %{
    info -markup %sh{
        eval "set -- $kak_quoted_opt_simpletab_bufnames_to_ignore"
        bufnames_to_ignore=$*
        eval set -- "$kak_quoted_buflist"

        i=0
        for buffer do
            should_ignore=false
            old_ifs=$IFS
            IFS='
            '
            for bufname_to_ignore in $bufnames_to_ignore; do
                if [ "$buffer" = "$bufname_to_ignore" ]; then
                    should_ignore=true
                    break
                fi
            done

            IFS=$old_ifs

            if [ $should_ignore = true ]; then
                continue
            fi

            i=$((i + 1))

            if [ $i -lt 10 ]; then
                number=$i
            elif [ $i = 10 ]; then
                number=0
            else
                number=-1
            fi

	    if [ "$buffer" = "$kak_bufname" ]; then
                if [ ! $number = -1 ]; then
        	    printf "{%s}%s. %s{%s}\n" "$kak_opt_simpletab_current_buffer_face" "$number" "$buffer" "$kak_opt_simpletab_default_face"
                else
        	    printf "{%s}%s{%s}\n" "$kak_opt_simpletab_current_buffer_face"  "$buffer" "$kak_opt_current_default_face"
                fi
	    else
                if [ ! $number = -1 ]; then
                    printf "{%s}%s. %s{%s}\n" "$kak_opt_simpletab_default_face" "$number" "$buffer" "$kak_opt_simpletab_default_face" 
                else
                    printf "{%s}%s{%s}\n" "$kak_opt_simpletab_default_face" "$buffer" "$kak_opt_simpletab_default_face" 
                fi
	    fi
	done
    }
}

define-command -override -params 1 simpletab-get-buffer-by-index -docstring 'Get buffer by index in kak_opt_buflist. Ignore those in simpletab_bufnames_to_ignore.' %{
    evaluate-commands %sh{
        user_index="$1"
        eval "set -- $kak_quoted_opt_simpletab_bufnames_to_ignore"
        bufnames_to_ignore=$*
        eval set -- "$kak_quoted_buflist"

        i=0
        for buffer do
            should_ignore=false
            old_ifs=$IFS
            IFS='
            '
            for bufname_to_ignore in $bufnames_to_ignore; do
                if [ "$buffer" = "$bufname_to_ignore" ]; then
                    should_ignore=true
                    break
                fi
            done

            IFS=$old_ifs

            if [ $should_ignore = true ]; then
                continue
            fi

            if [ "$i" = "$user_index" ]; then
                printf 'buffer %s\n' "$buffer"
                exit
            fi

            i=$((i + 1))
        done
        printf "fail 'Invalid index.'"
    }
}

define-command -override -params 1 simpletab-move-buffer-to-index -docstring 'Move the current buffer towards the start of buflist (-1) or towards the end (1). Wraps around.' %{
    evaluate-commands %sh{
        user_index="$1"

        eval "set -- $kak_quoted_opt_simpletab_bufnames_to_ignore"
        bufnames_to_ignore=$*
        eval set -- "$kak_quoted_buflist"

        i=0
        for buffer do
            should_ignore=false
            old_ifs=$IFS
            IFS='
            '
            for bufname_to_ignore in $bufnames_to_ignore; do
                if [ "$buffer" = "$bufname_to_ignore" ]; then
                    should_ignore=true
                    break
                fi
            done

            IFS=$old_ifs

            if [ $should_ignore = true ]; then
                continue
            fi

            if [ "$buffer" = "$kak_bufname" ]; then
                current_buffer_index="$i"
            fi

            if [ "$i" = "$user_index" ]; then
                index_to_move_to="$i"
            fi

            i=$((i + 1))
        done

        if [ ! -n "$index_to_move_to" ]; then
            printf "fail 'Invalid index.'\n"
            exit
        fi

        if [ "$index_to_move_to" = "$current_buffer_index" ]; then
            exit
        fi

        if [[ "$index_to_move_to" -lt "$current_buffer_index" ]]; then
            direction="-"
        else
            direction="+"
        fi

        i=0
        printf 'arrange-buffers '
        for buffer do
            should_ignore=false
            old_ifs=$IFS
            IFS='
            '
            for bufname_to_ignore in $bufnames_to_ignore; do
                if [ "$buffer" = "$bufname_to_ignore" ]; then
                    should_ignore=true
                    break
                fi
            done

            IFS=$old_ifs

            if [ $should_ignore = true ]; then
                continue
            fi

            if [ "$i" = "$current_buffer_index" ]; then
                i=$((i + 1))
                continue;
            fi

            if [ "$i" = "$index_to_move_to" ]; then
                if [ "$direction" = "-" ]; then
                    printf '%s ' "$kak_bufname"
                    printf '%s ' "$buffer"
                else
                    printf '%s ' "$buffer"
                    printf '%s ' "$kak_bufname"
                fi
            else
                printf '%s ' "$buffer"
            fi

            i=$((i + 1))
        done
        printf '\n'
    }
}

define-command -override -params 1 simpletab-move-buffer %{
    evaluate-commands %sh{
        if [ "$1" = "-1" ]; then
            amount="-1"
        elif [ "$1" = "1" ]; then
            amount="1"
        else
            printf "fail 'Invalid argument. Expected 1 or -1.'\n"
        fi

        eval "set -- $kak_quoted_opt_simpletab_bufnames_to_ignore"
        bufnames_to_ignore=$*
        eval set -- "$kak_quoted_buflist"

        i=0
        for buffer do
            should_ignore=false
            old_ifs=$IFS
            IFS='
            '
            for bufname_to_ignore in $bufnames_to_ignore; do
                if [ "$buffer" = "$bufname_to_ignore" ]; then
                    should_ignore=true
                    break
                fi
            done

            IFS=$old_ifs

            if [ $should_ignore = true ]; then
                continue
            fi

            if [ "$buffer" = "$kak_bufname" ]; then
                current_buffer_index="$i"
            fi

            i=$((i + 1))
        done

        if [ "$amount" = "-1" ]; then
            if [ "$current_buffer_index" = "0" ]; then
                new_index=$(($i - 1))
            else
                new_index=$(("$current_buffer_index" - 1))
            fi
        else
            if [ "$current_buffer_index" = $(($i - 1)) ]; then
                new_index=0
            else
                new_index=$(("$current_buffer_index" + 1))
            fi
        fi
        printf 'simpletab-move-buffer-to-index %s\n' "$new_index"
    }
}

complete-command -menu simpletab-move-buffer shell-script %{
    printf '1\n-1'
}
