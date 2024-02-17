#!/bin/bash

# Check if a drive number is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <drive_number>"
    exit 1
fi

# Assign the drive number from the argument
DRIVE="/dev/sd$1"

echo "Creating partitions on $DRIVE..."
# Create a simple partition layout (one boot partition and one root partition)
parted -s $DRIVE mklabel gpt
parted -s $DRIVE mkpart primary 1MB 513MB
parted -s $DRIVE set 1 boot on
parted -s $DRIVE mkpart primary 513MB 100%

# Format the boot partition with FAT32
mkfs.fat -F32 ${DRIVE}1

# Format the root partition with ext4
mkfs.ext4 ${DRIVE}2

# Mount the root partition to /mnt
mount ${DRIVE}2 /mnt

echo "Installing Arch Linux base system..."
# Install the base system using pacstrap
pacstrap /mnt base

# Generate an fstab file
genfstab -U /mnt >> /mnt/etc/fstab

echo "Chrooting into the new system..."
# Chroot into the new system and configure it
arch-chroot /mnt /bin/bash <<EOF

# Set the timezone
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc

# Set the locale
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Set the hostname
echo "arch" > /etc/hostname

# Install and configure the bootloader (Grub in this case)
pacman -S grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=ArchLinux
grub-mkconfig -o /boot/grub/grub.cfg

EOF

echo "Unmounting partitions..."
# Unmount the partitions
umount -R /mnt

echo "Installation complete! You can now reboot into your new Arch Linux system."
