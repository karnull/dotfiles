
#- Initialise ------------------------------------------------------------------
#- initialise common defaults --------------------------------------------------

# Global Variables -------------------------------------------------------------

# ZSH history
HISTFILE="$HOME/.local/share/zhistory"
HISTSIZE=1000
SAVEHIST=1000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

export FZF_DEFAULT_OPTS="-i --cycle --ansi --color=dark --layout=reverse\
    --pointer='▶ ' --prompt='  '"
export FZF_DEFAULT_COMMAND='find . -maxdepth 1 ! -path "*git*"'
export GPG_TTY=$(tty)


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
    autoload -Uz compinit
    compinit -C "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

    # Fetch when not in TMux
    [[ -z "$TMUX" ]] && bash ~/.config/fetch.sh

    # fzf
    zsh-defer eval "$(fzf --zsh)"
'

