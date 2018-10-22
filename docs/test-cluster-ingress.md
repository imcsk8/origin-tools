# Testing the cluster ingress operator

This steps are for testing the Ingress Operator with the 
openshift installer.


## Manually

**Delete the all the router objects from the openshift-ingress namespace**

```
oc delete deployment.apps/tectonic-ingress-controller-operator deployment.apps/router deployment.apps/default-http-backend service/router service/default-http-backend
```

**In case they don't exist create the Operator resources**

```
oc create -f cluster-ingress-operator/manifests/00-cluster-role.yaml
oc create -f cluster-ingress-operator/manifests/00-custom-resource-definition.yaml
oc create -f cluster-ingress-operator/manifests/00-namespace.yaml
oc create -f cluster-ingress-operator/manifests/01-cluster-role-binding.yaml
oc create -f cluster-ingress-operator/manifests/01-role-binding.yaml
oc create -f cluster-ingress-operator/manifests/01-role.yaml
oc create -f cluster-ingress-operator/manifests/01-service-account.yaml
```
//Created Manually to avoid creating an operator deployment since we're running
our operator locally//

**Run the Operator locally**

```
export KUBECONFIG="$HOME/Go/src/github.com/openshift/installer/auth/kubeconfig"
cd /home/ichavero/Go/src/github.com/openshift/cluster-ingress-operator/
operator-sdk up local namespace openshift-ingress-operator --kubeconfig=$KUBECONFIG
```

