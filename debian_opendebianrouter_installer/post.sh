#!/bin/sh
#
set -e

# OpenMediaVault
echo " -> updating Sources..." >&1

[ -f /etc/apt/sources.list.d/backports.list ] && rm -f /etc/apt/sources.list.d/backports.list >&1
wget -q -O /etc/apt/sources.list.d/backports.list http://universenas.0rca.ch/sources/backports.list >&1

[ -f /etc/apt/sources.list.d/openmediavault.list ] && rm -f /etc/apt/sources.list.d/openmediavault.list >&1
wget -q -O /etc/apt/sources.list.d/openmediavault.list http://universenas.0rca.ch/sources/openmediavault.list >&1

[ -f /etc/apt/sources.list.d/omv-extras-org-stoneburner.list ] && rm -f /etc/apt/sources.list.d/omv-extras-org-stoneburner.list >&1
wget -q -O /etc/apt/sources.list.d/omv-extras-org-stoneburner.list http://universenas.0rca.ch/sources/omv-extras-org-stoneburner.list >&1

echo " -> updating Keys..." >&1
wget -O - http://universenas.0rca.ch/sources/PublicKey.asc | apt-key add - >&1

echo " -> updating apt..." >&1

export DEBIAN_FRONTEND=noninteractive
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
#locale-gen en_US.UTF-8 2>&1 1>/dev/null
#dpkg-reconfigure locales 2>&1 1>/dev/null

mkdir -p /var/cache/openmediavault/archives && touch /var/cache/openmediavault/archives/Packages

apt-get -qq update

echo " -> installing OpenMediaVault..." >&1
apt-get -qq -y --force-yes --quiet install postfix 2>&1 1>/dev/null
apt-get -qq -y --force-yes --quiet install xmlstarlet openmediavault-keyring 2>&1 1>/dev/null
apt-get -qy --force-yes install openmediavault 2>&1
apt-get -qy --force-yes install openmediavault-omvextrasorg openmediavault-ddclient openmediavault-dnsmasq openmediavault-menuconfig 2>&1

echo " -> Done..." >&1
exit 0
######
#EOF
