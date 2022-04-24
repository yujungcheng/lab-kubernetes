#!/bin/bash

kubectl delete -f ghost.sqlite3.yaml
kubectl delete -f ghost.mysql.yaml

cd ../../persistent-volume/nfs.pod.mysql
./delete.sh
cd -

kubectl delete configmap ghost-config-sqlite3
kubectl delete configmap ghost-config-mysql