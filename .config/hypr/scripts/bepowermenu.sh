#!/usr/bin/env bash

COLOR_BACKGROUND="#101315"
COLOR_FOREGROUND="#efecea"
COLOR_HIGHLIGHT_BG="#efecea"
COLOR_HIGHLIGHT_FG="#101315"

choice=$(printf "Lock\nSuspend\nLogout\nReboot\nShutdown" | bemenu \
    --ignorecase \
    --line-height 34 \
    --ch 20 \
    --cw 2 \
    --hp 10 \
    --fn "JuliaMono 10" \
    --tb "$COLOR_FOREGROUND" --tf "$COLOR_BACKGROUND" \
    --fb "$COLOR_BACKGROUND" --ff "$COLOR_FOREGROUND" \
    --nb "$COLOR_BACKGROUND" --nf "$COLOR_FOREGROUND" \
    --hb "$COLOR_HIGHLIGHT_BG" --hf "$COLOR_HIGHLIGHT_FG" \
    --prompt "$(uptime -p | sed 's/up //' | sed 's/minute[s]*/mins/g; s/hour[s]*/hrs/g')" \
)

case "$choice" in
    "Lock") hyprlock ;;
    "Suspend") hyprlock & disown; sleep 0.5 && systemctl suspend ;;
    "Logout") loginctl terminate-user "$USER" ;;
    "Reboot") systemctl reboot ;;
    "Shutdown") systemctl poweroff ;;
    *) exit 1 ;;
esac

