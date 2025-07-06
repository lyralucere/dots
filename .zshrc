# Prompt & Colors
autoload -U colors && colors
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats ' %F{white}  %b%f'
precmd() { vcs_info }
PS1="%B%F{white}[%F{red}%n%F{green}@%F{cyan}%M %F{magenta}%~%F{white}]%f\$vcs_info_msg_0_ %B$%b "

# History Settings
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.cache/zsh/history
setopt hist_ignore_all_dups    # Ignore duplicate commands
setopt share_history           # Share history between terminals
setopt extended_history        # Save timestamps

# Completion System
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION
_comp_options+=(globdots)      # Include hidden files

# General Alias'
alias vim="hx" # Typing 'vim' is muscle memory, so...
alias eh="mkdir -p ~/.cache/zsh && cd ~/.cache/zsh && hx history"
alias ff="fastfetch"

# Safety-First Alias'
alias rm="rm -i"

# Explicit safe version (use 'rm-rf' instead of 'rm -rf')
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
ZSH_PLUGIN_DIR="$HOME/.config/zsh"
source "$ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" 2>/dev/null
source "$ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" 2>/dev/null

