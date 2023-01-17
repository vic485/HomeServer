#!/bin/bash

if [[ $(/usr/bin/id -u) -ne 0 ]]; then
    echo "Setup script must be run as root"
    exit
fi

# Install ZFS
zypper --non-interactive --quiet addrepo https://download.opensuse.org/repositories/filesystems/15.4/filesystems.repo
zypper --gpg-auto-import-keys refresh
zypper --non-interactive install zfs

# Load ZFS modules
modprobe -a zfs
echo zfs > /etc/modules-load.d/zfs.conf

# Install and setup samba
zypper --non-interactive install samba

mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
cp ../templates/smb.conf /etc/samba/smb.conf

systemctl enable --now smb
systemctl enable --now nmb

# Install docker
zypper --non-interactive --quiet addrepo https://download.opensuse.org/repositories/Virtualization:containers/15.4/Virtualization:containers.repo
zypper --gpg-auto-import-keys refresh
zypper --non-interactive install docker docker-compose

systemctl enable --now docker
