# Sample - Oracle Cloud - Kubernetes(OKE), MySQL and Java

## Prerequisite 

If you don't already have 
- an Oracle Cloud account (OCI), 
- or OKE (Kubernetes) installed on it. 

Please follow this step-by-step:
- https://oracle.github.io/learning-library/oci-library/oci-hol/OKE/workshops/freetier/index.html?lab=oke

### Code

Open the OCI cloud console and clone this repository:

```
git clone https://github.com/mgueury/oke_mysql_java_101.git
```

### MySQL
If you have already a MySQL database running on OCI, and accessible from OKE, skip this step.

There are 2 main ways to create a MySQL database.

#### A. MySQL Database System. 
In OCI console, 
- Go to Database / MySQL, 
- Click create and follow the wizard. 
- To make it easy, reuse the network setup of OKE, VCN and the NodeSubnet, such that no special networking is needed. 
- If you decide to create a separate VCN, VCN peering will be needed. 
- Doc here: https://docs.oracle.com/en-us/iaas/mysql-database/doc/creating-db-system1.html#GUID-AE89C67D-E1B1-4F11-B934-8B0564B4FC69

#### B. Install MySQL in Kubernetes 

The documentation is here:
- https://kubernetes.io/docs/tasks/run-application/run-single-instance-stateful-application/

Here is an example to create a MySQL server with username/password = root/Welcome1!

```
kubectl create -f setup/oke_mysql.yaml 
```

To allow the connection to the MySQL database from your console you need
to allow the user root to do so:

```
kubectl exec -it deployment/mysql -- bash
mysql -uroot -pWelcome1!
CREATE USER 'root'@'%' IDENTIFIED BY 'Welcome1!';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
exit
exit
```

Then forward the MySQL port to your console and try to connect

```
kubectl port-forward deployment/mysql 3306 &
mysql -h127.0.0.1 -uroot -pWelcome1!
exit
```

### Environment variables

Edit the file bin/env.sh to match your OCI connection details and MySQL connection.
```
cd bin
cp env.sh.sample env.sh
vi env.sh
...
OCI_REGION=fra.ocir.io
OCI_NAMESPACE=frabcdefghjij
OCI_EMAIL=marc.gueury@oracle.com
OCI_USERNAME=oracleidentitycloudservice/marc.gueury@oracle.com
OCI_TOKEN="this_isAToken!"
MYSQL_IP=10.1.1.237
MYSQL_USER=root
MYSQL_PASSWORD=Welcome1!
...
```

## MySQL - Creation of the table

You can find the script to create the DB table in the directory setup. It uses the environment variables set above.
```
cd setup
./mysql_create_db_table.sh
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
select * from t1;
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

If your MySQL run on Kubernetes, you will need to forward the port to the console see above and use the forwarded port.
This means
```
...
CMD ["java", "-classpath",  "lib/*:.", "QueryDB", "jdbc:mysql://localhost/db1?user=root&password=Welcome1!"] 
...
```

To build and run the docker container, do this.

```
bin/build.sh
docker run querydb

If the port is forward from Kubernetes to localhost:3306
docker run --net=host querydb
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

First, let's finish the Kubernetes setup. Create the registry secret to allow Kubernetes to pull the image from the container registry
```
bin/create_registy_secret.sh
```

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

## Known issue

#### demo 2 v1 or v2 compilation fails

```
Caused by: java.lang.IllegalArgumentException: invalid target release: 11
    at com.sun.tools.javac.main.OptionHelper$GrumpyHelper.error (OptionHelper.java:103)
    at com.sun.tools.javac.main.Option$12.process (Option.java:216)
    at com.sun.tools.javac.api.JavacTool.processOptions (JavacTool.java:217)
    at com.sun.tools.javac.api.JavacTool.getTask (JavacTool.java:156)
    at com.sun.tools.javac.api.JavacTool.getTask (JavacTool.java:107)
```

- Cause: you are using JDK8. 
- WA: edit pom.xml 
  - OLD: <java.version>11</java.version>  
  - NEW: <java.version>8</java.version>
