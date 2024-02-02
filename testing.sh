#!/bin/bash

# Verify if the script is being run with sudo/root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run the script with sudo or as root!"
    exit
fi

# Check if drive name is provided as argument
if [ -z "$1" ]; then
    echo "Please provide the drive name as an argument, e.g., /dev/sdb"
    exit
fi

# Store the drive name provided as argument
drive="$1"

# Display a warning message before starting the process
echo "WARNING: This script will erase all data on the selected drive. Make sure you have backed up any important data. Do you want to continue? (y/n)"
read -r response

# Check for user confirmation
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    # Create GPT partition table and partitions using sgdisk
    sgdisk --zap-all "$drive" # Delete existing partition table if any
    sgdisk -n 1:0:+512M -t 1:EF00 -c 1:"EFI System Partition" "$drive" # EFI System Partition
    sgdisk -n 2:0:0 -t 2:8300 -c 2:"Linux Filesystem" "$drive" # Linux Filesystem

    # Format the partitions
    mkfs.fat -F32 "${drive}1" # FAT32 for boot partition
    mkfs.ext4 "${drive}2"   # ext4 for Arch partition

    # Mount the partitions
    mount "${drive}2" /mnt
    mkdir /mnt/boot
    mount "${drive}1" /mnt/boot

    # Install Arch Linux base system
    pacstrap /mnt base

    # Generate an fstab file
    genfstab -U /mnt >> /mnt/etc/fstab

    # Change root to the new system
    arch-chroot /mnt

    # Install bootloader (e.g., GRUB) and necessary packages
    pacman -S grub efibootmgr dosfstools os-prober mtools
    grub-install --target=x86_64-efi --bootloader-id=arch_grub --recheck
    grub-mkconfig -o /boot/grub/grub.cfg

    # Set a password for the root user
    echo "Please enter a password for the root user:"
    passwd

    echo "Installation complete. You can now reboot the system!"
else
    echo "Installation process aborted."
    exit
fi
