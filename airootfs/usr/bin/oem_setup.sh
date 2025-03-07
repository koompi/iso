#!/bin/bash

# setup locale
sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

# setup timezone
ln -sf /usr/share/zoneinfo/Asia/Phnom_Penh /etc/localtime

# setup machine clock
hwclock --systoch --localtime

# setup hostname
echo "koompi_os" > /etc/hostname

# create live user
# useradd -mg users -G wheel,power,storage,input -s /bin/bash --password $(openssl passwd -6 "123") oem
sed -i 's/User=live/User=oem/g' /etc/sddm.conf.d/kde_settings.conf
# chown -R oem /home/oem

# systemd services
systemctl set-default graphical.target
systemctl enable NetworkManager sddm

# prepare boot partition

# regenerate initramfs image
# clean up initcpio config
rm -rf /etc/mkinitcpio.conf.d/*
mv /etc/mkinitcpio.d/koompi.preset /etc/mkinitcpio.d/linux.preset
cp -r /lib/modules/$(uname -r)/vmlinuz /boot/vmlinuz-linux
mkinitcpio -p linux

# install bootloader
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=KOOMPI-OS --recheck
grub-mkconfig -o /boot/grub/grub.cfg

exit