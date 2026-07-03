#!/usr/bin/env bash

# install script to /usr/local/bin/
cp ./cmd/systemd-boot-btrfs /usr/local/bin/systemd-boot-btrfs

# copy systemd units
cp ./systemd/systemd-boot-btrfs.service /etc/systemd/system/systemd-boot-btrfs.service
cp ./systemd/systemd-boot-btrfs.path /etc/systemd/system/systemd-boot-btrfs.path

# enable systemd units
systemctl enable --now systemd-boot-btrfs.service
systemctl enable --now systemd-boot-btrfs.path

boot_path="/boot/efi/loader/entries/"
boot_main_cfg="$(find "${boot_path}" -maxdepth 1 -type f -name 'main*.conf' -print -quit)"
if [[ ! -e "$boot_main_cfg" ]]; then
    boot_main_cfg="$(find "${boot_path}" -type f -name '*.conf' -printf '%T@ %f\n' | sort -n | head -1 | awk '{print $2}')"
fi

if [[ ! -e "$boot_main_cfg" ]]; then
    echo "could not find main-***.conf or oldest boot laoder file in ${boot_path}. you will need that!"
fi
echo "install is done."
