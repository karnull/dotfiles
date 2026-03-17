#- MANAGEMENT -------------------------------------------------------------------------------------
#- manage configurations --------------------------------------------------------------------------

# Neovim ------------------------------------------------------------------------------------------

nedit() {
    pushd $DOTFILES/nvim/lua/ > /dev/null;
    vi lua .
    popd > /dev/null
}

alias ntime='\
    a=$HOME/.local/share/nvimtime ;\
    $EDITOR --startuptime $a $a && tail -n 5 $a && rm $a ;\
    unset a'


# ZSH ---------------------------------------------------------------------------------------------

zedit() {
    pushd $DOTFILES/zsh > /dev/null;
    vi .
    popd > /dev/null
}

alias zupdate="source ~/.zshrc"
alias ztime="time zsh -i -c exit"


# TMux --------------------------------------------------------------------------------------------

tedit() {
    pushd $DOTFILES/tmux > /dev/null;
    vi conf .
    popd > /dev/null
}

alias tupdate="tmux source-file $DOTFILES/tmux/tmux.conf"

tm() {
    local sessions session
    sessions=$(tmux ls 2>/dev/null)

    if [[ -z "$sessions" ]]; then
        echo "Session Create"
        tmux
        return
    fi

    [[ -n "$TMUX" ]] && echo "Sessions Switch" || echo "Session Connect"

    session=$(
        print -r -- "$sessions" |
            fzf --height=30% --border=rounded |
            cut -f 1 -d ':'
    )

    [[ -z "$session" ]] && return

    if [[ -n "$TMUX" ]]; then
        tmux switch-client -t "$session"
    else
        tmux attach-session -t "$session"
    fi
}

# Git-----------------------------------------------------------------------------------------------

gedit() {
	local entries=()

	if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		local root
		root=$(git rev-parse --show-toplevel)

		while IFS= read -r gitignore; do
			local relpath="./${gitignore#$root/}"
			entries+=("${relpath}"$'\t'"${gitignore}")
		done < <(find "$root" -type f -iname ".gitignore")

		[[ -f "$root/.git/config" ]] &&
			entries+=($'Local Config\t'"$root/.git/config")
	fi

	[[ -f "$DOTFILES/git/config" ]] &&
		entries+=($'Global Config\t'"$DOTFILES/git/config")

	[[ -f "$DOTFILES/git/global_ignore" ]] &&
		entries+=($'Global Ignore\t'"$DOTFILES/git/global_ignore")

	[[ -f "$HOME/.gitconfig" ]] &&
		entries+=($'Home\t'"$HOME/.gitconfig")

	printf '%s\n' "${entries[@]}" |
		fzf -m \
			--with-nth=1 \
			--delimiter=$'\t' \
			--preview-window=down:70%:wrap \
			--preview='printf "\033[1;36m%s\033[0m\n\n" "{2}" && bat --color=always --number {2}' |
		cut -f2 |
		xargs -r "$EDITOR"
}
