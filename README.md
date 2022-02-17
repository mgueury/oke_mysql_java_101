# Demo OKE MySQL Java

## Prerequisite 

### OCI tenant 
If you have already an Oracle Cloud account, skip this step.

### Kubernetes
If you have already a Kubernetes running on OCI, skip this step.

### MySQL
If you have already a MySQL database running on OCI, and accessible from OKE, skip this step.

#### Note: your MySQL database run in a separate VCN
Setup a VCN peering.

## MySQL - Creation of the table

The database used for the demo is running on 10.1.1.237 with the password root/Welcome1!
You will need to change this to your needs.

<code>
mysqlsh root@10.1.1.237
Welcome1!
\sql
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
</code>

## Demo 1 - Java 

Check file QueryDB.java, Dockerfile, bin/build.sh
<code>
  cd oke_mysql_java_101/demo1
  bin/build.sh
  docker run querydb
  docker run -it --entrypoint /bin/bash querydb
  ls
  exit
</code>

## Demo 2 V1 - SpringBoot - hardcoded values

<code>
  cd oke_mysql_java_101/demo2/v1
  bin/build.sh
  bin/push.sh
  kubectl apply -f webquerydb1.yaml 
  kubectl get service
  curl http://xx.xx.xx.xx/query
</code>

## Demo 2 V2 - SpringBoot - configMap and secrets

<code>
  cd oke_mysql_java_101/demo2/v2
  bin/config.sh
  bin/build.sh
  bin/push.sh
  kubectl apply -f webquerydb2.yaml
  kubectl get pods | grep web
  curl http://129.159.203.100/query
</code>

