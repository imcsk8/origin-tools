#!/bin/bash

export OS_ONLY_BUILD_PLATFORMS="linux/amd64"

echo "Build Base Images"
hack/build-base-images.sh
echo "Build Release"
hack/build-release.sh
echo "Build Images"
hack/build-images.sh
echo "Build in Docker"
hack/build-in-docker.sh
