
#- DEVELOPMENT -----------------------------------------------------------------
#- shortcuts for common dev actions --------------------------------------------

#- Priect Management -----------------------------------------------------------

# Create new project
pinit() {
    local language="$1"
    shift

    local project_name="$*"

    case "$language" in
        py | python)
            template_link="git@github.com:karnull/template-python.git"
            ;;

        *)
            template_link="git@github.com:karnull/template-generic.git"
            ;;
    esac

    copier copy "$template_link" "./$project_name" --trust

    local camel="${${(C)project_name}// /}"
    mv "./$project_name" "./$camel"
    cd "./$camel"
}


#- Benches ---------------------------------------------------------------------

# Path for project_initialise script
PLAYGROUND="$HOME/.local/Playground"


# Create Playground if it doesn't exit
[[ ! -d $PLAYGROUND ]] && {
    mkdir -p $PLAYGROUND
    pushd $PLAYGROUND 2>/dev/null

    git clone git@github.com:karnull/template-python.git
    git clone git@github.com:karnull/template-generic.git

    popd 2>/dev/null
}


# Create or navigate bench directories
bench() {
    # Operate from current directory if first arg is '.', else from playground
    if [[ "$1" == "." ]]; then
        shift
    else
        cd "$PLAYGROUND" || return
    fi

    # Numeric argument → jump to existing bench
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        local target="./bench$1"
        if [[ -d "$target" ]]; then
            cd "$target" || return
            return
        else
            echo "Directory $target does not exist."
            return 1
        fi
    fi

    # Find highest existing bench index
    local highest
    highest=$(
        find . -maxdepth 1 -type d -name "bench*" |
        grep -o '[0-9]*$' |
        sort -n |
        tail -1
    )

    [[ -z "$highest" ]] && highest=0
    local next=$((highest + 1))

    if [[ -n "$1" ]]; then
        case "$1" in
            py|python)
                template_link="$PLAYGROUND/template-python"
                ;;
            *)
                template_link="$PLAYGROUND/template-generic"
                ;;
        esac

        copier copy "$template_link" "./bench$next" --trust
    else
        mkdir "./bench$next"
    fi

    cd "./bench$next/" || return
}


# Clear all bench directories
benchcl() {
    setopt RM_STAR_SILENT

    local cwd
    cwd="$(pwd)"

    local BENCHES
    if [[ "$1" == "." ]]; then
        BENCHES="."
    else
        BENCHES="$PLAYGROUND"
    fi

    [[ "$cwd" == "$BENCHES"* ]] && cd ~

    echo "Clearing benches"
    rm -rf "$BENCHES"/bench* >/dev/null 2>&1
}

