#!/bin/bash

set -e

export OS_ONLY_BUILD_PLATFORMS="linux/amd64"

OS_RELEASE=n hack/build-go.sh
hack/build-local-images.py openshift/origin
hack/build-local-images.py openshift/origin-haproxy-router
