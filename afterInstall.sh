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

# Setup gpu drivers
# Check if NVIDIA GPU is present
lspci | grep -i nvidia &> /dev/null
if [ $? -eq 0 ]; then
    GPU="nvidia"
fi

# Check if Intel GPU is present
lspci | grep -i intel &> /dev/null
if [ $? -eq 0 ]; then
    GPU="intel"
fi

# Check if AMD GPU is present
lspci | grep -i amd &> /dev/null
if [ $? -eq 0 ]; then
    GPU="amd"
fi

# Install open-source drivers based on GPU type using yay with -git versions
case $GPU in
    nvidia)
        yay -S nvidia-git
        ;;
    intel)
        yay -S xf86-video-intel-git
        ;;
    amd)
        yay -S xf86-video-amdgpu-git
        ;;
    *)
        echo "No supported GPU found."
        ;;
esac

# Add wanted packages

# Compile hyprland
yay -S hyprlang-git --noconfirm
yay -S hyprcursor-git --noconfirm
yay -S hyprland-git --noconfirm

# Hyprland stuff

# Other default coniguration
