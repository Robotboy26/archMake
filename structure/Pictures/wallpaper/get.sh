wallpaperFile="images.txt"
if [ -f "$wallpaperFile" ]; then
    count = 0
    while IFS= read -r line; do
        filename="wallpaper$count"
        curl -o "$filename" "$line"
        ((count++))
    done < "$wallpaperFile"
fi
