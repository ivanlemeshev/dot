#!/usr/bin/env bash

set -euo pipefail

timedatectl set-ntp true
sgdisk --zap-all /dev/vda
sgdisk --new=1:0:+1GiB --typecode=1:ef00 --change-name=1:EFI /dev/vda
sgdisk --new=2:0:0 --typecode=2:8304 --change-name=2:root /dev/vda
mkfs.fat -F 32 /dev/vda1
mkfs.ext4 -F /dev/vda2
mount /dev/vda2 /mnt
mkdir -p /mnt/boot
mount /dev/vda1 /mnt/boot

pacstrap -K /mnt base linux linux-firmware sudo efibootmgr networkmanager \
  hyprland foot greetd greetd-tuigreet mesa noto-fonts polkit hyprpolkitagent \
  pipewire wireplumber xdg-desktop-portal-hyprland xorg-xwayland
genfstab -U /mnt >>/mnt/etc/fstab

cat >/mnt/root/finish-install.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc
printf 'en_US.UTF-8 UTF-8\n' >/etc/locale.gen
locale-gen
printf 'LANG=en_US.UTF-8\n' >/etc/locale.conf
printf 'KEYMAP=us\n' >/etc/vconsole.conf
printf 'dot-v2-arch\n' >/etc/hostname
bootctl install
cat >/boot/loader/loader.conf <<'LOADER'
default arch.conf
timeout 0
console-mode keep
editor no
LOADER
cat >/boot/loader/entries/arch.conf <<'ENTRY'
title Arch Linux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=PARTUUID=ROOT_PARTUUID rw
ENTRY
root_partuuid="$(blkid -s PARTUUID -o value /dev/vda2)"
sed -i "s/ROOT_PARTUUID/$root_partuuid/" /boot/loader/entries/arch.conf

useradd --create-home --groups wheel tester
printf 'tester:tester\n' | chpasswd
printf 'tester ALL=(ALL) NOPASSWD: ALL\n' >/etc/sudoers.d/tester
chmod 440 /etc/sudoers.d/tester
install -d -o tester -g tester /home/tester/.config/hypr
cat >/home/tester/.config/hypr/hyprland.conf <<'HYPRLAND'
monitor = ,preferred,auto,1
exec-once = hyprpolkitagent
bind = SUPER, RETURN, exec, foot
bind = SUPER, Q, killactive
bind = SUPER, M, exit
HYPRLAND
chown tester:tester /home/tester/.config/hypr/hyprland.conf
cat >/etc/greetd/config.toml <<'GREETD'
[terminal]
vt = 1

[default_session]
command = "tuigreet --cmd Hyprland"
user = "greeter"
GREETD
systemctl enable NetworkManager greetd
EOF
chmod 700 /mnt/root/finish-install.sh
arch-chroot /mnt /root/finish-install.sh
rm /mnt/root/finish-install.sh
systemctl poweroff
