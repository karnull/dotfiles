# ---------------------------------------------------------------------------------------------
# DevEdit
#
# A lightweight ZSH script for quickly navigating and editing common project files without
# worrying about directory structure.
#
# DevEdit is Git-aware and provides shortcuts for frequently accessed, language-agnostic files
# such as:
#   - README*
#   - Makefile
#   - .gitignore
#   - .git/config
#   - entry-point files like main.*, index.*, init.*
#
# It also includes an interactive file picker ("vi") powered by fzf and bat, allowing fast,
# scoped searching and multi-file editing with preview support.
#
# Commands:
#   main
#     Searches the git repository for files matching main.*, index.*, or init.* and opens the
#     first match in $EDITOR.
#
#   readme
#     Opens README* from the project root, if present.
#
#   makefile
#     Opens (or creates) the Makefile at the project root.
#
#   gignore
#     Opens .gitignore from the project root.
#
#   gconfig
#     Opens .git/config.
#
#   parent
#     cd into the project root.
#
#   vi
#     Lists all tracked and untracked (but not ignored) files in the project using fzf,
#     with syntax-highlighted previews via bat. Selected files are opened in $EDITOR.
#
#   vi .
#     Same as above, scoped to the current directory.
#
#   vi c .
#     Lists only *.c files in the current directory.
#
# The goal is to reduce mental overhead when navigating projects and allow you to stay focused
# on editing, not path-finding.
# ---------------------------------------------------------------------------------------------


# helper functions ---------------------------------------------------------------------------

# ensure we are inside a git repository
isGit() {
    if ! git rev-parse --is-inside-work-tree &>/dev/null; then
        echo -e "\e[31mError:\e[0m This action requires a git repository."
        return 1
    fi
}

# open file in $EDITOR if it exists
ve() {
    if [[ -f "$1" ]]; then
        "$EDITOR" "$1"
    else
        echo -e "\e[31mError:\e[0m File not found: $1"
        return 1
    fi
}

# calls --------------------------------------------------------------------------------------

# Edit README*
readme() {
    isGit || return

    local project_root readme_file
    project_root=$(git rev-parse --show-toplevel)
    readme_file=$(ls "$project_root"/README* 2>/dev/null | head -n 1)

    if [[ -z "$readme_file" ]]; then
        echo -e "\e[31mError:\e[0m No README file found."
        return 1
    fi

    ve "$readme_file"
}

# Edit Makefile (creates if missing)
makefile() {
    isGit || return

    local project_root=$(git rev-parse --show-toplevel)

    "$EDITOR" "$project_root/Makefile"
}

# Edit .git/config
gconfig() {
    isGit || return

    local project_root
    project_root=$(git rev-parse --show-toplevel)

    ve "$project_root/.git/config"
}

# Edit .gitignore
gignore() {
    isGit || return

    local project_root
    project_root=$(git rev-parse --show-toplevel)

    "$EDITOR" "$project_root/.gitignore"
}

# Edit main / index / init file
main() {
    isGit || return

    local main_file
    main_file=$(git ls-files | grep -i -E '(^|/)(main|index|init)\.' | head -n 1)

    if [[ -z "$main_file" ]]; then
        echo -e "\e[31mError:\e[0m No entry-point file found."
        return 1
    fi

    ve "$main_file"
}

# cd to project root
parent() {
    isGit || return
    cd "$(git rev-parse --show-toplevel)" || return
}

# Vim Interactive ---------------------------------------------------------------------------

vi() {
    #
    # common variables ------------------

    local -a CONDITIONS=()
    local -a DIRS=()
    local -a FILES=()
    local -a EXTS=()
    local -a SPECS=()
    local term_width=$(stty size | awk '{print $2}')

    # build conditions from arguments
    for ARG in "$@"; do
        if [[ "$ARG" == .* ]]; then
            DIRS+=("${ARG%/}/")
        else
            EXTS+=("$ARG")
            CONDITIONS+=(-iname "*.$ARG" -o)
        fi
    done

    (( ${#DIRS[@]} == 0 )) && DIRS=(".") # default directory


    #
    # git repository --------------------

    # Build pathspecs
    for dir in "${DIRS[@]}"; do
        if (( ${#EXTS[@]} > 0 )); then
            for ext in "${EXTS[@]}"; do
                SPECS+=("$dir/**/*.${ext}")
            done
        else
            SPECS+=("$dir*")
        fi
    done


    FILES=$(
        git ls-files --cached --others --exclude-standard -- "${SPECS[@]}" 2>/dev/null
    ) || {

    #
    # not git repository ----------------

        local -a FIND_ARGS=()

        # remove trailing -o
        if (( ${#CONDITIONS[@]} > 0 )) && [[ "${CONDITIONS[-1]}" == "-o" ]]; then
            CONDITIONS=("${CONDITIONS[@]:0:-1}")
        fi

        # base find arguments (regular files only)
        FIND_ARGS=(
            -maxdepth 1
            -type f
            \( -size 0 -o -exec grep -Iq . {} \; \)
        )

        # add extension/name conditions if present
        if (( ${#CONDITIONS[@]} > 0 )); then
            FIND_ARGS+=( \( "${CONDITIONS[@]}" \) )
        fi

        # run find
        for dir in "${DIRS[@]}"; do
            FILES+=(
                ${(f)"$(find "$dir" "${FIND_ARGS[@]}" -print)"}
            )
        done

        # sanitise FILES, remove empty lines
        FILES=("${FILES[@]:#}")
    }


    #
    # fzf search selection --------------

    # no results
    if (( ${#FILES[@]} == 0 )); then
        echo "no files found"
        return
    fi

    # use fzf to select files, displaying with bat
    local FILES_OPEN=$(
        if [ "$term_width" -lt 155 ]; then
            print -rl -- "${FILES[@]}" | sort | fzf -m \
                --preview-window=down:80%:wrap \
                --preview='echo -e "$(basename {})" && bat --color=always --number {}'
        else
            print -rl -- "${FILES[@]}" | sort | fzf -m \
                --preview-window=right:123:wrap \
                --preview='echo -e "$(basename {})" && bat --color=always --number {}'
        fi
    )


    #
    # open selected files ---------------

    # count the number of selected files
    local FILE_COUNT=$(echo "$FILES_OPEN" | wc -l | tr -d ' ')

    # open the selected files in the editor
    if [ -z "$FILES_OPEN" ]; then
        echo "No files selected."

    else
        # use vertical splits with a dynamic count
        # compute how many splits to open: min(file count, columns/100), at least 1
        local cols_per_100=$(( $term_width / 100 ))
        [ "$cols_per_100" -lt 1 ] && cols_per_100=1

        # min(FILE_COUNT, cols_per_100)
        if [ "$FILE_COUNT" -le "$cols_per_100" ]; then
            split_count="$FILE_COUNT"
        else
            split_count="$cols_per_100"
        fi

        $EDITOR -O"$split_count" $(echo "$FILES_OPEN")
    fi
}

