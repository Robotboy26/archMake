sudo pacman -Syu --noconfirm
# Remove unneeded packager

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

yay -S gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus --noconfirm

git clone --recursive https://github.com/hyprwm/Hyprland
cd Hyprland
make all -j$(nproc) CONFIG_XORG=OFF
sudo make install
echo "Hyprland install complete."

# Hyprland stuff
yay -S kitty-git --noconfirm
yay -S firefox --noconfirm

# Install wanted
yay -S vim neovim --noconfirm

# Other default coniguration
