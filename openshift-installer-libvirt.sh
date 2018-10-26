#!/bin/bash

# First have to source openshift-libvirt.sh

function start_openshift {
    if [[ -d $OPENSHIFT_INSTALL_CLUSTER_NAME ]]; then
        echo "Cluster directory exists. Perhaps there's a cluster running?"
        exit
    fi
    bin/openshift-install create cluster --dir $OPENSHIFT_INSTALL_CLUSTER_NAME
}

function stop_openshift {
    bin/openshift-install destroy cluster --dir $OPENSHIFT_INSTALL_CLUSTER_NAME
    rm terraform.tfvars
    rm -rf $OPENSHIFT_INSTALL_CLUSTER_NAME
}

cd $OPENSHIFT_INSTALLER_PATH

case $1 in
    restart)
        echo "Restarting OpenShift"
        stop_openshift
        start_openshift
        ;;
    start)
        echo "Starting OpenShift"
        start_openshift
        ;;
    stop)
        echo "Stopping cluster"
        stop_openshift
        ;;    
esac


