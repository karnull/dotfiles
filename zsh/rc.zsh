#
#-------------------------------------------------------------------------------
#            _
#    _______| |__  _ __ ___
#   |_  / __| '_ \| '__/ __|
#  _ / /\__ | | | | | | (__
# (_/___|___|_| |_|_|  \___|
#-------------------------------------------------------------------------------
#-------------------------------------------------------------------------------

# System specific configs
export DOTFILES="${${(%):-%N}:A:h:h}"   # path for system configs
export EDITOR=nvim

# PATH. `typeset -U` keeps it deduplicated, so no guard is needed and
# re-sourcing .zshrc is harmless.
typeset -U path
path=("$HOME/.local/bin" $path)


# Initialise the system
source "$DOTFILES/zsh/init.zsh"

