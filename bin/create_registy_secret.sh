. ./env.sh
kubectl create secret docker-registry ocirsecret --docker-server=$OCI_REGION --docker-username="$OCI_NAMESPACE/$OCI_USERNAME' --docker-password="$OCI_TOKEN" --docker-email="$OCI_EMAIL"
