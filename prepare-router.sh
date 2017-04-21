#!/bin/bash

echo "Creating router user"
echo \
    '{"kind":"ServiceAccount","apiVersion":"v1","metadata":{"name":"router"}}' \
    | oc create -f 


echo "Add router user"

oc patch scc privileged --type=json -p '[{"op": "add", "path": "/users/0", "value":"system:serviceaccount:default:router"}]'

echo "Creating router"
oadm router router
