#!/bin/bash

if [ "$1" == "" ]; then
  echo "Need tag argument"
  exit
fi

docker tag openshift/origin-pod:latest  openshift/origin-pod:$1
docker tag openshift/origin-pod:latest  docker.io/openshift/origin-pod:latest
docker tag openshift/origin-pod:latest  docker.io/openshift/origin-pod:$1
docker tag openshift/origin-deployer:latest openshift/origin-deployer:$1
docker tag openshift/origin-deployer:latest docker.io/openshift/origin-deployer:latest
docker tag openshift/origin-deployer:latest docker.io/openshift/origin-deployer:$1
docker tag openshift/origin-haproxy-router:latest  openshift/origin-haproxy-router:$1
docker tag openshift/origin-haproxy-router:latest  docker.io/openshift/origin-haproxy-router:latest
docker tag openshift/origin-haproxy-router:latest  docker.io/openshift/origin-haproxy-router:$1
docker tag openshift/origin-haproxy-router:latest openshift3/ose-haproxy-router:$1

