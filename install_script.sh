#!/bin/sh

fdisk -l
echo ""
echo "Please enter which disk you want to partition (ex: /dev/sda)"
read DISK

echo "Please enter root password: "
read ROOT_PASSWD

echo "Please enter hostname: "
read HOSTNAME

echo "Please enter username: "
read USERNAME

echo "Please enter user password: "
read PASSWORD

#check network connect status
if ping google.com -c 4 ; then
    echo "=========================="
    echo "network check is complete."
    echo "=========================="
else
    echo "=============================================="
    echo "Please check network connection and try again."
    echo "=============================================="

    exit
fi

# add mirror site
echo ""
echo "=============="
echo "Add mirrorlist"
echo "=============="

head -n 10 /etc/pacman.d/mirrorlist > /etc/pacman.d/mirrorlist.new
echo "## Taiwan
Server = https://free.nchc.org.tw/arch/\$repo/os/\$arch
## Taiwan
Server = https://mirror.archlinux.tw/ArchLinux/\$repo/os/\$arch
## Taiwan
Server = https://archlinux.cs.nycu.edu.tw/\$repo/os/\$arch
" >> /etc/pacman.d/mirrorlist.new

tail -n 20 /etc/pacman.d/mirrorlist >> /etc/pacman.d/mirrorlist.new
rm -rf /etc/pacman.d/mirrorlist
mv /etc/pacman.d/mirrorlist.new /etc/pacman.d/mirrorlist

echo "======================="
echo "Add mirrorlist complete"
echo "======================="

# make partition
echo ""
echo "=============="
echo "make partition"
echo "=============="

(
echo "g"

echo "n"
echo ""
echo ""
echo "+500M"
echo "t"
echo "1"

echo "n"
echo ""
echo ""
echo ""
echo "t"
echo "2"
echo "23"

echo "w"
) | fdisk ${DISK}


echo "==================="
echo "make partition done"
echo "==================="

# formatting
echo ""
echo "================"
echo "start formatting"
echo "================"

mkfs.ext4 ${DISK}2
mkfs.fat -F 32 ${DISK}1

echo "==========="
echo "format done"
echo "==========="

# mount
echo ""
echo "==========="
echo "start mount"
echo "==========="

mount ${DISK}2 /mnt
mount --mkdir ${DISK}1 /mnt/boot

echo "=========="
echo "mount done"
echo "=========="

# install arch linux and some software
pacstrap -K /mnt base linux linux-firmware linux-headers neofetch man-db man-pages sudo nano networkmanager ntp tmux git pipewire-pulse nvidia nvidia-dkms nvidia-settings nvtop dosfstools ntfs-3g amd-ucode intel-ucode xf86-video-vesa xf86-video-ati xf86-video-intel xf86-video-amdgpu xf86-video-nouveau xf86-video-fbdev grub efibootmgr ufw xorg xorg-server sddm plasma-meta kde-accessibility-meta kde-games-meta kde-graphics-meta kde-multimedia-meta kde-network-meta kde-pim-meta kde-sdk-meta kde-system-meta kde-utilities-meta kdevelop-meta

# generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# generate shell script to next step installation
echo "#!bin/sh

# change timezone
ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime

# localization
sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/^#zh_TW.UTF-8 UTF-8/zh_TW.UTF-8 UTF-8/' /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf

# hostname
echo "{$HOSTNAME}" > /etc/hostname

# root password
(echo "$ROOT_PASSWD"
echo "$ROOT_PASSWD") | passwd 

# boot loader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch --removable --recheck
grub-mkconfig -o /boot/grub/grub.cfg

# add user
useradd -m $USERNAME
(echo "$PASSWORD"
echo "$PASSWORD") | passwd $USERNAME
sed -i '79i$USERNAME ALL=(ALL:ALL) ALL' /etc/sudoers

# enable network manager
systemctl enable NetworkManager

# enable ufw
systemctl enable ufw
ufw default allow outgoing
ufw default deny incoming

# enable sddm
systemctl enable sddm

exit
" > /mnt/next.sh

# switch shell to setting something
arch-chroot /mnt sh next.sh

# unmount
umount -R /mnt

# done
echo "============================="
echo "Everything is getting done!!!"
echo "============================="
