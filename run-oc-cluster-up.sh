#!/bin/bash

echo "Preparing server for running all in one cluster"
echo "Installing docker"
yum install -y docker wget
sed -i $'s/OPTIONS=\''/OPTIONS=\''--insecure-registry 172.30.0.0\/16 /' /etc/sysconfig/docker
systemctl enable docker
systemctl start docker
cd
mkdir openshift
cd openshift 
echo "Downloading OKD"
wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-server-v3.11.0-0cbc58b-linux-64bit.tar.gz
echo "Unpacking OKD"
tar -zxvf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
tar -zxvf openshift-origin-server-v3.11.0-0cbc58b-linux-64bit.tar.gz

export PATH=$PATH:/root/openshift/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit:/root/openshift/openshift-origin-server-v3.11.0-0cbc58b-linux-64bit

oc cluster up -v 10 --base-dir=oc-cluster-up 2>&1 | tee oc-cluster-up.log
