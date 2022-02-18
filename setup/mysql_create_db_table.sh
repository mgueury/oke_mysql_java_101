#!/bin/sh
# Get the DB connection details
. ../bin/env.sh

# Create the table in the mysql DB
cat << EOF | mysqlsh $DB_USER@$DB_IP --password=$DB_PASSWORD --sql 
show databases;
create database db3;
use db3;

CREATE TABLE t1 (
 id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(20) NOT NULL
);
insert into t1( name ) values ( 'DOLPHIN');
insert into t1( name ) values ( 'TIGER');
insert into t1( name ) values ( 'PINGUIN');
insert into t1( name ) values ( 'LION');
select * from t1;
EOF
