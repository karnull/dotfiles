#!/usr/bin/env bash

session=$(
    tmux ls |
    grep -v 'keepalive' |
    fzf --tmux 85,15 -i --layout=reverse --cycle |
    cut -f 1 -d ":"
);

if [ -n "$session" ]; then
     tmux switch-client -t "$session";
fi

