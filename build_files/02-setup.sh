#! /bin/bash

set -xeuo pipefail

mkdir -p /etc/skel/.bashrc.d/
cp /ctx/files/etc/skel/* /etc/skel/*
cp -r /ctx/files/usr/share/applications/* /usr/share/applications/
cp -r /ctx/files/usr/lib/systemd/* /usr/lib/systemd/

systemctl enable bootloader-update.service
systemctl mask bootc-fetch-apply-updates.timer
systemctl enable cockpit.socket
systemctl enable greetd

mkdir -p /etc/systemd/system/multi-user.target.wants/
ln -s /usr/lib/systemd/system/xdg-desktop-portal.service /etc/systemd/system/multi-user.target.wants/xdg-desktop-portal.service
ln -s /usr/lib/systemd/system/xdg-desktop-portal-wlr.service /etc/systemd/system/multi-user.target.wants/xdg-desktop-portal-wlr.service
ln -s /usr/lib/systemd/system/xdg-desktop-portal-gtk.service /etc/systemd/system/multi-user.target.wants/xdg-desktop-portal-gtk.service