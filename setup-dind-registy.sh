#!/bin/bash

# Starts docker in docker environment configures the nodes to use a local registry
# and pushes local images to the local registry
# Ivan Chavero <ichavero@chavero.com.mx>

# Usage: cd origin; ../setup-dind-registy.sh  -i "<image1> <image2> ... <imageN>"

IMAGES=""

IFACE="enp0s25"

DEFAULT_IMAGES="openshift/node openshift/origin-recycler openshift/origin-deployer openshift/origin-haproxy-router openshift/origin-nginx-router openshift/origin-template-service-broker openshift/origin-sti-builder openshift/origin-keepalived-ipfailover openshift/origin-f5-router openshift/origin-docker-builder openshift/origin-control-plane"

dind_restart=false
push_local_images=false
image_build=true
nodes="2"

function setup_node_registry {
    docker exec -t $1 sh -c "echo \"BLOCK_REGISTRY='--block-registry=all'\" >> /etc/sysconfig/docker"
    docker exec -t $1 sh -c "echo \"INSECURE_REGISTRY='--insecure-registry=${IP}:5000'\" >> /etc/sysconfig/docker"
    docker exec -t $1 sh -c "echo \"ADD_REGISTRY='--add-registry=${IP}:5000 --add-registry=docker.io'\" >> /etc/sysconfig/docker"
    docker exec -t $1 sh -c "echo \"ADD_REGISTRY='--add-registry=${IP}:5000 --add-registry=docker.io'\" >> /etc/sysconfig/docker"
    #docker exec -t $1 sh -c "sed -i -e 's/registries = \[\]//' -e \"s/registries.insecure\]/registries.insecure]\nregistries = ['${IP}:5000']/\" /etc/containers/registries.conf"
    docker exec -t $1 sh -c "sed -i '/^\[registries.search\]$/{\$!{N;s/^\[registries.search\]\nregistries .*/\[registries.search\]\nregistries = \[\"${IP}:5000\", \"docker.io\", \"registry.fedoraproject.org\", \"registry.access.redhat.com\"\]/g;ty;P;D;:y}}' /etc/containers/registries.conf"
    docker exec -t $1 sh -c "sed -i '/^\[registries.insecure\]$/{\$!{N;s/^\[registries.insecure\]\nregistries .*/\[registries.insecure\]\nregistries = \[\"${IP}:5000\"\]/g;ty;P;D;:y}}' /etc/containers/registries.conf"
    docker exec -t $1 systemctl restart docker

   docker exec -t $1 sh -c "sed -i 's/format: openshift/format: ${IP}:5000\/openshift/' /data/openshift.local.config/node-openshift-node-${2}/node-config.yaml"
   docker exec -t $1 sh -c "systemctl restart openshift-node.service"

   docker exec -t $1 sh -c "docker pull ${IP}:5000/openshift/origin-deployer:${TAG}"
   docker exec -t $1 sh -c "docker pull ${IP}:5000/openshift/origin-deployer:latest"

   docker exec -t $1 sh -c "docker pull ${IP}:5000/openshift/origin-haproxy-router:${TAG}"
   docker exec -t $1 sh -c "docker pull ${IP}:5000/openshift/origin-haproxy-router:latest"

   docker exec -t $1 sh -c "docker pull ${IP}:5000/openshift/origin-pod:${TAG}"
   docker exec -t $1 sh -c "docker pull ${IP}:5000/openshift/origin-pod:latest"

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

while getopts ":i:rnN:" opt; do
  case ${opt} in
    i)
        echo "Building images: $OPTARG"
        IMAGES=$OPTARG
      ;;
    r)
        echo "Restart dind"
        dind_restart=true
      ;;
    n)
       echo "Images will not be built"
       image_build=false
       ;;
    p)
       echo "Local Images will be pushed to registry"
       push_local_images=true
       ;;

    N)
       nodes=$OPTARG
       echo "Creating a cluster with $nodes nodes"
       ;;
    \?)
       echo "Usage: cmd [-i images] [-r Restart dind] [-N nodes]"
       exit
       ;;
  esac
done

#cable export IP=`ip addr show enp0s25 |  grep -Po 'inet \K[\d.]+'`
export IP=`ip addr show ${IFACE} |  grep -Po 'inet \K[\d.]+'` # wifi
export TAG=$(git describe --abbrev=0 2>&1)

if [[ ${TAG} == *"fatal"* ]]; then
    echo "This script has to be run inside the openshift origin repo"
    exit
fi

status=$(docker ps -a --filter name=openshift-master --format {{.Status}})
if [[ ${status} == *"Up"* ]] && [[ ${dind_restart} != true ]]; then
    echo "Dind already up"
else
    echo "Starting dind"
    hack/dind-cluster.sh stop
    hack/dind-cluster.sh start -rib -N $nodes
fi


status=$(docker ps -a --filter name=registry --format {{.Status}})

if [[ ${status} == *"Exited"* ]]; then
    echo "Restarting registry"
    docker start registry
elif [[ ${status} == "" ]]; then
    echo "Starting registry"
    docker run -d -p 5000:5000 --restart=always --name registry registry:2
else 
    echo "Registry already running"
fi

if [[ ${IMAGES} == "" ]]; then
    IMAGES=$DEFAULT_IMAGES
fi

# Setup registry on master
setup_node_registry openshift-master
docker exec -t openshift-master sh -c "sed -i 's/format: openshift/format: ${IP}:5000\/openshift/' /data/openshift.local.config/master/master-config.yaml"
docker exec -t openshift-master sh -c "sed -i 's/format: openshift/format: ${IP}:5000\/openshift/' /data/openshift.local.config/node-openshift-master-node/node-config.yaml"


docker exec -t openshift-master sh -c "systemctl restart openshift-master.service"
docker exec -t openshift-master sh -c "systemctl restart openshift-node.service"

# Setup registry on nodes
for i in `seq 1 $nodes`; do
    setup_node_registry openshift-node-${i} ${i}
done

if [[ ${image_build}} != false ]]; then
    build_images
fi

if [[ ${push_local_images}} != false ]]; then
    push_images
fi
