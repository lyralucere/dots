#!/usr/bin/env bash

CURRENT_PROFILE=$(powerprofilesctl get)

case $CURRENT_PROFILE in
    "balanced")
        NEXT_PROFILE="performance"
        ICON="🚀"
        ;;
    "performance")
        NEXT_PROFILE="power-saver"
        ICON="🔋"
        ;;
    "power-saver")
        NEXT_PROFILE="balanced"
        ICON="⚖️"
        ;;
    *)
        # fallback in case of an unexpected state
        NEXT_PROFILE="balanced"
        ICON="❓"
        ;;
esac

powerprofilesctl set $NEXT_PROFILE
notify-send "Power Profile" "Switched to: $ICON $NEXT_PROFILE"

