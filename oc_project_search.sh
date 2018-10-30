#!/bin/bash

# Searches for an object by name in all the OpenShift cluster projects

OC="${HOME}/Go/src/github.com/openshift/origin/_output/local/bin/linux/amd64/oc"


if [[ $1 != "" ]]; then
    SEARCH_STRING=$1
else
    echo "Usage: $0 <search string>"
    exit
fi

#readarray -t projects < <($OC projects | grep -v 'You have access to the following')
readarray -t projects < <($OC projects)

shift 

for  i in "${projects[@]:2}"; do
    echo "Checking for ${SEARCH_STRING} in project ${i}"
    $OC get all -n $i | grep -i $SEARCH_STRING
done



