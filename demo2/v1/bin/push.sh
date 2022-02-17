. $HOME/data/kubernetes/docker_login.sh
docker tag webquerydb:v1 $DOCKER_PREFIX/webquerydb:v1
docker push $DOCKER_PREFIX/webquerydb:v1
