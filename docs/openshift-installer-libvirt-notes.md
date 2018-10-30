# OpenShift Installer Notes

* The installer is based on the tectonic installer from CoreOS
* Currently there are only two platforms: aws and libvirt

## libvirt

**If you already used the installer, you might nedd to update your terraform plugin:**

```console
GOBIN=$HOME/.terraform.d/plugins go get -u github.com/dmacvicar/terraform-provider-libvirt
```

**The installer needs to be built with the TAGS=libvirt_destroy tag:**

```console
$ TAGS=libvirt_destroy hack/build.sh
```

**Don't forget to use the tectonic-operators pull secret from the slack forum-installer**
*(This sould be put in a more formal place)*

**Environment Variables**

```bash
# Environment variables for the OpenShift 4.x installer
# Modify them to suit your environment
# copy them to the installer path and source them:
# cp openshift-libvirt.sh $HOME/Go/src/github.com/openshift/installer/.
# source openshift-libvirt.sh

export OPENSHIFT_INSTALLER_PATH="${HOME}/Go/src/github.com/openshift/installer"
export OPENSHIFT_INSTALL_PLATFORM=libvirt
export OPENSHIFT_INSTALL_BASE_DOMAIN=tt.testing
export OPENSHIFT_INSTALL_CLUSTER_NAME=test1
export OPENSHIFT_INSTALL_PULL_SECRET_PATH="${OPENSHIFT_INSTALLER_PATH}/secrets"
export OPENSHIFT_INSTALL_LIBVIRT_URI=qemu+tcp://192.168.1.1/system
export OPENSHIFT_INSTALL_EMAIL_ADDRESS="example@example.com"
export OPENSHIFT_INSTALL_PASSWORD="test"
export OPENSHIFT_INSTALL_SSH_PUB_KEY="$(<~/.ssh/id_rsa.pub)"
```

**Always run the installer with the --dir flag**

```console
$ bin/openshift-install create cluster --dir $OPENSHIFT_INSTALL_CLUSTER_NAME --log-level=debug
```

**Always delete `$OPENSHIFT_INSTALL_CLUSTER_NAME` after destroying the cluster**

```
rm -rf $OPENSHIFT_INSTALL_CLUSTER_NAME
```


Here's a little [Helper Script](https://raw.githubusercontent.com/imcsk8/origin-tools/master/openshift-installer-libvirt.sh)

## References
https://github.com/openshift/installer/blob/master/docs/dev/libvirt-howto.md
https://github.com/openshift/installer

