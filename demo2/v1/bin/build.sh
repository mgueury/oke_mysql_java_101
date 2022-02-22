SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/../../../bin/env.sh

./mvnw clean package
docker build -t webquerydb:v1 .
docker images | grep webquerydb

