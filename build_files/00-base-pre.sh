#! /bin/bash

set -xeuo pipefail

mkdir -p /var/roothome

rm -rfv /opt
ln -s /var/opt /opt

# REMOVE PACKAGES
grep -vE '^#' /ctx/build/packages/packages-pre-removed | xargs dnf -y remove
