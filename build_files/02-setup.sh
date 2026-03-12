#! /bin/bash

set -xeuo pipefail

cp -r /ctx/files/etc/* /etc/
cp -r /ctx/files/usr/* /usr/

systemctl enable bootloader-update.service
systemctl mask bootc-fetch-apply-updates.timer
systemctl enable cockpit.socket
systemctl enable greetd

mkdir -p /etc/systemd/system/multi-user.target.wants/
ln -s /usr/lib/systemd/system/xdg-desktop-portal.service /etc/systemd/system/multi-user.target.wants/xdg-desktop-portal.service
ln -s /usr/lib/systemd/system/xdg-desktop-portal-wlr.service /etc/systemd/system/multi-user.target.wants/xdg-desktop-portal-wlr.service
ln -s /usr/lib/systemd/system/xdg-desktop-portal-gtk.service /etc/systemd/system/multi-user.target.wants/xdg-desktop-portal-gtk.service