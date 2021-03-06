
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

