
#- CONVENIENCE -------------------------------------------------------------------------------------
#- configs specific to macos -----------------------------------------------------------------------

# List Files
alias l='eza -lag --color=always --group-directories-first --icons=always'
alias ls='eza -g --icons=always'
alias la='eza -a --color=always --group-directories-first --icons=always'
alias tree='eza -T --group-directories-first --icons=always -L'
alias treg='eza -T --group-directories-first --icons=always --git-ignore -L'

# Easier Calls
alias c='bat -n'
alias cat='bat -pp'
alias cp=ditto
alias htop=btop
alias ntop='sudo bandwhich'
alias systemctl="brew services"

# Open files with set default application
of() {
    dir="${1:-.}"

    open "$dir/$(
        find "$dir/" -maxdepth 1 -type f | \
            grep -o -E "[^/]*$" | \
            sort | \
            fzf --height=40% --border=rounded
    )"
}

# Fixed Path
i() { c ~/Projects/.Info/$1 }
alias vols="gt /Volumes/"

# Keyboard Remaps
fixkeyboard() {
    hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029 },{ "HIDKeyboardModifierMappingSrc":0x700000029,"HIDKeyboardModifierMappingDst":0x700000035 }] }'
}


#- Local Development -------------------------------------------------------------------------------

# mise actions
eval "$(mise activate zsh)"

# Claude Code
alias claude='bx claude'

# AntiGravity cli
ag() {
    local current_dir
    current_dir=$(pwd -P)

    local projects_dir
    projects_dir=$(cd "$HOME/Projects" 2>/dev/null && pwd -P)
    if [[ "$current_dir" != "$projects_dir"/* ]]; then
        echo "Security Block: AntiGravity can only be run INSIDE a project folder within ~/Projects/"
        echo "Current directory: $current_dir"
        return 1
    fi

    bx exec "$(pwd)" -- "$HOME/.local/binnotpath/neverrunantigravity"
}

# CoPilot cli
co() {
    local current_dir
    current_dir=$(pwd -P)

    local projects_dir
    projects_dir=$(cd "$HOME/Projects" 2>/dev/null && pwd -P)
    if [[ "$current_dir" != "$projects_dir"/* ]]; then
        echo "Security Block: Copilot can only be run INSIDE a project folder within ~/Projects/"
        echo "Current directory: $current_dir"
        return 1
    fi

    bx exec "$(pwd)" -- "$HOME/.local/binnotpath/neverruncopilot"
}


#- System Packages ---------------------------------------------------------------------------------

alias pkga='brew install'
alias pkgr='brew uninstall --zap'
alias pkgs='brew search'
alias pkgl='brew list'
alias pkgi='brew info'
alias pkgx='brew cleanup --prune=all'

alias update='
    figlet "System Packages";
    yes | brew upgrade;
    yes | brew update;

    figlet "Vim Plugins";
    $EDITOR --headless +"lua vim.pack.update()" +"wq" +qa;
    echo;

    figlet "System Cleanup";
    yes | brew cleanup --prune=all;
    yes | brew autoremove;
'

