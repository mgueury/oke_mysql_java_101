SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/../../../bin/env.sh

./mvnw clean package -Pdistroless
docker build -t webquerydb-native:v3 .
docker images | grep webquerydb-native

