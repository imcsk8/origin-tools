#!/bin/bash

echo "Creating uaser: $1"
echo \
'{"kind":"ServiceAccount","apiVersion":"v1","metadata":{"name":"$1"}}' \
| oc create -f -

echo "Add router user"

oc patch scc privileged --type=json -p '[{"op": "add", "path": "/users/0", "value":"system:serviceaccount:default:$1"}]'
