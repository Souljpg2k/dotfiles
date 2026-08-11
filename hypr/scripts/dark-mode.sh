#!/bin/bash

THEME_FILE="$HOME/.config/quickshell/Appearance/dark.txt"
WP=$(cat "$HOME/.cache/current_wallpaper")

current=$(cat "$THEME_FILE")

if [ "$current" = "true" ]; then
    echo "false" > "$THEME_FILE"
    matugen image "$WP" --mode light --source-color-index 0
else
    echo "true" > "$THEME_FILE"
    matugen image "$WP" --mode dark --source-color-index 0
fi