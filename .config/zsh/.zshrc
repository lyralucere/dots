# Prompt & Colors
autoload -U colors && colors
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{white}  %b%f'
precmd() { vcs_info }
PS1="%B%F{white}[%F{red}%n%F{green}@%F{cyan}%M %F{magenta}%~%F{white}]%f\$vcs_info_msg_0_ %B$%b "

# History
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.cache/zsh/history
setopt share_history           # Share history between terminals

# Completion
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION
_comp_options+=(globdots)      # Include hidden files

# Fzf
source <(fzf --zsh)
fh() {
    fzf --style full \
        --preview 'bat --color=always {}' \
        --bind 'result:transform-list-label:
            if [[ -z $FZF_QUERY ]]; then
                echo " $FZF_MATCH_COUNT items "
            else
                echo " $FZF_MATCH_COUNT matches for [$FZF_QUERY] "
            fi
            ' \
        --bind 'focus:transform-preview-label:[[ -n {} ]] && printf " Previewing [%s] " {}' \
        --bind 'focus:+transform-header:file --brief {} || echo "No file selected"' \
        --color 'input-border:4,input-label:12' \
        --color 'list-border:2,list-label:10' \
        --color 'preview-border:6,preview-label:14' \
        --color 'header-border:5,header-label:13' \
        -m | xargs -r hx
}

# Alias'
alias vim="hx" # Typing 'vim' is muscle memory...
alias eh="mkdir -p ~/.cache/zsh && hx ~/.cache/zsh/history"

# Some precaution
rm-rf() {
    echo -n "rm -rf $@? Confirm (y/N): "
    read -r response
    if [[ "$response" =~ ^[yY] ]]; then
        command rm -rf "$@"
    else
        echo "Cancelled."
        return 1
    fi
}

# Vi Mode
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes
function zle-keymap-select {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # Block
        viins|main) echo -ne '\e[5 q';; # Beam
    esac
}
zle -N zle-keymap-select

zle-line-init() {
    zle -K viins
    echo -ne '\e[5 q'
}
zle -N zle-line-init
echo -ne '\e[5 q'  # Use beam shape cursor on startup
preexec() { echo -ne '\e[5 q' ;}

# Plugins
ZSH_PLUGIN_DIR="$HOME/.config/zsh/plugins"
source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>/dev/null
source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null

