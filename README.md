# Sample - Oracle Cloud - Kubernetes(OKE), MySQL and Java

## Prerequisite 

If you don't already have 
- an Oracle Cloud account (OCI), 
- or OKE (Kubernetes) installed on it. 

Please follow this step-by-step:
- https://oracle.github.io/learning-library/oci-library/oci-hol/OKE/workshops/freetier/index.html?lab=oke

### MySQL
If you have already a MySQL database running on OCI, and accessible from OKE, skip this step.

There are 2 main ways to create a MySQL database.

#### A. Mysql Database System. 
In OCI console, 
- Go to Database / MySQL, 
- Click create and follow the wizard. 
- To make it easy, reuse the network setup of OKE, VCN and the NodeSubnet, such that no special networking is needed. 
- If you decide to create a separate VCN, VCN peering will be needed. 
- Doc here: https://docs.oracle.com/en-us/iaas/mysql-database/doc/creating-db-system1.html#GUID-AE89C67D-E1B1-4F11-B934-8B0564B4FC69

#### B. Install MySQL in Kubernetes 

Please use these instructions,
- https://kubernetes.io/docs/tasks/run-application/run-single-instance-stateful-application/

It will create a persistent volume to keep your data if the container is lost.
There is a sample YAML to create a mysql-server instance in OKE in setup/oke_mysql.yaml. Notice that it works also ARM processors. 

```
kubectl create -f oke_mysql.yaml 
kubectl exec -it deployment/mysql -- sh
mysqlsh root@127.0.0.1 --password=Welcome1!
```

## MySQL - Creation of the table

Open the OCI cloud console and clone this repository:

```
git clone https://github.com/mgueury/oke_mysql_java_101.git
```

The database used for the demo is running on 10.1.1.237 with the password root/Welcome1!

Edit the file bin/env.sh to match your MySQL connection.
```
vi bin/env.sh
...
DB_IP=10.1.1.237
DB_USER=root
DB_PASSWORD=Welcome1!
...
```

You can find the script to create the DB table in the directory setup. 
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

To build and run the docker container, do this.

```
bin/build.sh
docker run querydb
```

You will see:

```
1 DOLPHIN
2 TIGER
3 PINGUIN
4 LION
```

To check what the container contains:

```
docker run -it --entrypoint /bin/bash querydb
ls
exit
```

## Demo 2 V1 - SpringBoot - hardcoded values

In this demo too, the DB details are hardcoded. To modify them:

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

You will see
```
1:DOLPHIN 2:TIGER 3:PINGUIN 4:LION
```


## Demo 2 V2 - SpringBoot - configMap and secrets

In this demo, the DB details are stored in Kubernetes configMap or secrets.
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

You will see
```
1:DOLPHIN 2:TIGER 3:PINGUIN 4:LION
```

If you reach this point, CONGRATULATION !! You have a MySQL database, a Springboot application in Java running in Kubernetes using configMap and secrets.
