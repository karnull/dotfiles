#!/usr/bin/env bash

#- environment -----------------------------------------------------------------

[[ -n "${TMUX:-}" ]] || {
    echo "Must be run from inside tmux"
    exit 1
}

set -euo pipefail

GHOST_SESSION="ghostnet"


#- helper functions ------------------------------------------------------------

ghost_todo_not_focused() {
    if [[ "$(tmux display-message -p -t "${GHOST_SESSION}:" '#{window_name}')" == "todo" ]]; then
        tmux display-message "action not permitted on \"todo\" window"
        exit 0
    fi
}

current_pane() {
    tmux display-message -p '#{pane_id}'
}

ghost_active_pane() {
    tmux display-message -p -t "${GHOST_SESSION}:" '#{pane_id}'
}


#- argument parsing ------------------------------------------------------------

case "${1:-}" in
    back)
        pane="$(current_pane)"
        title="$(date '+%d/%m %H:%M')"

        new_window="$(tmux break-pane \
            -s "$pane" \
            -t "${GHOST_SESSION}:" \
            -P -F '#{window_id}')"

        tmux rename-window -t "$new_window" "$title"
    ;;

    upl)
        ghost_todo_not_focused

        src_pane="$(ghost_active_pane)"
        dst_pane="$(current_pane)"

        tmux join-pane \
            -h \
            -s "$src_pane" \
            -t "$dst_pane"
    ;;

    upd)
        ghost_todo_not_focused

        src_pane="$(ghost_active_pane)"
        dst_pane="$(current_pane)"

        tmux join-pane \
            -v \
            -s "$src_pane" \
            -t "$dst_pane"
    ;;

    upn)
        ghost_todo_not_focused

        src_pane="$(ghost_active_pane)"
        dst_session="$(tmux display-message -p '#{session_name}')"

        tmux break-pane \
            -d \
            -s "$src_pane" \
            -t "${dst_session}:"
    ;;

    kill)
        ghost_todo_not_focused
        tmux kill-window -t ghostnet:
    ;;
esac

