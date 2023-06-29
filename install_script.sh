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
head -n 10 /etc/pacman.d/mirrorlist > /etc/pacman.d/mirrorlist.new
echo "## Taiwan
Server = https://mirror.archlinux.tw/ArchLinux/$repo/os/$arch
Server = https://free.nchc.org.tw/arch/$repo/os/$arch
Server = https://archlinux.cs.nycu.edu.tw/$repo/os/$arch
" >> /etc/pacman.d/mirrorlist.new

tail -n 20 /etc/pacman.d/mirrorlist >> /etc/pacman.d/mirrorlist.new
rm -rf /etc/pacman.d/mirrorlist
mv /etc/pacman.d/mirrorlist.new /etc/pacman.d/mirrorlist

# make partition
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
