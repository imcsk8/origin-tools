#!/bin/bash

echo "Starting ipfailover..."
oadm policy add-scc-to-user privileged -z ipfailover
oadm ipfailover   --virtual-ips="1.2.3.4,10.1.1.100-104,5.6.7.8" --watch-port=0 --replicas=2 --create
