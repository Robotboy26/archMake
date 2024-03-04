#!/bin/bash

# Check if a drive number is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <drive_number>"
    exit 1
fi

# Assign the drive number from the argument
DRIVE="$1"

echo "Resetting partitions on $DRIVE..."
# Remove existing partitions on the drive
wipefs -a ${DRIVE}

echo "Creating partitions on $DRIVE..."
# Create a simple partition layout (one boot partition and one root partition)
parted -s ${DRIVE} mklabel gpt
parted -s ${DRIVE} mkpart primary fat32 1MiB 1025Mib
parted -s ${DRIVE} set 1 esp on
parted -s ${DRIVE} mkpart primary ext4 4GiB 100%

mount ${DRIVE}2 /mnt
mount ${DRIVE}1 /mnt/boot --mkdir

echo "Installing Arch Linux base system..."
pacstrap -K /mnt base-devel base linux linux-firmware git wget grub vi vim sudo networkmanager

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
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts

passwd

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=arch
grub-mkconfig -o /boot/grub/grub.cfg

EOF
