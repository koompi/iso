#!/usr/bin/env bash
# shellcheck disable=SC2034

iso_name="koompi-os"
iso_label="KOOMPI_OS_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="KOOMPI <https://koompi.org>"
iso_application="KOOMPI OS"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito' 'uefi-x64.systemd-boot.esp' 'uefi-x64.systemd-boot.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')
file_permissions=(
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/etc/shadow"]="0:0:400"
  ["/etc/sudoers.d/wheel"]="0:0:440"
  ["/etc/sudoers.d/live"]="0:0:440"
  ["/usr/local/bin/choose-mirror"]="0:0:755"
  ["/usr/bin/koompi-os-installer"]="0:0:755"
  ["/usr/bin/oem_setup.sh"]="0:0:755"
  ["/home/live"]="1000:1000:755"
  ["/home/live/.config"]="1000:1000:755"
  ["/home/live/.config/autostart"]="1000:1000:755"
  ["/home/live/.config/autostart/koompi-os-installer.desktop"]="1000:1000:755"
  ["/home/oem"]="1001:1001:755"
  ["/home/oem/.config"]="1001:1001:755"
  ["/home/oem/.config/autostart"]="1001:1001:755"
  ["/home/oem/.config/autostart/koompi-os-installer.desktop"]="1001:1001:755"
)
