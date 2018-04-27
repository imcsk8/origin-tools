#!/bin/bash

echo "Building origin"
export OS_ONLY_BUILD_PLATFORMS="linux/amd64"
OS_RELEASE=n hack/build-go.sh

echo "Building origin container"
cp _output/local/bin/linux/amd64/openshift images/origin/bin/
hack/build-local-images.py origin

echo "Deploying origin image"
docker tag openshift/origin localhost:5000/openshift/origin
docker push localhost:5000/openshift/origin
