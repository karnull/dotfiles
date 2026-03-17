
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
    alias TML="tmux ls | fzf --height=30% --border=rounded | cut -f 1 -d ':' 2>/dev/null"

    if [ -n "$TMUX" ]; then
        echo "Sessions Switch"
        session=$(TML);

        if [ -n "$session" ]; then
            tmux switch-client -t "$session";
        fi

    elif [ -n "$(tmux ls 2>/dev/null)" ]; then
        echo "Session Connect"
        tmux attach-session -t $(TML) 2>/dev/null

    else
        echo "Session Create"
        tmux
    fi
}

# Git-----------------------------------------------------------------------------------------------

alias gedit="$EDITOR $DOTFILES/gitconfig"

