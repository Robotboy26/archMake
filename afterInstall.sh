sudo pacman -Syu
export XDG_RUNTIME_DIR=/run/user/$(id -u)

# remove unneeded packager

# setup yay wrapper for pacman for getting wanted packages
sudo pacman -S --needed git base-devel --noconfirm
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ..
sudo rm -r yay

# add wanted packages

# downloading hyperland // later build from src
yay -S hyprlang-git --noconfirm
yay -S hyprcursor-git --noconfirm
yay -S hyprland-git --noconfirm

# hyprland stuff
pacman -S kitty

# other default coniguration
