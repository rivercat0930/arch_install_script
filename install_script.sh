#!/bin/sh

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
Server = https://free.nchc.org.tw/arch/$repo/os/$arch
## Taiwan
Server = https://mirror.archlinux.tw/ArchLinux/$repo/os/$arch
## Taiwan
Server = https://archlinux.cs.nycu.edu.tw/$repo/os/$arch
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

fdisk -l
echo ""
echo "Please enter which disk you want to partition (ex: /dev/sda)"
read DISK

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
# mount
# install arch linux and some software
# spawn fstab

# switch shell to setting something
# unmount

# done
echo "============================="
echo "Everything is getting done!!!"
echo "============================="

# reboot
