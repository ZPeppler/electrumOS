#! /bin/bash

set -xeuo pipefail

mkdir -p /var/roothome

rm -rfv /opt
ln -s /var/opt /opt

# UPGRADE BASE PACKAGES
dnf -y upgrade

# REMOVE PACKAGES
grep -vE '^#' /ctx/build/packages/packages-pre-removed | xargs dnf -y remove
