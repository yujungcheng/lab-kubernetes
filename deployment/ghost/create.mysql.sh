#!/bin/bash

cd ../../persistent-volume/nfs.pod.mysql
./apply.sh
cd -

# change password to match initialised test account
kubectl exec -ti mysql-b2xkb -- mysql -utest -ptest_password -e "create database if not exists ghost; show databases;"

echo "make sure ghost db is created!!!"