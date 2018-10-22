#!/bin/bash

# Run the cluster ingress operator


NAMESPACE="default"

if [[ $1 != "" ]]; then
    NAMESPACE=$1
fi

#For a 4.0 cluster on aws created with the installer
export KUBECONFIG="${HOME}/Go/src/github.com/openshift/installer/auth/kubeconfig"
export CIO_DIR="${HOME}/Go/src/github.com/openshift/cluster-ingress-operator"
export OPERATOR_NAME="${USERNAME}-ingress-operator"

echo "Preparing Cluster Ingress Operator"
cd $CIO_DIR
echo "Creating resources"
oc apply -f manifests/ 
echo "Starting Operator"
operator-sdk up local namespace ${NAMESPACE} --kubeconfig=${KUBECONFIG}

