sudo pacman -Syu
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# Remove unneeded packager

# Setup yay wrapper for pacman for getting wanted packages
sudo pacman -S --needed git base-devel --noconfirm
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
sudo rm -r yay

# Add wanted packages

# Install Wayland for Hyprland
yay -S wayland weston wlroots --noconfirm
echo "Wayland install complete."

# Compile hyprland
yay -S hyprlang-git --noconfirm
yay -S hyprcursor-git --noconfirm

yay -S gdb ninja gcc cmake meson libxcb xcb-proto xcb-util xcb-util-keysyms libxfixes libx11 libxcomposite xorg-xinput libxrender pixman wayland-protocols cairo pango seatd libxkbcommon xcb-util-wm xorg-xwayland libinput libliftoff libdisplay-info cpio tomlplusplus

# yay -S hyprland-git --noconfirm

echo "Hyprland install complete."

# Hyprland stuff

# Other default coniguration
