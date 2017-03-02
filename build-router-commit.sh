#!/bin/bash

git commit -a --amend -m 'Add debugging stuff'
hack/build-release.sh 
hack/build-images.sh 
if [ $1 != "" ]; then
  docker tag openshift/origin-haproxy-router:latest openshift3/ose-haproxy-router:$1
fi
docker stop $(docker ps | grep haproxy | cut -d ' ' -f 1)

