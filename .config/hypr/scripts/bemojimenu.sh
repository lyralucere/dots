#!/usr/bin/env bash

EMOJI_FILE="$HOME/.local/share/chars"

[ ! -f "$EMOJI_FILE" ] && {
    notify-send "Emoji file not found!"
    exit 1
}

COLOR_BACKGROUND="#101315"
COLOR_FOREGROUND="#efecea"
COLOR_HIGHLIGHT_BG="#efecea"
COLOR_HIGHLIGHT_FG="#101315"

chosen=$(cut -d ';' -f1 "$EMOJI_FILE" | bemenu \
    --ignorecase \
    --list 15 \
    --line-height 34 \
    --ch 20 \
    --cw 2 \
    --hp 10 \
    --fn "JuliaMono 10" \
    --tb "$COLOR_FOREGROUND" --tf "$COLOR_BACKGROUND" \
    --fb "$COLOR_BACKGROUND" --ff "$COLOR_FOREGROUND" \
    --nb "$COLOR_BACKGROUND" --nf "$COLOR_FOREGROUND" \
    --hb "$COLOR_HIGHLIGHT_BG" --hf "$COLOR_HIGHLIGHT_FG" \
    --prompt "")

[ -z "$chosen" ] && exit

emoji=$(echo "$chosen" | sed 's/ .*//')

printf "%s" "$emoji" | wl-copy
notify-send "'$emoji' copied to clipboard!"

