#!/bin/bash

kubectl delete -f ghost.sqlite3.yaml
kubectl delete -f ghost.mysql.yaml

cd ../../persistent-volume/pod.mysql
./delete.sh
cd -

kubectl delete configmap --from-file ghost-config.sqlite3.js ghost-config-sqlite3
kubectl delete configmap --from-file ghost-config.mysql.js ghost-config-mysql