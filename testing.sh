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

    # Download Arch Linux base system
    curl -L -o /root/archlinux.tar.gz "<DOWNLOAD_URL>"

    # Extract Arch Linux base system
    tar -xzf /root/archlinux.tar.gz -C /mnt/

    # Generate an fstab file
    genfstab -U /mnt >> /mnt/etc/fstab

    # Mount necessary filesystems in chroot
    mount -t proc none /mnt/proc
    mount -t sysfs none /mnt/sys
    mount -o bind /dev /mnt/dev
    mount -t devpts none /mnt/dev/pts

    # Change root to the new system and perform installations
    chroot /mnt /bin/bash -c "source /root/.bashrc; /bin/bash -c '
      pacman -Syu --noconfirm grub efibootmgr dosfstools os-prober mtools base-devel linux-headers
      grub-install --target=x86_64-efi --bootloader-id=arch_grub --recheck "${drive}"
      grub-mkconfig -o /boot/grub/grub.cfg
      echo "Please enter a password for the root user:"
      passwd
    '"

    # Unmount filesystems from chroot
    umount -R /mnt/{dev/pts,dev,sys,proc}

    echo "Installation complete. You can now reboot the system!"
else
    echo "Installation process aborted."
    exit
fi
