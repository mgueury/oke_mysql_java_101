SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. $SCRIPT_DIR/../../../bin/env.sh

export PATH=$GRAALVM_HOME/bin:$PATH
./mvnw clean package -Pdistroless
docker build -t webquerydb-native:v3 .
docker images | grep webquerydb-native

