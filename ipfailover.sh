#!/bin/bash
echo "Generating ipfailover image"
docker tag openshift/origin-keepalived-ipfailover 192.168.100.193:5000/openshift/origin-keepalived-ipfailover
docker push 192.168.100.193:5000/openshift/origin-keepalived-ipfailover
