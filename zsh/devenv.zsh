
#- DEVELOPMENT -------------------------------------------------------------------------------------
#- shortcuts for common dev actions ----------------------------------------------------------------

# Vim Shortcuts ------------------------------------------------------------------------------------

v() {
    local n=$(( $(stty size | awk '{print $2}') / 100 ))
    (( n < 1 )) && n=1
    (( ${FILE_COUNT:-$#} < n )) && n=${FILE_COUNT:-$#}
    "$EDITOR" -O"$n" -- "$@"
}

alias sv="sudo $EDITOR"
alias vim=$EDITOR
alias vic='vi ./src c h'


# Hack Scripts -------------------------------------------------------------------------------------

alias figlet='figlet -w $(tput cols)'
alias m='glow -w $(tput cols)'
alias findf="find . -type f -iname"

alias g=git
alias G='git status -s --show-stash --ignore-submodule 2> /dev/null'

alias pins='
    pushd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)/main/include" > /dev/null 2>&1;
    rg --no-line-number "\#define.*_PIN\s+";
    popd > /dev/null 2>&1;
'

alias cupdate='find . -maxdepth 1 -type f -iname ".copier-*-answers.yml" \
        -exec copier update --trust --defaults --answers-file {} \;'

alias ctags='ctags --recurse=yes --tag-relative=yes --exclude=.git --extras=+q -f ./.tags'

rmspace() {
    local -a files=( ${(0)"$(rg --files-with-matches --null '[ \t]+$' 2>/dev/null)"} )
    files=( ${files:#} )

    (( $#files )) || { print -r -- 'no changes'; return 0 }

    local f tmp
    for f in $files; do
        tmp=$(mktemp "${TMPDIR:-/tmp}/rmspace.XXXXXX") || return 1
        # [[:blank:]] is space+tab only, so CRLF line endings survive.
        sed 's/[[:blank:]]*$//' "$f" > "$tmp" &&
            cat "$tmp" > "$f"   # keeps the original inode, mode and owner
        rm -f "$tmp"
    done

    print -r -- "cleaned up $#files file(s)"
}

