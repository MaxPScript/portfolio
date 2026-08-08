#!/usr/bin/env bash

IMAGE_DIR="assets/images/standard"
HTML_FILE="index.html"

generated=""

for image in "$IMAGE_DIR"/*; do
    case "$image" in
        *.jpg|*.jpeg|*.png|*.gif|*.webp)
            filename=$(basename "$image")
            name="${filename%.*}"

            generated+="    <img src=\"$image\" alt=\"$name\">\n"
            ;;
    esac
done

awk -v content="$(printf '%b' "$generated")" '
    /<!-- GALLERY:START -->/ {
        print
        printf "%s\n", content
        inside=1
        next
    }

    /<!-- GALLERY:END -->/ {
        inside=0
        print
        next
    }

    !inside {
        print
    }
' "$HTML_FILE" > "$HTML_FILE.tmp" && mv "$HTML_FILE.tmp" "$HTML_FILE"

echo "Gallery updated successfully."
