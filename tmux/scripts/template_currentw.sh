#!/usr/bin/env bash

selected_layout=$(ls $DOTFILES/tmux/templates |
    fzf --tmux top,45,10 -i --cycle
);

if [ -n "$selected_layout" ]; then
    tmux rename-window $(basename "#{pane_current_path}");
    $DOTFILES/tmux/templates/$selected_layout;
fi

