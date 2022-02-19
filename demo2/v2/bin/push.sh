. ../../bin/docker_login.sh
docker tag webquerydb:v2 $DOCKER_PREFIX/webquerydb:v2
docker push $DOCKER_PREFIX/webquerydb:v2
