#- Initialise ------------------------------------------------------------------
#- initialise common defaults --------------------------------------------------

# Global Variables -------------------------------------------------------------

# ZSH history
HISTFILE="$HOME/.local/share/zhistory"
HISTSIZE=1000
SAVEHIST=1000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

# XDG cache (completion dump and completion cache live here)
: ${XDG_CACHE_HOME:="$HOME/.cache"}
export XDG_CACHE_HOME
[[ -d "$XDG_CACHE_HOME/zsh" ]] || mkdir -p "$XDG_CACHE_HOME/zsh"

export FZF_DEFAULT_OPTS="-i --cycle --ansi --color=dark --layout=reverse\
    --pointer='▶ ' --prompt='  '"
export FZF_DEFAULT_COMMAND='find . -maxdepth 1 ! -path "*git*"'
export FZF_ALT_C_COMMAND=""
export GPG_TTY=$TTY     # $TTY is a zsh param: no fork, unlike $(tty)


# Integrations -----------------------------------------------------------------

# Plugins
source "$DOTFILES/zplugins/defer/zsh-defer.plugin.zsh"
zsh-defer source "$DOTFILES/zplugins/highlighting/zsh-syntax-highlighting.zsh"
zsh-defer source "$DOTFILES/zplugins/devedit/devedit.zsh"

# Other Configs
source "$DOTFILES/zsh/prompt.zsh"
zsh-defer source "$DOTFILES/zsh/navigations.zsh"  # file processing
zsh-defer source "$DOTFILES/zsh/defines.zsh"      # common basic defines
zsh-defer source "$DOTFILES/zsh/management.zsh"   # manage config files
zsh-defer source "$DOTFILES/zsh/convenience.zsh"  # aliases & keybinds
zsh-defer source "$DOTFILES/zsh/devenv.zsh"       # development shortcuts
zsh-defer source "$DOTFILES/zsh/projects.zsh"     # pinit, pupdate, bench
zsh-defer source "$DOTFILES/zsh/hacks.zsh"        # :)

# other modules to lazy load
zsh-defer -t 0 -c '
    # more advanced auto-complete behavirour
    zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
    zstyle ":completion:*" menu select
    zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
    zstyle ":completion:*" use-cache on
    zstyle ":completion:*" cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

    # -d is the only way to place the dump file. A bare path argument ends
    # compinit option parsing and is dropped, so the dump would land in
    # ~/.zcompdump. Dropping -C also means new completions get picked up.
    autoload -Uz compinit
    compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

    # Fetch when not in TMux
    [[ -z "$TMUX" && -r "$DOTFILES/fetch.sh" ]] && bash "$DOTFILES/fetch.sh"

    # fzf
    zsh-defer eval "$(fzf --zsh)"
'
