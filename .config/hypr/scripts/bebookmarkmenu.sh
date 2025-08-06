#!/usr/bin/env bash

COLOR_BACKGROUND="#101315"
COLOR_FOREGROUND="#efecea"
COLOR_HIGHLIGHT_BG="#efecea"
COLOR_HIGHLIGHT_FG="#101315"

BOOKMARK_FILE="$HOME/.local/share/sync/bookmarks.txt"
BOOKMARK_DIR="$(dirname "$BOOKMARK_FILE")"

[ ! -d "$BOOKMARK_DIR" ] && mkdir -p "$BOOKMARK_DIR"
[ ! -f "$BOOKMARK_FILE" ] && touch "$BOOKMARK_FILE"

bemenu_cmd() {
    bemenu \
        --ignorecase \
        --line-height 34 \
        --list 15 \
        --ch 20 \
        --cw 2 \
        --hp 10 \
        --fn 'JuliaMono 10' \
        --tb "$COLOR_FOREGROUND" --tf "$COLOR_BACKGROUND" \
        --fb "$COLOR_BACKGROUND" --ff "$COLOR_FOREGROUND" \
        --cb "$COLOR_BACKGROUND" --cf "$COLOR_FOREGROUND" \
        --nb "$COLOR_BACKGROUND" --nf "$COLOR_FOREGROUND" \
        --hb "$COLOR_HIGHLIGHT_BG" --hf "$COLOR_HIGHLIGHT_FG" \
        --fbb "$COLOR_FOREGROUND" --fbf "$COLOR_BACKGROUND" \
        --sb "$COLOR_FOREGROUND" --sf "$COLOR_BACKGROUND" \
        --ab "$COLOR_BACKGROUND" --af "$COLOR_FOREGROUND" \
        --scb "$COLOR_BACKGROUND" --scf "$COLOR_FOREGROUND" \
        "$@"
}

get_title() {
    local url="$1"
    title=$(timeout 5 curl -s "$url" | grep -oP '(?<=<title>).*?(?=</title>)' | head -1 | sed 's/[[:space:]]*$//')
    
    if [ -z "$title" ]; then
        title=$(echo "$url" | sed -e 's|^[^/]*//||' -e 's|/.*$||')
    fi
    
    echo "$title"
}

add_bookmark() {
    url=$(bemenu_cmd -p "Enter URL" < /dev/null)
    
    if [ -z "$url" ]; then
        echo "No URL entered"
        return
    fi
    
    if [[ ! "$url" =~ ^https?:// ]]; then
        url="https://$url"
    fi
    
    echo "Fetching title..."
    title=$(get_title "$url")
    
    tags=$(bemenu_cmd -p "Tags (comma-separated)" < /dev/null)
    
    if [ -n "$tags" ]; then
        bookmark_entry="$title | $url | tags: $tags"
    else
        bookmark_entry="$title | $url"
    fi
    
    echo "$bookmark_entry" >> "$BOOKMARK_FILE"
    
    echo "Bookmark added: $title"
    notify-send "Bookmark Manager" "Added: $title" 2>/dev/null || true
}

view_bookmarks() {
    if [ ! -s "$BOOKMARK_FILE" ]; then
        echo "No bookmarks found" | bemenu_cmd -p "Bookmarks:"
        return
    fi
    
    selected=$(cat "$BOOKMARK_FILE" | bemenu_cmd -p "Select bookmark" -l 20)
    
    if [ -n "$selected" ]; then
        url=$(echo "$selected" | cut -d'|' -f2 | sed 's/^ *//;s/ *$//')
        
        xdg-open "$url" 2>/dev/null || sensible-browser "$url" 2>/dev/null || firefox "$url"
    fi
}

remove_bookmark() {
    if [ ! -s "$BOOKMARK_FILE" ]; then
        echo "No bookmarks to remove" | bemenu_cmd -p "Remove bookmark"
        return
    fi
    
    selected=$(cat "$BOOKMARK_FILE" | bemenu_cmd -p "Select bookmark to remove" -l 20)
    
    if [ -n "$selected" ]; then
        title=$(echo "$selected" | cut -d'|' -f1 | sed 's/^ *//;s/ *$//')
        
        confirm=$(echo -e "Yes\nNo" | bemenu_cmd -p "Are you sure?")
        
        if [ "$confirm" = "Yes" ]; then
            grep -v -F "$selected" "$BOOKMARK_FILE" > "$BOOKMARK_FILE.tmp"
            mv "$BOOKMARK_FILE.tmp" "$BOOKMARK_FILE"
            
            echo "Bookmark removed: $title"
            notify-send "Bookmark Manager" "Removed: $title" 2>/dev/null || true
        else
            echo "Removal cancelled"
            notify-send "Bookmark Manager" "Removal cancelled" 2>/dev/null || true
        fi
    fi
}

main_menu() {
    options="View bookmarks\nAdd bookmark\nRemove bookmark"
    choice=$(echo -e "$options" | bemenu_cmd -p "Bookmark Manager")
    
    case "$choice" in
        "View bookmarks")
            view_bookmarks
            ;;
        "Add bookmark")
            add_bookmark
            ;;
        "Remove bookmark")
            remove_bookmark
            ;;
    esac
}

main_menu

