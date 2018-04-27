#!/bin/bash

# Starts docker in docker environment configures the nodes to use a local registry
# and pushes local images to the local registry
# Ivan Chavero <ichavero@chavero.com.mx>

# Usage: cd origin; ../setup-dind-registy.sh  <image1> <image2> ... <imageN>

IMAGES=$1

IFACE="enp0s25"

DEFAULT_IMAGES="openshift/node openshift/origin-recycler openshift/origin-deployer openshift/origin-haproxy-router openshift/origin-nginx-router openshift/origin-template-service-broker openshift/origin-sti-builder openshift/origin-keepalived-ipfailover openshift/origin-f5-router openshift/origin-docker-builder openshift/origin-control-plane"

function setup_node_registry {
    docker exec -t $1 sh -c "echo \"BLOCK_REGISTRY='--block-registry=all'\" >> /etc/sysconfig/docker"
    docker exec -t $1 sh -c "echo \"INSECURE_REGISTRY='--insecure-registry=${IP}:5000'\" >> /etc/sysconfig/docker"
    docker exec -t $1 sh -c "echo \"ADD_REGISTRY='--add-registry=${IP}:5000 --add-registry=docker.io'\" >> /etc/sysconfig/docker"
    docker exec -t $1 systemctl restart docker
}

function build_images {
    echo "Building Images"
    hack/build-local-images.py ${IMAGES}
}

function push_images {
    for i in ${IMAGES}; do
        docker tag ${i} ${IP}:5000/${i}:latest
        docker tag ${i} ${IP}:5000/${i}:latest
        docker tag ${i} ${IP}:5000/${i}:${TAG}

        docker push ${IP}:5000/${i}:latest
        docker push ${IP}:5000/${i}:${TAG}
    done
}


#cable export IP=`ip addr show enp0s25 |  grep -Po 'inet \K[\d.]+'`
export IP=`ip addr show ${IFACE} |  grep -Po 'inet \K[\d.]+'` # wifi
export TAG=`git describe --abbrev=0`

if [[ ${TAG} == *"fatal"* ]]; then
    echo "This script has to be run inside the openshift origin repo"
    exit
fi

#hack/dind-cluster.sh stop
#hack/dind-cluster.sh start -rib

echo "Starting registry"

status=$(docker ps -a --filter name=registry --format {{.Status}})

echo "STATUS: $status"

if [[ ${status} == *"Exited"* ]]; then
    docker start registry
else
    docker run -d -p 5000:5000 --restart=always --name registry registry:2
fi

if [[ ${IMAGES} == "" ]]; then
    IMAGES=$DEFAULT_IMAGES
fi

setup_node_registry openshift-master
setup_node_registry openshift-node-1
setup_node_registry openshift-node-2

build_images
push_images
