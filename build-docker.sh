#!/bin/bash

echo "Build Release"
hack/build-release.sh
echo "Build Images"
hack/build-images.sh
echo "Build in Docker"
hack/build-in-docker.sh
