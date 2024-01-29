#!/bin/bash
modes=(
    "Automatic"
    "Manual small"
    "Manual full"
)
# Array to store package names
packages=(
    "package1"
    "package2"
    "package3"
)

# Array to store configuration options
options=(
    "option1"
    "option2"
    "option3"
)

for ((i=0; i<${#modes[@]}; i++)); do
    echo "$i. ${modes[$i]}"
done
read -p "Select install mode " selectedMode

IFS=',' read -ra modeIndices <<< "$selectedMode"
for index in "${modeIndices[@]}"; do
    echo "${modes[$index]}"
    if [[ "${modes[$index]}" = "Automatic" ]]; then
        echo "Automatic install selected"
        echo "It is not yet fully auto"
        # full auto install (based on my setup)


        # us keymap
        loadkeys us
        # try to connect over eth
        ip link
        if ! ping -c 1 www.google.com &> /dev/null; then
            echo "Make sure that you are connected to the internet!"
            exit
        fi
        echo "Thank you for being connected to the internet!"

        echo "you will now select all of the configuration settings"
        lsblk
        read -p "Type the disk you want to use (This will erase all data on the disk)(format '/dev/<disk>'): " selectedDisk
        read -p "Type the user name: " username
        read -p "Type the user password: " password
        read -p "root password: " rootPassword

        # set time and date over eth
        timedatectl

        # still manual setup for disk ):
        # echo "Example disk configuration:"
        # echo "lsblk # show disks"
        # echo "Example layout:"
        # echo "/mnt/boot /dev/efiSystemPartition about 400mb"
        # echo "[SWAP] /dev/spawPartition about 4GB"
        # echo "/mnt dev/rootPatition about 32GB"
        # echo "fdisk <disk you want>"

        # stuff on formating
        
        # mount filesystem


        # Create partitions
        parted $selectedDisk mklabel gpt
        parted $selectedDisk mkpart ESP fat32 1MiB 513MiB       # EFI partition (512MB)
        parted $selectedDisk set 1 esp on
        parted $selectedDisk mkpart primary linux-swap 513MiB 4.5GiB   # Swap partition (4GB)
        parted $selectedDisk mkpart primary ext4 4.5GiB 36.5GiB  # Root partition (32GB)
        parted $selectedDisk mkpart primary ext4 36.5GiB 100%    # Home partition (remaining space)

        # Format partitions
        mkfs.fat -F32 ${selectedDisk}1    # EFI partition
        mkswap ${selectedDisk}2           # Swap partition
        mkfs.ext4 ${selectedDisk}3        # Root partition
        mkfs.ext4 ${selectedDisk}4        # Home partition

        # Mount partitions
        mount ${selectedDisk}3 /mnt
        mkdir /mnt/boot
        mount ${selectedDisk}1 /mnt/boot
        swapon ${selectedDisk}2
        mkdir /mnt/home
        mount ${selectedDisk}4 /mnt/home

        echo "Click <ctrl-z> and setup the disk, after you are done write fg to the term and the script will continue"

        # install essential packages
        sudo pacman -Sy # init pacman
        # to install rank mirrors (I do not want this because I will setup a vpn)
        # sudo pacman -S pacman-contrib
        # rankmirrors -n 6 /etc/pacman.d/mirrorlist
        pacstrap -K /mnt base linux linux-firmware
        genfstab -U /mnt >> /mnt/etc/fstab
        arch-chroot /mnt
        hwclock --systohc

        # set lang and stuff
        sudo sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
        sudo locale-gen
        echo 'LANG=en_US.UTF-8' | sudo tee /etc/locale.conf
        echo 'KEYMAP=us' | sudo tee /etc/vconsole.conf

        # setup network
        echo "hostname" > /etc/hostname

        mkinitcpio -P
        # find a way to pass a arg
        passwd


        


        exit 0
    fi
done

read -p "Enter option numbers to configure (comma-separated): " selected_options
echo "Select packages to install:"
for ((i=0; i<${#packages[@]}; i++)); do
    echo "$i. ${packages[$i]}"
done
read -p "Enter package numbers to install (comma-separated): " selected_packages

echo "Select configuration options:"
for ((i=0; i<${#options[@]}; i++)); do
    echo "$i. ${options[$i]}"
done
read -p "Enter option numbers to configure (comma-separated): " selected_options
# Install selected packages
IFS=',' read -ra package_indices <<< "$selected_packages"
for index in "${package_indices[@]}"; do
    package=${packages[$index]}
    echo "Installing package: $package"
    sudo apt-get install $package
done

# Configure selected options
IFS=',' read -ra option_indices <<< "$selected_options"
for index in "${option_indices[@]}"; do
    option=${options[$index]}
    echo "Configuring option: $option"
    # Perform the desired configuration action based on the selected option
    # ...
done
