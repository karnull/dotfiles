#!/usr/bin/env bash
#
# Bootstrap a system worktree layout:
#   <repo>/        -> sys/<name> branch (system-specific configs + symlinks)
#   <repo>/generic -> main branch       (shared configs)
#
# Symlinks for the known systems (wsl, darwin) already live on their branches
# and point into ./generic. For a brand-new system the script only sets up the
# branch + generic worktree; symlinks are left to be created manually.

# Wrap everything in a brace block so bash reads the whole script before any
# branch switch swaps the file out from under it.
{
    set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel)"
cd "$REPO_DIR"

if [[ -e generic ]]; then
    echo "error: ./generic already exists in $REPO_DIR" >&2
    exit 1
fi

current_branch="$(git symbolic-ref --quiet --short HEAD || echo "")"
if [[ "$current_branch" != "main" ]]; then
    echo "error: install.sh must be run from the 'main' branch (currently: ${current_branch:-detached})" >&2
    exit 1
fi

echo "Select system to configure:"
PS3="> "
select choice in wsl darwin new quit; do
    case "${choice:-}" in
        wsl|darwin)
            branch="sys/$choice"
            echo ":: fetching origin/$branch"
            git fetch origin "$branch:$branch" 2>/dev/null \
                || git fetch origin "$branch"

            echo ":: switching root to $branch"
            # Switch primary checkout to the system branch first, so 'main'
            # is free to be attached as a worktree.
            git switch "$branch"

            echo ":: adding ./generic worktree tracking main"
            git worktree add generic main
            break
            ;;

        new)
            read -r -p "New system name (without 'sys/' prefix): " name
            name="${name// /}"
            if [[ -z "$name" ]]; then
                echo "error: name required" >&2
                exit 1
            fi

            branch="sys/$name"
            if git show-ref --verify --quiet "refs/heads/$branch"; then
                echo "error: branch '$branch' already exists" >&2
                exit 1
            fi

            echo ":: creating $branch from main"
            git switch -c "$branch"

            echo ":: adding ./generic worktree tracking main"
            git worktree add generic main

            echo
            echo "done. Branch '$branch' is checked out at $REPO_DIR."
            echo "Set up symlinks into ./generic manually, then commit them."
            break
            ;;

        quit)
            echo "aborted"
            exit 0
            ;;

        *)
            echo "invalid selection"
            ;;
    esac
done

echo
git worktree list
exit 0
}
