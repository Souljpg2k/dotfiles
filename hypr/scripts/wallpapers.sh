#!/bin/bash

shopt -s nullglob nocaseglob

WALL_DIR="$HOME/Wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper_thumbs"
ROFI_CONFIG="$HOME/.config/rofi/config.rasi"

mkdir -p "$CACHE_DIR"

process_img() {
    local img="$1"
    local thumb="$2"

    convert "$img" -thumbnail 250x250^ -gravity center -extent 250x250 \
        \( +clone -alpha extract \
           -draw "fill black polygon 0,0 0,250 250,250 250,0 fill white roundrectangle 0,0 250,250 30,30" \
           -alpha off \) -alpha off -compose CopyOpacity -composite "$thumb"
}

export -f process_img

LIST_DATA=""

for img in "$WALL_DIR"/*.{jpg,jpeg,png,webp}; do
    filename=$(basename "$img")
    thumb="$CACHE_DIR/${filename%.*}.png"
    
    if [ ! -f "$thumb" ] || [ "$img" -nt "$thumb" ]; then
        process_img "$img" "$thumb" & 
        
        if [[ $(jobs -r | wc -l) -ge 8 ]]; then wait -n; fi
    fi
    
    LIST_DATA+="${filename}\x00icon\x1f${thumb}\n"
done

wait

CHOICE=$(echo -e -n "$LIST_DATA" | rofi -dmenu \
    -p "Select Wallpaper" \
    -config "$ROFI_CONFIG" \
    -show-icons \
    -theme-str '
        window { width: 50%; }
        listview { columns: 4; lines: 1; layout: vertical; flow: horizontal; fixed-columns: true; spacing: 15px; }
        element { orientation: vertical; padding: 10px; }
        element-icon { size: 130px;  }
        element-text { horizontal-align: 0.5; }
    ')

if [ -n "$CHOICE" ]; then
    FULL_PATH="$WALL_DIR/$CHOICE"
    awww img "$FULL_PATH" --transition-type center --transition-fps 60 --transition-duration 2
    matugen image "$FULL_PATH" --prefer saturation
fi