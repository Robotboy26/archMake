# curl -o ~/wallpaper.png 'https://preview.redd.it/8xl10fn9mtf81.png?auto=webp&s=33c90219f68ee975d569cd432a30cca189ac942e'
wallpaperFile="images.txt"
if [ -f "$wallpaperFile" ]; then
    count = 0
    while IFS= read -r line; do
        filename="wallpaper$count.png"
        curl -o "$filename" "$line"
        ((count++))
    done < "$wallpaperFile"
fi

# write the hyprpaper file with wallpaper stuff
