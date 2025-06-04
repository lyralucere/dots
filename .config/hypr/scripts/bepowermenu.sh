#!/usr/bin/bash

COLOR_BACKGROUND="#05080a"
COLOR_FOREGROUND="#faedff"
COLOR_HIGHLIGHT_BG="#faedff"
COLOR_HIGHLIGHT_FG="#05080a"

choice=$(printf "Lock\nSuspend\nLogout\nReboot\nShutdown" | bemenu \
    --ignorecase \
    --line-height 34 \
    --ch 20 \
    --cw 2 \
    --hp 10 \
    --fn "JuliaMono 12" \
    --tb "$COLOR_FOREGROUND" --tf "$COLOR_BACKGROUND" \
    --fb "$COLOR_BACKGROUND" --ff "$COLOR_FOREGROUND" \
    --nb "$COLOR_BACKGROUND" --nf "$COLOR_FOREGROUND" \
    --hb "$COLOR_HIGHLIGHT_BG" --hf "$COLOR_HIGHLIGHT_FG" \
    --prompt "Uptime: $(uptime -p | sed 's/up //')" \
)

case "$choice" in
    "Lock") hyprlock ;;
    "Suspend") hyprlock & disown && systemctl suspend ;;
    "Logout") loginctl terminate-user "$USER" ;;
    "Reboot") systemctl reboot ;;
    "Shutdown") systemctl poweroff ;;
    *) exit 1 ;;
esac
