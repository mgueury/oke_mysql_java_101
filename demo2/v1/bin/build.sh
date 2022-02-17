./mvnw clean package
docker build -t webquerydb:v1 .
docker images | grep webquerydb

