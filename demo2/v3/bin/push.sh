SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/../../../bin/docker_login.sh

docker tag webquerydb:v2 $DOCKER_PREFIX/webquerydb:v2
docker push $DOCKER_PREFIX/webquerydb:v2
