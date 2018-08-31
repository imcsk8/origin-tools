#!/bin/bash

OC=~/Go/src/github.com/openshift/origin/_output/local/bin/linux/amd64/oc

echo "Creating router user"
echo \
    '{"kind":"ServiceAccount","apiVersion":"v1","metadata":{"name":"router"}}' \
    | ${OC} create -f -

echo "Add router user"

${OC} patch scc privileged --type=json -p '[{"op": "add", "path": "/users/0", "value":"system:serviceaccount:default:router"}]'

