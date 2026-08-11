#!/bin/bash
set -euo pipefail
shopt -s nullglob nocaseglob

W="$HOME/Wallpapers"
C="$HOME/.cache/wallpaper_thumbs"
mkdir -p "$C"

L=""

for img in "$W"/*.{jpg,jpeg,png,webp,gif,bmp,pnm,tga,tiff}; do
    f="${img##*/}"
    t="$C/${f}.png"

    if [ "$img" -nt "$t" ]; then
        magick "${img}[0]" \
            -thumbnail 300x300^ \
            -gravity center \
            -extent 300x300 \
            \( +clone -alpha extract \
               -draw "fill black polygon 0,0 0,300 300,300 300,0 fill white roundrectangle 0,0 300,300 24,24" \
               -alpha off \) \
            -compose CopyOpacity -composite "$t" &
    fi

    (( $(jobs -p | wc -l) >= 8 )) && wait -n

    L+="${f}\x00icon\x1f${t}\n"
done
wait

if [ -z "$L" ]; then
    notify-send "Wallpaper Picker" "No wallpapers found in $W" 2>/dev/null || true
    exit 1
fi

CHOICE=$(printf "%b" "$L" | rofi -dmenu -p ' ' -theme "$HOME/.config/rofi/wallpapers.rasi")

[ -z "$CHOICE" ] && exit 0

WALLPAPER="$W/$CHOICE"

awww img "$WALLPAPER" \
    --transition-type random \
    --transition-fps 60 \
    --transition-duration 2

echo "$WALLPAPER" > "$HOME/.cache/current_wallpaper"

if grep -qx "true" "$HOME/.config/quickshell/Appearance/dark.txt" 2>/dev/null; then
    MODE="dark"
else
    MODE="light"
fi

matugen image "$WALLPAPER" --mode "$MODE"  --source-color-index 0