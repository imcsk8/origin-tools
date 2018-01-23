#!/bin/bash

#Brute force open ports in case there's an exotic firewall like the one centos has
iptables -F

echo "Creating router user"
echo \
    '{"kind":"ServiceAccount","apiVersion":"v1","metadata":{"name":"router"}}' \
    | oc create -f -

echo "Add router user"

oc patch scc privileged --type=json -p '[{"op": "add", "path": "/users/0", "value":"system:serviceaccount:default:router"}]'

echo "Creating router"
oc adm router router
