#!/bin/bash

hack/build-release.sh 
hack/build-images.sh 
docker tag openshift/origin-haproxy-router:latest openshift3/ose-haproxy-router:v3.5.0.1
docker stop $(docker ps | grep haproxy | cut -d ' ' -f 1)

