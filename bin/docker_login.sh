SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/env.sh

# Login to docker
docker login $OCI_REGION -u $OCI_NAMESPACE/$OCI_USERNAME -p "$OCI_TOKEN"
# OCI Repository prefix
export DOCKER_PREFIX=$OCI_REGION/$OCI_NAMESPACE/marc

