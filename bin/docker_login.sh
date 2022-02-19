. ./env.sh
# Login to docker
docker login $OCI_REGION -u $OCI_NAMESPACE/$OCI_USERNAME -p "$OCI_TOKEN"
# OCI Repository prefix
export DOCKER_PREFIX=$OCI_REGION/$OCI_NAMESPACE/marc

