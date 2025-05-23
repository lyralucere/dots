#!/usr/bin/bash

# Define colour variables
COLOR_BACKGROUND="#05080a"
COLOR_FOREGROUND="#faedff"
COLOR_HIGHLIGHT_BG="#faedff"
COLOR_HIGHLIGHT_FG="#05080a"

# Run j4-dmenu-desktop with bemenu
j4-dmenu-desktop --dmenu="bemenu \
    --ignorecase \
    --line-height 34 \
    --ch 20 \
    --cw 2 \
    --hp 10 \
    --fn 'JuliaMono 12' \
    --tb \"$COLOR_FOREGROUND\" --tf \"$COLOR_BACKGROUND\" \
    --fb \"$COLOR_BACKGROUND\" --ff \"$COLOR_FOREGROUND\" \
    --cb \"$COLOR_BACKGROUND\" --cf \"$COLOR_FOREGROUND\" \
    --nb \"$COLOR_BACKGROUND\" --nf \"$COLOR_FOREGROUND\" \
    --hb \"$COLOR_HIGHLIGHT_BG\" --hf \"$COLOR_HIGHLIGHT_FG\" \
    --fbb \"$COLOR_FOREGROUND\" --fbf \"$COLOR_BACKGROUND\" \
    --sb \"$COLOR_FOREGROUND\" --sf \"$COLOR_BACKGROUND\" \
    --ab \"$COLOR_BACKGROUND\" --af \"$COLOR_FOREGROUND\" \
    --scb \"$COLOR_BACKGROUND\" --scf \"$COLOR_FOREGROUND\""
