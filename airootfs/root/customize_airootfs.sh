#!/usr/bin/env bash

set -e -u

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

timedatectl set-local-rtc 0
timedatectl set-ntp 1
hwclock --systohc --localtime

sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i "/0x.sg/d" /etc/pacman.d/mirrorlist

# Change passwrod timeout to 60 minutes
echo 'Defaults timestamp_timeout=60' | EDITOR='tee -a' visudo -f /etc/sudoers.d/timestamp_timeout
# Enable ***** sudo feedback
echo 'Defaults pwfeedback' | EDITOR='tee -a' visudo -f /etc/sudoers.d/pwfeedback
# Enable group wheel
echo '%wheel ALL=(ALL) ALL' | EDITOR='tee -a' visudo -f /etc/sudoers.d/10-installer
# Config faillock
echo -e 'deny = 10\nunlock_time = 60\neven_deny_root\nroot_unlock_time = 600' | tee /etc/security/faillock.conf
# systemd kill procress
sed -i 's/#DefaultTimeoutStopSec=90s/DefaultTimeoutStopSec=10s/g' /etc/systemd/system.conf

# OS Release Branding
echo -e "[General]\nName=KOOMPI OS\nPRETTY_NAME=KOOMPI OS\nLogoPath=/usr/share/icons/koompi/koompi.svg\nWebsite=http://www.koompi.com\nVersion=2.6.0\nVariant=Rolling Release\nUseOSReleaseVersion=false" | tee /etc/xdg/kcm-about-distrorc
echo -e 'NAME="KOOMPI OS"\nPRETTY_NAME="KOOMPI OS"\nID=koompi\nBUILD_ID=rolling\nANSI_COLOR="38;2;23;147;209"\nHOME_URL="https://www.koompi.com/"\nDOCUMENTATION_URL="https://wiki.koompi.org/"\nSUPPORT_URL="https://t.me/koompi"\nBUG_REPORT_URL="https://t.me/koompi"\nLOGO=/usr/share/icons/koompi/koompi.svg' | tee /etc/os-release

# nano config
# grep "include /usr/share/nano-syntax-highlighting/*.nanorc" /etc/nanorc
# [[ $? -eq 1 ]] && echo -e "include /usr/share/nano-syntax-highlighting/*.nanorc" | tee -a /etc/nanorc

# Host Name
echo "koompi_os" | tee /etc/hostname
# reflector
echo -e '--save /etc/pacman.d/mirrorlist \n--country "Hong Kong" \n--country Singapore \n--country Japan \n--country China \n--latest 20 \n--protocol https --sort rate' | sudo tee /etc/xdg/reflector/reflector.conf
reflector --country "Hong Kong" --country Singapore --country Japan --country China --latest 20 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

pacman -Syy --noconfirm koompi-skel --overwrite="*"

# Set password for root user
echo -e "123\n123" | passwd root

# Create live user for running installation
useradd -mg users -G wheel,input -s /bin/bash live
echo -e "123\n123" | passwd live

systemctl enable sddm NetworkManager haveged cups.socket bluetooth systemd-timedated systemd-timesyncd upower
systemctl set-default graphical.target

setfacl -m u:sddm:x /var/lib/AccountsService/icons/

groupadd pix
usermod -a -G pix live
chgrp -R pix /var/lib/pix
chmod -R 2775 /var/lib/pix

mkdir -p /home/live/Desktop/
cp /usr/share/applications/calamares.desktop /home/live/Desktop/
sudo sed -i -e 's/GRUB_TIMEOUT=.*/GRUB_TIMEOUT=0/g' /etc/default/grub
sudo sed -i -e 's/GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="KOOMPI_OS"/g' /etc/default/grub
sudo sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash loglevel=0 rd.udev.log-priority=0 vt.global_cursor_default=0 fsck.mode=skip"/g' /etc/default/grub

sed -i "/fsck/d" /etc/mkinitcpio.conf
sed -i -e "s/HOOKS=\"base udev.*/HOOKS=\"base systemd fsck autodetect modconf block keyboard keymap filesystems\"/g" /etc/mkinitcpio.conf
sed -i -e "s/HOOKS=(base udev.*/HOOKS=\"base systemd fsck autodetect modconf block keyboard keymap filesystems\"/g" /etc/mkinitcpio.conf
