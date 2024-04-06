if [ "$(id -u)" -eq 0 ]; then
  echo "Thank you for running with sudo"
else
  echo "Please run the script with sudo"
  exit
fi

# Disable stupid pc beeper
sudo rmmod pcspkr

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
yay -S kitty-git waybar-git lf-git --noconfirm

# Install the git version of some things
yay -S hyprpaper-git --noconfirm

# Wget and copy over config files
cd ~
git clone https://github.com/Robotboy26/archMake.git

mkdir -p ~/Trash

mkdir -p ~/.config/hypr
mkdir -p ~/.config/kitty
mkdir -p ~/.config/lf
mkdir -p ~/.config/waybar

cp ~/archMake/structure/.zshrc ~/.zshrc
cp ~/archMake/structure/config/hypr/* ~/.config/hypr/
cp ~/archMake/structure/config/kitty/* ~/.config/kitty/
cp ~/archMake/structure/config/if/* ~/.config/lf/
cp ~/archMake/structure/config/waybar/* ~/.config/waybar/


# Wallpapers
cp -r archMake/structure/Picture ~/

# Cleanup
cd ~
mkdir -p ~/git
mv ~/archMake ~/git/

# Get man's
yay -S man-db tldr --noconfirm

# Setup network
yay -S ufw --noconfirm
sudo ufw enable

sudo systemctl start iwd
sudo systemctl enable iwd

# Power stuff
yay -S tlp --noconfirm
sudo tlp start
sudo systemctl enable tlp

# For better power saving
echo '1500' > sudo '/proc/sys/vm/dirty_writeback_centisecs';

# For viewing power stuff
yay -S powertop --noconfirm

# Laptop screen brightness
yay -S brightnessctl --noconfirm

# Install editors
yay -S vi vim neovim --noconfirm

# Better cd?
yay -S zoxide --noconfirm

# Neovim setup
cd ~
git clone https://github.com/Robotboy26/neovimconf
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
cp -r ~/.neovimconf/nvim ~/.config/
nvim --headless ~/.config/nvim/lua/robot/packer.lua -c ":so" -c ":PackerSync" -c ":q"
rm -r ~/neovimconf

# Other terminal stuff
yay -S tmux icat --noconfirm

# Install webbrowsers
yay -S brave-bin firefox --noconfirm

yay -S neofetch --noconfirm # Because why not

# Install fonts
yay -S  otf-font-awesome ttf-arimo-nerd noto-fonts --noconfirm # remove unwanted this is just temp

# Remove unwanted packages

unwantedPackages="unwantedPackages.txt"
# if [ -f "$unwantedPackages" ]; then
# 	while IFS= read -r line; do
# 	    yay -R "$line" --noconfirm
# 	done < "$unwantedPackages"
# fi

# Setup zsh and ohmyzsh
yay -S zsh --noconfirm
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # ohmyzsh

# Update the system
yay -Syu --noconfirm

# install nix
