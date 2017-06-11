#!/bin/bash


/usr/bin/docker run --name origin-node --rm --privileged --net=host --pid=host -v /:/rootfs:ro -v /etc/systemd/system:/host-etc/systemd/system -v /etc/localtime:/etc/localtime:ro -v /etc/machine-id:/etc/machine-id:ro -v /lib/modules:/lib/modules -v /run:/run -v /sys:/sys:rw -v /var/lib/docker:/var/lib/docker -v /etc/origin/node:/etc/origin/node -v /etc/origin/openvswitch:/etc/openvswitch -v /etc/origin/sdn:/etc/openshift-sdn -v /var/lib/origin:/var/lib/origin:rslave -v /var/log:/var/log -v /dev:/dev -v /var/lib/cni:/var/lib/cni -e HOST=/rootfs -e HOST_ETC=/host-etc -e OPTIONS=--loglevel=5 -e CONFIG_FILE=/var/lib/origin/openshift.local.config/node/node-config.yaml 192.168.100.193:5000/openshift/node
