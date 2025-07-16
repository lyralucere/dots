#!/usr/bin/env bash

# Desired ON and OFF values
GAPS_ON="5 5 5 5"
GAPS_OUT_ON=10
GAPS_OFF="0 0 0 0"

# Get current gaps_in value
CURRENT_GAPS=$(hyprctl getoption general:gaps_in | grep "custom type:" | awk -F': ' '{print $2}')

# Toggle based on current value
if [ "$CURRENT_GAPS" = "$GAPS_OFF" ]; then
    # Turn gaps ON
    hyprctl keyword general:gaps_in "$GAPS_ON"
    hyprctl keyword general:gaps_out "$GAPS_OUT_ON"
else
    # Turn gaps OFF
    hyprctl keyword general:gaps_in "$GAPS_OFF"
    hyprctl keyword general:gaps_out 0
fi

