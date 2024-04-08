# curl -o ~/wallpaper.png 'https://preview.redd.it/8xl10fn9mtf81.png?auto=webp&s=33c90219f68ee975d569cd432a30cca189ac942e'
wallpaperFile="images.txt"
if [ -f "$wallpaperFile" ]; then
    count = 0
    while IFS= read -r line; do
        filename="wallpaper$count.png"
        curl -o "$filename" "$line"
        if [ ! -f $filename ]; then
            echo "File not found: $filename"
            exit 1
        fi

        extension="${filename##*.}"
        new_filename="${filename%.*}.jpeg"

        if [ $extension != "jpg" ] && [ $extension != "jpeg" ]; then
            echo "Converting $filename to $new_filename..."
            convert $filename $new_filename
            echo "Conversion successful!"
        else
            echo "File is already in JPEG format."
        fi
        ((count++))
    done < "$wallpaperFile"
fi

# write the hyprpaper file with wallpaper stuff
