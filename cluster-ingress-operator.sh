#!/bin/bash

# Tasks for testing the Cluster Ingress Operator

ORIGIN_PATH="${GOPATH}/src/github.com/openshift/origin"
OC="${ORIGIN_PATH}/_output/local/bin/linux/amd64/oc"
CIO_REPO="${GOPATH}/src/github.com/openshift/cluster-ingress-operator"
IFACE="enp0s25"

IP=`ip addr show ${IFACE} |  grep -Po 'inet \K[\d.]+'`

cd ${CIO_REPO}

operator-sdk build ${IP}:5000/openshift/cluster-ingress-operator
docker push ${IP}:5000/openshift/cluster-ingress-operator

cd ${ORIGIN_PATH}

echo "Creating the Cluster Ingress Operator"
${OC} create -f ${CIO_REPO}/deploy/crd.yaml
${OC} create -f ${CIO_REPO}/deploy/rbac.yaml
${OC} create -f ${CIO_REPO}/deploy/operator.yaml
${OC} create -f ${CIO_REPO}/deploy/cr.yaml

