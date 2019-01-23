#!/bin/bash

# Prepares the host for use minishift with KVM
# (for now) this script should be run using sudo
# Ivan Chavero <ichavero@chavero.com.mx>

USERNAME=$1

dnf -y install libvirt qemu-kvm
systemctl enable libvirtd
systemctl start libvirtd
usermod -a -G libvirt $USERNAME
cd /usr/local/bin
curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-centos7 -o /usr/local/bin/docker-machine-driver-kvm
chmod +x /usr/local/bin/docker-machine-driver-kvm
cd ..
curl -L https://github.com/minishift/minishift/releases/download/v1.30.0/minishift-1.30.0-linux-amd64.tgz -o minishift-1.30.0-linux-amd64.tgz
tar -zxvf minishift-1.30.0-linux-amd64.tgz
ln -s minishift-1.30.0-linux-amd64 minishift
export PATH=$PATH:/usr/local/minishift
minishift start 


