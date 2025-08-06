#!/usr/bin/env bash

dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &

systemctl --user start hyprpolkitagent &

wlsunset -S 08:00 -s 19:00 -o eDP-1 &

hyprpaper &

hypridle &

waybar &

dunst &

