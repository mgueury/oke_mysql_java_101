#!/bin/sh
# Get the DB connection details
. ../bin/env.sh

# Create the table in the mysql DB
cat << EOF | mysql -h$DB_IP -u$DB_USER -p$DB_PASSWORD 
show databases;
create database db4;
use db4;

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
