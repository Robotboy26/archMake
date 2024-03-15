sudo pacman -Syu --noconfirm

# Setup yay wrapper for pacman for getting wanted packages
sudo pacman -S --needed git base-devel --noconfirm
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
sudo rm -r yay

# Install Wayland for Hyprland
yay -S wayland weston wlroots --noconfirm
echo "Wayland install complete."

# Compile hyprland
yay -S hyprlang-git --noconfirm
yay -S hyprcursor-git --noconfirm

yay -S gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender pixman wayland-protocols xorg-xwayland cairo pango seatd libxkbcommon xcb-util-wm libinput libliftoff libdisplay-info cpio tomlplusplus --noconfirm

git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
make all -j$(nproc) CONFIG_XORG=OFF
sudo make install
echo "Hyprland install complete."

# Hyprland stuff
yay -S kitty-git waybar-git --noconfirm

# Wget and copy over config files
cd ~
git clone https://github.com/Robotboy26/archMake.git

mkdir -p ~/.config/kitty
mkdir -p ~/.config/waybar
mkdir -p ~/.config/hypr

cp ~/archMake/structure/config/kitty ~/.config/kitty
cp ~/archMake/structure/config/waybar ~/.config/waybar
cp ~/archMake/structure/config/hypr/* ~/.config/hypr

# Setup wallpaper
curl -o ~/wallpaper.png 'https://preview.redd.it/8xl10fn9mtf81.png?auto=webp&s=33c90219f68ee975d569cd432a30cca189ac942e'


# Cleanup
cd ..
sudo rm -r ~/archMake

# setup zsh and ohmyzsh
yay -S zsh --noconfirm
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # ohmyzsh

# Install editors
yay -S vi vim neovim --noconfirm

# Install webbrowsers
yay -S brave-bin firefox --noconfirm

yay -S neofetch --noconfirm # Because why not

# Install fonts
yay -S  otf-font-awesome ttf-arimo-nerd noto-fonts --noconfirm # remove unwanted this is just temp

# Remove unwanted packages

# curl unwanted packages list
unwantedPackages="unwantedPackages.txt"
# if [ -f "$unwantedPackages" ]; then
# 	while IFS= read -r line; do
# 	    yay -R "$line" --noconfirm
# 	done < "$unwantedPackages"
# fi

# Other default coniguration
