#!/bin/bash

echo "Pushing images to registry"
docker tag openshift/base localhost:5000/openshift/base
docker push localhost:5000/openshift/base
docker tag openshift/builder localhost:5000/openshift/builder
docker push localhost:5000/openshift/builder
docker tag openshift/deployer localhost:5000/openshift/deployer
docker push localhost:5000/openshift/deployer
docker tag openshift/dind localhost:5000/openshift/dind
docker push localhost:5000/openshift/dind
docker tag openshift/dockerregistry localhost:5000/openshift/dockerregistry
docker push localhost:5000/openshift/dockerregistry
docker tag openshift/ipfailover localhost:5000/openshift/ipfailover
docker push localhost:5000/openshift/ipfailover
docker tag openshift/node localhost:5000/openshift/node
docker push localhost:5000/openshift/node
docker tag openshift/observe localhost:5000/openshift/observe
docker push localhost:5000/openshift/observe
docker tag openshift/openldap localhost:5000/openshift/openldap
docker push localhost:5000/openshift/openldap
docker tag openshift/openvswitch localhost:5000/openshift/openvswitch
docker push localhost:5000/openshift/openvswitch
docker tag openshift/origin localhost:5000/openshift/origin
docker push localhost:5000/openshift/origin
docker tag openshift/pod localhost:5000/openshift/pod
docker push localhost:5000/openshift/pod
docker tag openshift/recycler localhost:5000/openshift/recycler
docker push localhost:5000/openshift/recycler
docker tag openshift/release localhost:5000/openshift/release
docker push localhost:5000/openshift/release
docker tag openshift/router localhost:5000/openshift/router
docker push localhost:5000/openshift/router
docker tag openshift/simple-authenticated-registry localhost:5000/openshift/simple-authenticated-registry
docker push localhost:5000/openshift/simple-authenticated-registry
