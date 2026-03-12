#! /bin/bash

set -xeuo pipefail

# INSTALL REPOS
dnf -y install dnf5-plugins
dnf -y config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo
dnf -y config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
dnf install -y \
  https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | tee /etc/yum.repos.d/vscode.repo >/dev/null
grep -vE '^#' /ctx/build/packages/copr-repos | xargs -n1 dnf -y copr enable

# INSTALL PACKAGES
grep -vE '^#' /ctx/build/packages/packages-added | xargs dnf -y install

# REMOVE PACKAGES
grep -vE '^#' /ctx/build/packages/packages-removed | xargs dnf -y remove
dnf -y autoremove
dnf clean all

cp -r /ctx/build/packages /usr/local/share/electrumOS
jq -r .packages[] /usr/share/rpm-ostree/treefile.json >/usr/local/share/electrumOS/packages-fedora-bootc
