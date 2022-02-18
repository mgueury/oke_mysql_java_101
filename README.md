# Sample - Oracle Cloud - Kubernetes(OKE), MySQL and Java

## Prerequisite 

If you don't already have 
- an Oracle Cloud account (OCI), 
- or OKE (Kubernetes) installed on it. 

Please follow this step-by-step:
- https://oracle.github.io/learning-library/oci-library/oci-hol/OKE/workshops/freetier/index.html?lab=oke

### MySQL
If you have already a MySQL database running on OCI, and accessible from OKE, skip this step.

Note: if your MySQL database run in a separate VCN, you will need to setup a VCN peering.

## MySQL - Creation of the table

The database used for the demo is running on 10.1.1.237 with the password root/Welcome1!
You will need to change this to your needs.

First, edit the file bin/env.sh to match your MySQL connection
You can find the script to create the DB table in the directory setup. 
Then run 
```
setup/mysql_create_db_table.sh
```

It will do this:
```
show databases;
create database db1;
use db1;

CREATE TABLE t1 (
 id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(20) NOT NULL
);
insert into t1( name ) values ( 'DOLPHIN');
insert into t1( name ) values ( 'TIGER');
insert into t1( name ) values ( 'PINGUIN');
insert into t1( name ) values ( 'LION');
```

## Demo 1 - Java 

In this demo, the DB details are hardcoded in the Dockerfile.

Edit Dockerfile and replace with your DB details

```
cd oke_mysql_java_101/demo1
vi Dockerfile
...
CMD ["java", "-classpath",  "lib/*:.", "QueryDB", "jdbc:mysql://10.1.1.237/db1?user=root&password=Welcome1!"] 
...
```

To build the docker container, please do this.

```
bin/build.sh
docker run querydb
```

To check what the container contains:

```
docker run -it --entrypoint /bin/bash querydb
ls
exit
```

## Demo 2 V1 - SpringBoot - hardcoded values

In this demo too, the DB details are hardcoded.
To modify them

```
cd oke_mysql_java_101/demo2/v1
vi src/main/java/com/mysql/web/basic/BasicController.java
...
  private String DB_URL = "jdbc:mysql://10.1.1.237/db1?user=root&password=Welcome1!";
...
```

Then build the docker image, push it to the registry and run it,

```
bin/build.sh
bin/push.sh
kubectl apply -f webquerydb1.yaml 
kubectl get pods | grep webquerydb
kubectl get service webquerydb-service

NAME                 TYPE           CLUSTER-IP      EXTERNAL-IP       PORT(S)        AGE
webquerydb-service   LoadBalancer   10.96.105.230   123.123.123.123   80:32114/TCP   18d

# Here you will get the EXTERNAL-IP of the service. Then use it to test
curl http://123.123.123.123/query
```

## Demo 2 V2 - SpringBoot - configMap and secrets

In this demo too, the DB details are stored in Kubernetes configMap or secrets.
To modify them

```
cd oke_mysql_java_101/demo2/v2
vi bin/config.sh
...
kubectl create secret generic db-secret --from-literal=username=root --from-literal=password=Welcome1!
...

vi webquerydb-cfg.yaml
...
    {
      "webquerydb.db.url": "jdbc:mysql://10.1.1.237/db1"
    }
...

```

Then rebuild the program, docker image and deploy it in Kubernetes

```
cd oke_mysql_java_101/demo2/v2
bin/config.sh
bin/build.sh
bin/push.sh
kubectl apply -f webquerydb2.yaml
# Same EXTERNAL IP than above
curl http://123.123.123.123/query
```
