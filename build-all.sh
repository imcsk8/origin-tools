#!/bin/bash

echo "Build Base Images"
hack/build-base-images.sh
echo "Build Release"
hack/build-release.sh
echo "Build Images"
hack/build-images.sh
echo "Build in Docker"
hack/build-in-docker.sh
