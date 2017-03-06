#!/bin/bash

export OS_ONLY_BUILD_PLATFORMS="linux/amd64"
hack/build-release.sh 
hack/build-images.sh 
if [ $1 != "" ]; then
  docker tag openshift/origin-haproxy-router:latest openshift3/ose-haproxy-router:$1
  docker tag openshift/origin-haproxy-router:latest openshift/origin-haproxy-router:$1
fi
docker stop $(docker ps | grep haproxy | cut -d ' ' -f 1)

