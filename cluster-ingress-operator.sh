#!/bin/bash

# Tasks for testing the Cluster Ingress Operator

ORIGIN_PATH="${GOPATH}/src/github.com/openshift/origin"
OC="${ORIGIN_PATH}/_output/local/bin/linux/amd64/oc"
CIO_REPO="${GOPATH}/src/github.com/openshift/cluster-ingress-operator"

cd ${ORIGIN_PATH}

echo "Creating the Cluster Ingress Operator"
${OC} create -f ${CIO_REPO}/deploy/cio-namespace.yaml
${OC} create -f ${CIO_REPO}/deploy/crd.yaml
${OC} create -f ${CIO_REPO}/deploy/rbac.yaml
${OC} create -f ${CIO_REPO}/deploy/operator.yaml
${OC} create -f ${CIO_REPO}/deploy/cr.yaml

