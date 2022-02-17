./mvnw clean package
docker build -t webquerydb:v2 .
docker images | grep webquerydb

